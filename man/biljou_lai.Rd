\name{biljou_lai}
\alias{biljou_lai}
\title{Daily leaf area index from phenology}
\usage{biljou_lai(doy, lai_max, forest_type = c("broadleaved", "coniferous"),
  budburst = NULL, leaf_fall = NULL, ramp = 30)}
\arguments{
\item{doy}{Integer vector of day-of-year values (1-366).}
\item{lai_max}{Maximum (plateau) leaf area index.}
\item{forest_type}{"broadleaved" (deciduous) or "coniferous" (evergreen).}
\item{budburst}{Day-of-year of budburst (deciduous only).}
\item{leaf_fall}{Day-of-year of complete leaf fall (deciduous only).}
\item{ramp}{Duration of the leaf expansion/senescence ramp, days (default 30).}
}
\value{Numeric vector of daily LAI.}
\description{Coniferous stands keep constant LAI; deciduous stands ramp from 0
to \code{lai_max} over 30 days after budburst and back to 0 over the 30 days
before leaf fall.}
