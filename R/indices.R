#' Drought indices from a BILJOU run
#'
#' Computes, per year, the drought indicators defined by BILJOU (Granier et al.
#' 1999, Eqs. 4-5; INRAE "indicateurs de secheresse"):
#' \itemize{
#'   \item \code{stress_days}: number of days with REW below \code{rew_c}.
#'   \item \code{is_index}: cumulative water-stress index
#'     \eqn{Is = \sum SWD / EWM}, where \eqn{SWD = 0.4\,EWM - EW} on stressed
#'     days (a dimensionless integral of the deficit, the dashed area under the
#'     REW curve).
#'   \item \code{intensity}: maximum daily \eqn{SWD/EWM} (peak relative deficit)
#'     and the minimum REW reached.
#'   \item \code{precocity}: day-of-year of the first stress day (earliness of
#'     drought onset).
#' }
#' For deciduous stands the indicators are accumulated over the leafed period
#' (budburst to leaf fall); for evergreen stands over the whole year.
#'
#' @param run A \code{\link{biljou_run}} object.
#' @return A data frame with one row per year.
#' @export
biljou_indices <- function(run) {
  if (!inherits(run, "biljou_run")) stop("`run` must be a biljou_run object.")
  d <- run$daily
  p <- run$params
  ewm <- p$ewm_total
  rew_c <- p$rew_c

  if (inherits(d$date, "Date")) {
    year <- as.integer(format(d$date, "%Y"))
  } else {
    year <- rep(1L, nrow(d))
  }

  # Restrict to the leafed period for deciduous stands
  in_period <- rep(TRUE, nrow(d))
  if (p$forest_type == "broadleaved" && !is.null(p$budburst)) {
    in_period <- d$doy >= p$budburst & d$doy <= p$leaf_fall
  }

  res <- lapply(sort(unique(year)), function(y) {
    sel <- year == y & in_period
    dd <- d[sel, , drop = FALSE]
    if (!nrow(dd)) return(NULL)
    stressed <- dd$rew < rew_c
    swd <- dd$swd
    first_stress <- if (any(stressed)) dd$doy[which(stressed)[1]] else NA_integer_
    data.frame(
      year = y,
      stress_days = sum(stressed),
      is_index = sum(swd) / ewm,
      max_rel_deficit = max(swd) / ewm,
      min_rew = min(dd$rew),
      precocity_doy = first_stress,
      rain = sum(dd$rain),
      transpiration = sum(dd$transpiration),
      understorey = sum(dd$understorey),
      interception = sum(dd$interception),
      drainage = sum(dd$drainage),
      et = sum(dd$et)
    )
  })
  do.call(rbind, res)
}

#' Annual water balance summary
#'
#' Sums the elementary water fluxes by calendar year (full year, irrespective
#' of phenology), so that inputs and outputs can be checked against the balance
#' \eqn{P \approx In + T + Eu + D + \Delta W}.
#'
#' @param run A \code{\link{biljou_run}} object.
#' @return A data frame with one row per year.
#' @export
biljou_annual_balance <- function(run) {
  if (!inherits(run, "biljou_run")) stop("`run` must be a biljou_run object.")
  d <- run$daily
  year <- if (inherits(d$date, "Date")) as.integer(format(d$date, "%Y")) else rep(1L, nrow(d))
  agg <- function(v) tapply(v, year, sum)
  data.frame(
    year = as.integer(names(agg(d$rain))),
    rain = as.numeric(agg(d$rain)),
    interception = as.numeric(agg(d$interception)),
    throughfall = as.numeric(agg(d$throughfall)),
    transpiration = as.numeric(agg(d$transpiration)),
    understorey = as.numeric(agg(d$understorey)),
    et = as.numeric(agg(d$et)),
    drainage = as.numeric(agg(d$drainage)),
    row.names = NULL
  )
}

#' Quick plot of a BILJOU run
#'
#' Base-graphics plot of relative extractable water (REW) through time with the
#' critical threshold, and the main daily fluxes.
#'
#' @param x A \code{\link{biljou_run}} object.
#' @param ... Passed to \code{plot}.
#' @export
plot.biljou_run <- function(x, ...) {
  d <- x$daily
  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar))
  graphics::par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
  graphics::plot(d$date, d$rew, type = "l", ylim = c(0, 1),
                 xlab = "", ylab = "REW", main = "Relative extractable water", ...)
  graphics::abline(h = x$params$rew_c, lty = 2, col = "red")
  graphics::plot(d$date, d$transpiration, type = "l", col = "forestgreen",
                 xlab = "Date", ylab = "mm day-1", main = "Daily fluxes",
                 ylim = c(0, max(d$transpiration, d$pet, na.rm = TRUE)))
  graphics::lines(d$date, d$pet, col = "grey50")
  graphics::lines(d$date, d$understorey, col = "orange")
  graphics::legend("topright", c("PET", "Transpiration", "Understorey"),
                   col = c("grey50", "forestgreen", "orange"), lty = 1, bty = "n")
  invisible(x)
}
