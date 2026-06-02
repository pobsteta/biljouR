\name{potential_understorey_evap}
\alias{potential_understorey_evap}
\title{Potential understorey + soil evaporation}
\usage{potential_understorey_evap(pet, lai, k = 0.5)}
\arguments{
\item{pet}{Potential evapotranspiration (mm).}
\item{lai}{Leaf area index.}
\item{k}{Light extinction coefficient (default 0.5).}
}
\value{Potential understorey + soil evaporation (mm).}
\description{Proportional to energy reaching the floor:
\eqn{Eu_p = PET \times exp(-k\,LAI)}. Soil-water limitation applied in
\code{\link{biljou_run}}.}
