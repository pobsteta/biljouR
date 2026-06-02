#' Penman potential evapotranspiration
#'
#' Computes daily reference potential evapotranspiration (PET, mm day-1) with
#' the Penman (1948) combination equation in the Shuttleworth (1993)
#' formulation. BILJOU was calibrated using Penman PET (Choisnel et al. 1992),
#' so PET is the natural climatic input of \code{\link{biljou_run}}. If you
#' already have Penman PET (e.g. from Meteo-France), feed it directly and skip
#' this helper.
#'
#' Net radiation is derived from incident global radiation and air temperature
#' following FAO-56 (Allen et al. 1998): net shortwave uses an albedo, net
#' longwave uses humidity and the clear-sky ratio, the latter requiring
#' extraterrestrial radiation computed from latitude and day of year.
#'
#' @param tmean Mean air temperature (degrees C).
#' @param rg Incident global radiation (MJ m-2 day-1). To convert from the
#'   J cm-2 used by Meteo-France, multiply by 0.01.
#' @param wind Wind speed at 2 m (m s-1). See \code{\link{wind_to_2m}} to
#'   convert from another height.
#' @param rh Mean relative humidity (\%). Provide either \code{rh} or
#'   \code{vpd}/\code{ea}.
#' @param ea Actual vapour pressure (kPa). Optional alternative to \code{rh}.
#' @param vpd Air vapour pressure deficit (kPa). Optional alternative.
#' @param doy Day of year (1-366), required for the longwave term.
#' @param latitude Latitude (decimal degrees), required for the longwave term.
#' @param altitude Site elevation (m, default 0).
#' @param albedo Surface albedo (default 0.2 for a reference vegetated surface;
#'   forests are darker, ~0.11-0.16).
#' @return Numeric vector of PET (mm day-1).
#' @references
#'   Penman HL (1948) Proc. R. Soc. Lond. A 193:120-145.
#'   Shuttleworth WJ (1993) in Handbook of Hydrology, McGraw-Hill.
#'   Allen RG et al. (1998) FAO Irrigation and Drainage Paper 56.
#' @examples
#' penman_pet(tmean = 18, rg = 22, wind = 2, rh = 65,
#'            doy = 180, latitude = 48.6, altitude = 250)
#' @export
penman_pet <- function(tmean, rg, wind, rh = NULL, ea = NULL, vpd = NULL,
                       doy = NULL, latitude = NULL, altitude = 0,
                       albedo = 0.2) {
  lambda <- 2.45                                   # MJ kg-1 latent heat
  es <- 0.6108 * exp(17.27 * tmean / (tmean + 237.3))   # sat. vapour pressure kPa
  delta <- 4098 * es / (tmean + 237.3)^2                # slope kPa C-1
  patm <- 101.3 * ((293 - 0.0065 * altitude) / 293)^5.26
  gamma <- 0.000665 * patm                              # psychrometric const kPa C-1

  if (!is.null(vpd)) {
    D <- vpd
    ea_v <- es - vpd
  } else if (!is.null(ea)) {
    ea_v <- ea
    D <- es - ea
  } else if (!is.null(rh)) {
    ea_v <- es * rh / 100
    D <- es - ea_v
  } else {
    stop("Provide one of `rh`, `ea` or `vpd` for the humidity term.")
  }
  D <- pmax(D, 0)

  # Net shortwave
  rns <- (1 - albedo) * rg

  # Net longwave (FAO-56). Needs clear-sky radiation -> extraterrestrial Ra.
  if (!is.null(doy) && !is.null(latitude)) {
    sigma <- 4.903e-9                              # MJ K-4 m-2 day-1
    phi <- latitude * pi / 180
    dr <- 1 + 0.033 * cos(2 * pi / 365 * doy)
    decl <- 0.409 * sin(2 * pi / 365 * doy - 1.39)
    ws <- acos(pmax(pmin(-tan(phi) * tan(decl), 1), -1))
    ra <- 24 * 60 / pi * 0.0820 * dr *
      (ws * sin(phi) * sin(decl) + cos(phi) * cos(decl) * sin(ws))
    rso <- (0.75 + 2e-5 * altitude) * ra
    ratio <- ifelse(rso > 0, pmin(rg / rso, 1), 0.5)
    tk4 <- (tmean + 273.16)^4
    rnl <- sigma * tk4 * (0.34 - 0.14 * sqrt(pmax(ea_v, 0))) *
      (1.35 * ratio - 0.35)
    rnl <- pmax(rnl, 0)
  } else {
    rnl <- 0
    warning("doy/latitude not supplied: net longwave radiation set to 0, ",
            "PET will be overestimated. Provide doy and latitude.")
  }
  rn <- rns - rnl

  # Penman combination (Shuttleworth 1993), G ~ 0 at daily step
  fu <- 6.43 * (1 + 0.536 * wind)                  # wind function MJ m-2 day-1 kPa-1
  pet <- (delta * rn + gamma * fu * D) / (lambda * (delta + gamma))
  as.numeric(pmax(pet, 0))
}

#' Adjust wind speed to a 2 m reference height
#'
#' Logarithmic profile used by BILJOU/FAO to bring a wind measurement at height
#' \code{z} to the 2 m standard height.
#'
#' @param u Wind speed measured at height \code{z} (m s-1).
#' @param z Measurement height (m).
#' @return Wind speed at 2 m (m s-1).
#' @export
wind_to_2m <- function(u, z) {
  u * 4.87 / log(67.8 * z - 5.42)
}
