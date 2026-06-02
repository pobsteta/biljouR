\name{safran_to_meteo}
\alias{safran_to_meteo}
\title{Convert SAFRAN / SIM quotidienne data to the biljou meteo format}
\usage{safran_to_meteo(df,
  cols = list(date = "DATE", rain_liq = "PRELIQ_Q", rain_sol = "PRENEI_Q",
              pet = "ETP_Q", tmean = "T_Q", rg = "SSI_Q", wind = "FF_Q",
              rh = "HU_Q"),
  compute_pet = FALSE, latitude = NULL, altitude = 0, keep_raw = FALSE)}
\arguments{
\item{df}{A SIM quotidienne (SAFRAN) data frame.}
\item{cols}{Named list mapping SIM column names (open-data defaults).}
\item{compute_pet}{Recompute Penman PET instead of using \code{ETP_Q}.}
\item{latitude, altitude}{Site location, used only if \code{compute_pet = TRUE}.}
\item{keep_raw}{Keep mapped raw climate columns (default FALSE).}
}
\value{A data frame with \code{date}, \code{doy}, \code{rain}, \code{pet}.}
\description{Maps a Meteo-France SIM quotidienne (SAFRAN, 8 km daily) data frame
to the meteo columns expected by \code{\link{biljou_run}}. Data are free from
\url{https://meteo.data.gouv.fr}.}
