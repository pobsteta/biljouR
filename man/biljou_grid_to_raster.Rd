\name{biljou_grid_to_raster}
\alias{biljou_grid_to_raster}
\title{Rasterise a grid result with terra}
\usage{biljou_grid_to_raster(grid, indicator = NULL, year = NULL, crs = "EPSG:4326")}
\arguments{
\item{grid}{A \code{biljou_grid}.}
\item{indicator, year}{Indicator and year to map (required if several present).}
\item{crs}{CRS (default EPSG:4326).}
}
\value{A \pkg{terra} \code{SpatRaster}.}
\description{Builds a SpatRaster from (lon, lat, value) triplets on a regular
grid. Requires \pkg{terra}.}
