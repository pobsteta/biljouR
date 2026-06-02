\name{biljou_doy_stats}
\alias{biljou_doy_stats}
\title{Inter-annual statistics by day-of-year}
\usage{biljou_doy_stats(run, var = "REW", probs = c(0.1, 0.9))}
\arguments{
\item{run}{A \code{\link{biljou_run}} object.}
\item{var}{A single variable or alias (default "REW").}
\item{probs}{Quantile probabilities (default 0.1 and 0.9).}
}
\value{A data frame with \code{doy}, \code{n}, \code{mean}, \code{sd},
\code{median} and one column per quantile (e.g. \code{q10}, \code{q90}).}
\description{Per day-of-year summary of a daily variable across the years of a
multi-year run.}
\examples{
data(meteo_hesse)
m2 <- rbind(meteo_hesse, transform(meteo_hesse, date = meteo_hesse$date + 365))
run <- biljou_run(m2, biljou_soil(150), lai_max = 6, forest_type = "coniferous")
head(biljou_doy_stats(run, "REW"))
}
