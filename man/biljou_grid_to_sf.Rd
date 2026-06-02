\name{biljou_grid_to_sf}
\alias{biljou_grid_to_sf}
\title{Convert a grid result to an sf points layer}
\usage{biljou_grid_to_sf(grid, indicator = NULL, year = NULL, crs = 4326)}
\arguments{
\item{grid}{A \code{biljou_grid} (from \code{\link{biljou_run_grid}}).}
\item{indicator, year}{Indicator and year to map (required if several present).}
\item{crs}{CRS (default EPSG:4326).}
}
\value{An \pkg{sf} object with a \code{value} column.}
\description{Requires \pkg{sf}.}
