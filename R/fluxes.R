#' BILJOU canopy & flux equations
#'
#' These functions implement the daily ecophysiological relationships of the
#' BILJOU water balance model (Granier et al. 1999, Ecological Modelling
#' 116:269-283). Water fluxes are expressed in mm (1 mm = 1 L m-2).
#'
#' @name biljou-fluxes
NULL

# ---------------------------------------------------------------------------
# Light transmission through the canopy (Beer-Lambert)
# ---------------------------------------------------------------------------

#' Fraction of incident radiation transmitted through the canopy
#'
#' Beer-Lambert extinction \eqn{R/R0 = exp(-k * LAI)}. Granier et al. (1999)
#' use an extinction coefficient \eqn{k = 0.5} for both broadleaved and
#' coniferous stands.
#'
#' @param lai Leaf area index (m2 m-2).
#' @param k Light extinction coefficient (default 0.5).
#' @return Transmitted fraction in \eqn{[0, 1]}.
#' @export
radiation_transmittance <- function(lai, k = 0.5) {
  exp(-k * lai)
}

# ---------------------------------------------------------------------------
# Phenology: daily LAI course
# ---------------------------------------------------------------------------

#' Daily leaf area index from phenology
#'
#' Builds the seasonal LAI course. Coniferous (evergreen) stands keep a
#' constant LAI all year. Broadleaved (deciduous) stands have LAI = 0 outside
#' the leafed period; LAI rises linearly from 0 to \code{lai_max} during the
#' 30 days following budburst and falls linearly back to 0 during the 30 days
#' preceding leaf fall (Granier et al. 1999; INRAE BILJOU documentation).
#'
#' @param doy Integer vector of day-of-year values (1-366).
#' @param lai_max Maximum (plateau) leaf area index.
#' @param forest_type "broadleaved" (deciduous) or "coniferous" (evergreen).
#' @param budburst Day-of-year of budburst (required if deciduous).
#' @param leaf_fall Day-of-year of complete leaf fall (required if deciduous).
#' @param ramp Duration of the leaf expansion / senescence ramp, days
#'   (default 30).
#' @return Numeric vector of daily LAI, same length as \code{doy}.
#' @export
biljou_lai <- function(doy, lai_max, forest_type = c("broadleaved", "coniferous"),
                       budburst = NULL, leaf_fall = NULL, ramp = 30) {
  forest_type <- match.arg(forest_type)
  if (forest_type == "coniferous") {
    return(rep(lai_max, length(doy)))
  }
  if (is.null(budburst) || is.null(leaf_fall)) {
    stop("budburst and leaf_fall (day-of-year) are required for deciduous stands.")
  }
  lai <- numeric(length(doy))
  full_start <- budburst + ramp          # first day at full LAI
  full_end   <- leaf_fall - ramp         # last day at full LAI
  for (i in seq_along(doy)) {
    d <- doy[i]
    if (d < budburst || d > leaf_fall) {
      lai[i] <- 0
    } else if (d < full_start) {
      lai[i] <- lai_max * (d - budburst) / ramp        # leaf expansion
    } else if (d > full_end) {
      lai[i] <- lai_max * (leaf_fall - d) / ramp       # senescence
    } else {
      lai[i] <- lai_max                                # plateau
    }
  }
  pmax(0, pmin(lai_max, lai))
}

# ---------------------------------------------------------------------------
# Overstorey transpiration
# ---------------------------------------------------------------------------

#' Potential stand transpiration ratio r = T / PET
#'
#' Under non-limiting soil water, the ratio of stand transpiration to potential
#' evapotranspiration depends on LAI (Granier et al. 1999, Eq. 2):
#' \deqn{r = 0.125 \, LAI \quad \mathrm{if}\ 0 \le LAI \le 6}
#' \deqn{r = 0.75 \quad \mathrm{if}\ LAI > 6}
#'
#' @param lai Leaf area index.
#' @param r_max Maximum T/PET ratio at high LAI (default 0.75).
#' @param lai_threshold LAI above which r is saturated (default 6).
#' @return T/PET ratio.
#' @export
transpiration_ratio <- function(lai, r_max = 0.75, lai_threshold = 6) {
  slope <- r_max / lai_threshold     # 0.125 for defaults
  ifelse(lai > lai_threshold, r_max, slope * lai)
}

#' Daily potential overstorey transpiration
#'
#' \eqn{T_p = r(LAI) \times PET}. The water-stress reduction (when relative
#' extractable water drops below \code{rew_c}) and the wet-canopy reduction are
#' applied in \code{\link{biljou_run}}.
#'
#' @param pet Potential evapotranspiration (mm).
#' @param lai Leaf area index.
#' @param r_max,lai_threshold See \code{\link{transpiration_ratio}}.
#' @return Potential transpiration (mm).
#' @export
potential_transpiration <- function(pet, lai, r_max = 0.75, lai_threshold = 6) {
  transpiration_ratio(lai, r_max, lai_threshold) * pet
}

# ---------------------------------------------------------------------------
# Rainfall interception
# ---------------------------------------------------------------------------

#' Daily rainfall interception (Granier et al. 1999, Eq. 3)
#'
#' Throughfall is modelled after Aussenac (1968):
#' \deqn{Th = exp(a + b \cdot R/R0 + c \cdot P + d \cdot P^2)}
#' \deqn{In = P - Th}
#' where \eqn{R/R0} is the percentage of incident radiation transmitted through
#' the canopy, here \eqn{100 \cdot exp(-k\,LAI)}. Default coefficients differ
#' between stand types:
#' \itemize{
#'   \item broadleaved: a = 0.186, b = 0.0027, c = 0.229, d = -0.0043
#'   \item coniferous:  a = -0.124, b = 0.0080, c = 0.257, d = -0.0058
#' }
#' Below a saturation threshold (1 mm broadleaved, 2 mm coniferous) all rainfall
#' is intercepted. Interception is clamped to \eqn{[0, P]}.
#'
#' @param p Incident rainfall (mm).
#' @param lai Leaf area index.
#' @param forest_type "broadleaved" or "coniferous".
#' @param k Light extinction coefficient (default 0.5).
#' @param coef Optional named list/vector with a, b, c, d overriding defaults.
#' @param min_rain Saturation threshold below which In = P (mm). Defaults to
#'   1 (broadleaved) or 2 (coniferous).
#' @return Interception (mm).
#' @references Aussenac G (1968) Ann. Sci. For. 25:135-156.
#' @export
rainfall_interception <- function(p, lai, forest_type = c("broadleaved", "coniferous"),
                                   k = 0.5, coef = NULL, min_rain = NULL) {
  forest_type <- match.arg(forest_type)
  defaults <- if (forest_type == "broadleaved") {
    c(a = 0.186, b = 0.0027, c = 0.229, d = -0.0043)
  } else {
    c(a = -0.124, b = 0.0080, c = 0.257, d = -0.0058)
  }
  if (!is.null(coef)) defaults[names(coef)] <- unlist(coef)
  if (is.null(min_rain)) min_rain <- if (forest_type == "broadleaved") 1 else 2

  rr0 <- 100 * radiation_transmittance(lai, k)        # % transmitted
  a <- defaults["a"]; b <- defaults["b"]; cc <- defaults["c"]; d <- defaults["d"]
  th <- exp(a + b * rr0 + cc * p + d * p^2)
  inter <- p - th
  # Full interception of very small events
  inter <- ifelse(p <= min_rain, p, inter)
  # No leaves -> no interception
  inter <- ifelse(lai <= 0, 0, inter)
  as.numeric(pmax(0, pmin(p, inter)))
}

# ---------------------------------------------------------------------------
# Understorey + soil evaporation
# ---------------------------------------------------------------------------

#' Potential understorey + soil evaporation
#'
#' Eu is assumed proportional to the energy reaching the forest floor, i.e. to
#' the radiation transmitted through the canopy (Granier et al. 1999):
#' \deqn{Eu_p = PET \times exp(-k \, LAI)}
#' The soil-water limitation (via the upper layer) is applied in
#' \code{\link{biljou_run}}.
#'
#' @param pet Potential evapotranspiration (mm).
#' @param lai Leaf area index.
#' @param k Light extinction coefficient (default 0.5).
#' @return Potential understorey + soil evaporation (mm).
#' @export
potential_understorey_evap <- function(pet, lai, k = 0.5) {
  pet * radiation_transmittance(lai, k)
}
