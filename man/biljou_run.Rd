\name{biljou_run}
\alias{biljou_run}
\alias{print.biljou_run}
\alias{plot.biljou_run}
\title{Run the BILJOU daily water balance}
\usage{biljou_run(meteo, soil, lai_max,
  forest_type = c("broadleaved", "coniferous"),
  budburst = NULL, leaf_fall = NULL, rew_c = 0.4, k = 0.5,
  et_max_ratio = 1.2, wet_canopy_factor = 0.2, interception_coef = NULL)}
\arguments{
\item{meteo}{Data frame with columns \code{date} (or \code{doy}), \code{pet}
(mm) and \code{rain} (mm), one row per day.}
\item{soil}{A \code{\link{biljou_soil}} object.}
\item{lai_max}{Maximum leaf area index.}
\item{forest_type}{"broadleaved" or "coniferous".}
\item{budburst, leaf_fall}{Day-of-year of budburst and leaf fall (deciduous).}
\item{rew_c}{Critical relative extractable water (default 0.4).}
\item{k}{Light extinction coefficient (default 0.5).}
\item{et_max_ratio}{Cap on actual ET as a multiple of PET (default 1.2).}
\item{wet_canopy_factor}{Fraction of interception subtracted from transpiration (0.2).}
\item{interception_coef}{Optional interception coefficient override.}
}
\value{An object of class \code{biljou_run} with element \code{daily}.}
\description{Iterates \eqn{\Delta W = P - In - T - Eu - D} (Granier et al. 1999,
Eq. 1) over the meteorological series following the BILJOU flow chart.}
\examples{
data(meteo_hesse)
soil <- biljou_soil(ewm = c(60, 60, 60), roots = c(0.6, 0.3, 0.1))
run <- biljou_run(meteo_hesse, soil, lai_max = 6,
                  forest_type = "broadleaved", budburst = 110, leaf_fall = 300)
head(run$daily)
}
\references{Granier A, Breda N, Biron P, Villette S (1999) Ecological
Modelling 116:269-283.}
