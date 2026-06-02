#' Run the BILJOU daily water balance
#'
#' Iterates the daily water balance \eqn{\Delta W = P - In - T - Eu - D}
#' (Granier et al. 1999, Eq. 1) over a meteorological time series, following
#' the model flow chart: for each day the LAI sets interception, overstorey
#' transpiration and understorey evaporation; throughfall infiltrates and
#' refills the soil layers (with fast macroporosity bypass and drainage of any
#' excess above field capacity); transpiration and understorey evaporation are
#' withdrawn from the layers; soil water content, relative extractable water
#' (REW) and the daily soil-water deficit are updated.
#'
#' Regulation rules applied each day:
#' \itemize{
#'   \item Wet-canopy reduction: transpiration is lowered by 20\% of the
#'     intercepted water (Rutter 1967), because intercepted water evaporates
#'     faster than the canopy transpires.
#'   \item Water-stress reduction: when total REW falls below \code{rew_c}
#'     (default 0.4) transpiration is scaled by \code{REW / rew_c}; understorey
#'     evaporation is scaled by the upper-layer \code{REW1 / rew_c}.
#'   \item Actual evapotranspiration (T + Eu + In) is capped at
#'     \code{et_max_ratio} times PET (default 1.2).
#' }
#'
#' @param meteo A data frame with one row per day and columns:
#'   \code{date} (Date or coercible), \code{pet} (mm) and \code{rain} (mm).
#'   A \code{doy} column is used if present, otherwise it is derived from
#'   \code{date}.
#' @param soil A \code{\link{biljou_soil}} object.
#' @param lai_max Maximum leaf area index.
#' @param forest_type "broadleaved" (deciduous) or "coniferous" (evergreen).
#' @param budburst,leaf_fall Day-of-year of budburst and complete leaf fall
#'   (deciduous stands only).
#' @param rew_c Critical relative extractable water below which transpiration is
#'   regulated (default 0.4).
#' @param k Light extinction coefficient (default 0.5).
#' @param et_max_ratio Cap on actual ET as a multiple of PET (default 1.2).
#' @param wet_canopy_factor Fraction of intercepted water subtracted from
#'   transpiration (default 0.2).
#' @param interception_coef Optional override of the interception coefficients
#'   (see \code{\link{rainfall_interception}}).
#' @return An object of class \code{biljou_run}: a list with \code{daily} (a
#'   data frame of daily fluxes and states) and \code{soil}/\code{params}.
#' @examples
#' data(meteo_hesse)
#' soil <- biljou_soil(ewm = c(60, 60, 60),
#'                     roots = c(0.6, 0.3, 0.1))
#' run <- biljou_run(meteo_hesse, soil, lai_max = 6,
#'                   forest_type = "broadleaved",
#'                   budburst = 110, leaf_fall = 300)
#' head(run$daily)
#' @references Granier A, Breda N, Biron P, Villette S (1999) Ecological
#'   Modelling 116:269-283.
#' @export
biljou_run <- function(meteo, soil, lai_max,
                       forest_type = c("broadleaved", "coniferous"),
                       budburst = NULL, leaf_fall = NULL,
                       rew_c = 0.4, k = 0.5, et_max_ratio = 1.2,
                       wet_canopy_factor = 0.2, interception_coef = NULL) {

  forest_type <- match.arg(forest_type)
  if (!inherits(soil, "biljou_soil")) stop("`soil` must be a biljou_soil object.")
  req <- c("pet", "rain")
  if (!all(req %in% names(meteo)))
    stop("`meteo` must contain columns: ", paste(req, collapse = ", "), ".")

  if (!"doy" %in% names(meteo)) {
    if (!"date" %in% names(meteo))
      stop("`meteo` needs a `date` column or a `doy` column.")
    meteo$date <- as.Date(meteo$date)
    meteo$doy <- as.integer(format(meteo$date, "%j"))
  }
  if (!"date" %in% names(meteo)) meteo$date <- seq_len(nrow(meteo))

  n_days <- nrow(meteo)
  lai_series <- biljou_lai(meteo$doy, lai_max, forest_type, budburst, leaf_fall)

  # State: extractable water per layer (start from init relative content)
  ew <- soil$ewm * soil$init
  ewm_total <- soil$ewm_total

  out <- data.frame(
    date = meteo$date, doy = meteo$doy,
    rain = meteo$rain, pet = meteo$pet, lai = lai_series,
    interception = NA_real_, throughfall = NA_real_,
    transpiration = NA_real_, understorey = NA_real_,
    et = NA_real_, drainage = NA_real_,
    soil_water = NA_real_, rew = NA_real_, swd = NA_real_
  )

  for (t in seq_len(n_days)) {
    p   <- meteo$rain[t]
    pet <- meteo$pet[t]
    lai <- lai_series[t]
    rew_before <- sum(ew) / ewm_total

    # 1. Interception & throughfall
    inter <- rainfall_interception(p, lai, forest_type, k = k,
                                   coef = interception_coef)
    throughfall <- p - inter

    # 2. Potential overstorey transpiration, wet-canopy & stress reductions
    tp <- potential_transpiration(pet, lai)
    tp <- max(0, tp - wet_canopy_factor * inter)
    if (rew_before < rew_c) tp <- tp * (rew_before / rew_c)

    # 3. Potential understorey/soil evaporation, limited by upper-layer water
    eu <- potential_understorey_evap(pet, lai, k = k)
    rew1 <- ew[1] / soil$ewm[1]
    if (rew1 < rew_c) eu <- eu * (rew1 / rew_c)
    eu <- max(0, eu)

    # 4. Cap actual evapotranspiration at et_max_ratio * PET
    et_cap <- et_max_ratio * pet
    et_dry <- tp + eu                       # transpiration + understorey
    if (et_dry + inter > et_cap && et_dry > 0) {
      scale <- max(0, (et_cap - inter)) / et_dry
      tp <- tp * scale
      eu <- eu * scale
    }

    # 5. Infiltration of throughfall (refill + drainage)
    inf <- .infiltrate(ew, throughfall, soil)
    ew <- inf$ew
    drainage <- inf$drainage

    # 6. Withdraw understorey evaporation from the upper layer
    eu_take <- min(eu, ew[1])
    ew[1] <- ew[1] - eu_take

    # 7. Withdraw transpiration across layers (root- and REW-weighted)
    up <- .uptake(ew, tp, soil)
    ew <- up$ew
    t_take <- up$taken

    # 8. Update state variables
    sw <- sum(ew)
    rew <- sw / ewm_total
    swd <- max(0, rew_c * ewm_total - sw)   # deficit vs critical threshold

    out$interception[t]  <- inter
    out$throughfall[t]   <- throughfall
    out$transpiration[t] <- t_take
    out$understorey[t]   <- eu_take
    out$et[t]            <- inter + t_take + eu_take
    out$drainage[t]      <- drainage
    out$soil_water[t]    <- sw
    out$rew[t]           <- rew
    out$swd[t]           <- swd
  }

  structure(
    list(daily = out, soil = soil,
         params = list(lai_max = lai_max, forest_type = forest_type,
                       budburst = budburst, leaf_fall = leaf_fall,
                       rew_c = rew_c, k = k, et_max_ratio = et_max_ratio,
                       ewm_total = ewm_total)),
    class = "biljou_run"
  )
}

#' @export
print.biljou_run <- function(x, ...) {
  d <- x$daily
  cat("<biljou_run>:", nrow(d), "days,",
      x$params$forest_type, "stand, LAI_max =", x$params$lai_max, "\n")
  cat("Period:", as.character(min(d$date)), "to", as.character(max(d$date)), "\n")
  cat(sprintf("Totals (mm): rain=%.0f  interception=%.0f  transpiration=%.0f  understorey=%.0f  drainage=%.0f\n",
              sum(d$rain), sum(d$interception), sum(d$transpiration),
              sum(d$understorey), sum(d$drainage)))
  cat(sprintf("Min REW=%.2f  stress days (REW<%.2f)=%d\n",
              min(d$rew), x$params$rew_c, sum(d$rew < x$params$rew_c)))
  invisible(x)
}
