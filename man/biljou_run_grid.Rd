\name{biljou_run_grid}
\alias{biljou_run_grid}
\alias{print.biljou_grid}
\title{Run BILJOU over a grid of points (cartographic pipeline)}
\usage{biljou_run_grid(points, meteo, soil, lai_max, forest_type,
  budburst = NULL, leaf_fall = NULL,
  indicators = c("NJstress","Istress","DEBstress","min_rew","drainage"),
  years = NULL, id_col = "id", lon_col = "lon", lat_col = "lat",
  verbose = TRUE, ...)}
\arguments{
\item{points}{Data frame with id and coordinate columns.}
\item{meteo}{Per-point meteo: a function(id), a named list, or one data frame for all.}
\item{soil}{A \code{\link{biljou_soil}}, a function(id) or a named list.}
\item{lai_max, forest_type, budburst, leaf_fall}{Single values or functions of id.}
\item{indicators}{Annual indicators to keep (see \code{\link{biljou_indices}}).}
\item{years}{Optional years to keep.}
\item{id_col, lon_col, lat_col}{Column names in \code{points}.}
\item{verbose}{Print progress.}
\item{...}{Passed to \code{\link{biljou_run}}.}
}
\value{A \code{biljou_grid} data frame: id, lon, lat, year, indicator, value.}
\description{Applies \code{\link{biljou_run}} to each grid point and extracts
annual drought indicators, to build BILJOU-style maps from a gridded climate
dataset (e.g. SAFRAN).}
