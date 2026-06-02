#' Convert SAFRAN / SIM quotidienne data to the biljou meteo format
#'
#' Maps a Meteo-France "SIM quotidienne" (SAFRAN) data frame to the columns
#' expected by \code{\link{biljou_run}} (\code{date}, \code{rain}, \code{pet},
#' and optionally raw climate columns). By default rainfall is the sum of liquid
#' and solid precipitation and PET is taken from the SAFRAN reference
#' evapotranspiration \code{ETP_Q}.
#'
#' SAFRAN data (8x8 km grid, daily, 1958-present) are freely downloadable from
#' \url{https://meteo.data.gouv.fr} (dataset "Donnees changement climatique -
#' SIM quotidienne", CSV by 1-10 year batches), via the OGC EDR API, or as a
#' NetCDF mirror on the INRAE repository (DOI 10.57745/BAZ12C). See the package
#' README/vignette for details. Grid points are located by Lambert-II
#' coordinates \code{LAMBX}/\code{LAMBY} (in hectometres): multiply by 100 and
#' use EPSG:27572, then transform to lon/lat with \pkg{sf} for mapping.
#'
#' @param df A SIM quotidienne data frame.
#' @param cols Named list mapping SIM column names; defaults follow the open
#'   data: date "DATE" (YYYYMMDD), liquid rain "PRELIQ_Q", solid rain
#'   "PRENEI_Q", reference ET "ETP_Q", temperature "T_Q", global radiation
#'   "SSI_Q", wind "FF_Q", relative humidity "HU_Q".
#' @param compute_pet If TRUE, recompute Penman PET with \code{\link{penman_pet}}
#'   from temperature, radiation, wind and humidity instead of using \code{ETP_Q}
#'   (requires \code{latitude}, and ideally \code{altitude}).
#' @param latitude,altitude Site latitude/altitude, used only when
#'   \code{compute_pet = TRUE}.
#' @param keep_raw Keep the mapped raw climate columns (tmean, rg, wind, rh) in
#'   the output (default FALSE).
#' @return A data frame with \code{date}, \code{doy}, \code{rain}, \code{pet}.
#' @export
safran_to_meteo <- function(df,
                            cols = list(date = "DATE", rain_liq = "PRELIQ_Q",
                                        rain_sol = "PRENEI_Q", pet = "ETP_Q",
                                        tmean = "T_Q", rg = "SSI_Q",
                                        wind = "FF_Q", rh = "HU_Q"),
                            compute_pet = FALSE, latitude = NULL, altitude = 0,
                            keep_raw = FALSE) {
  g <- function(key) if (!is.null(cols[[key]]) && cols[[key]] %in% names(df))
    df[[cols[[key]]]] else NULL

  date_raw <- g("date")
  if (is.null(date_raw)) stop("Date column '", cols$date, "' not found.")
  date <- if (inherits(date_raw, "Date")) date_raw else
    as.Date(as.character(date_raw), format = "%Y%m%d")

  rl <- g("rain_liq"); rs <- g("rain_sol")
  rain <- (if (is.null(rl)) 0 else rl) + (if (is.null(rs)) 0 else rs)

  tmean <- g("tmean"); rg <- g("rg"); wind <- g("wind"); rh <- g("rh")

  if (compute_pet) {
    if (is.null(latitude)) stop("`latitude` is required when compute_pet = TRUE.")
    doy <- as.integer(format(date, "%j"))
    pet <- penman_pet(tmean = tmean, rg = rg, wind = wind_to_2m(wind, 10),
                      rh = rh, doy = doy, latitude = latitude, altitude = altitude)
  } else {
    pet <- g("pet")
    if (is.null(pet)) stop("PET column '", cols$pet,
                           "' not found; set compute_pet = TRUE to derive it.")
  }

  out <- data.frame(date = date, doy = as.integer(format(date, "%j")),
                    rain = as.numeric(rain), pet = as.numeric(pet))
  if (keep_raw) {
    if (!is.null(tmean)) out$tmean <- tmean
    if (!is.null(rg))    out$rg <- rg
    if (!is.null(wind))  out$wind <- wind
    if (!is.null(rh))    out$rh <- rh
  }
  out[order(out$date), ]
}
