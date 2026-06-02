\name{safran_nc_to_meteo}
\alias{safran_nc_to_meteo}
\title{Read SAFRAN NetCDF files at grid points into per-point meteo}
\usage{safran_nc_to_meteo(files, points, id_col = "id", lon_col = "lon",
  lat_col = "lat", pts_crs = "EPSG:4326",
  cols = list(date = "date", rain_liq = "PRELIQ_Q", rain_sol = "PRENEI_Q",
              pet = "ETP_Q"))}
\arguments{
\item{files}{Named character vector of NetCDF paths (names = variable codes).}
\item{points}{Data frame of points with id and lon/lat columns.}
\item{id_col, lon_col, lat_col}{Column names in \code{points}.}
\item{pts_crs}{CRS of the point coordinates (default EPSG:4326).}
\item{cols}{Mapping passed to \code{\link{safran_to_meteo}}.}
}
\value{A named list of meteo data frames keyed by point id, ready for
\code{\link{biljou_run_grid}}.}
\description{Extracts daily series from the per-variable NetCDF files at points
and assembles per-point meteo. Requires \pkg{terra}. SAFRAN grid geometry can
vary; inspect a file with \code{terra::rast()} and adjust if needed.}
