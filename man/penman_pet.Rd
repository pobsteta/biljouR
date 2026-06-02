\name{penman_pet}
\alias{penman_pet}
\title{Penman potential evapotranspiration}
\usage{penman_pet(tmean, rg, wind, rh = NULL, ea = NULL, vpd = NULL,
  doy = NULL, latitude = NULL, altitude = 0, albedo = 0.2)}
\arguments{
\item{tmean}{Mean air temperature (deg C).}
\item{rg}{Incident global radiation (MJ m-2 day-1; multiply J cm-2 by 0.01).}
\item{wind}{Wind speed at 2 m (m s-1).}
\item{rh}{Mean relative humidity (\%); or supply \code{ea} or \code{vpd}.}
\item{ea}{Actual vapour pressure (kPa).}
\item{vpd}{Vapour pressure deficit (kPa).}
\item{doy}{Day of year (for the longwave term).}
\item{latitude}{Latitude (decimal degrees, for the longwave term).}
\item{altitude}{Elevation (m, default 0).}
\item{albedo}{Surface albedo (default 0.2).}
}
\value{PET (mm day-1).}
\description{Penman (1948) combination equation, Shuttleworth (1993)
formulation, with FAO-56 net radiation. BILJOU is calibrated on Penman PET.}
\references{Penman (1948); Shuttleworth (1993); Allen et al. (1998) FAO-56.}
\examples{
penman_pet(tmean = 18, rg = 22, wind = 2, rh = 65,
           doy = 180, latitude = 48.6, altitude = 250)
}
