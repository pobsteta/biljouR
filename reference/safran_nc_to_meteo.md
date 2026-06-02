# Read SAFRAN NetCDF files at grid points into per-point meteo

Extracts daily series from the per-variable NetCDF files at points and
assembles per-point meteo. Requires terra. SAFRAN grid geometry can
vary; inspect a file with
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html)
and adjust if needed.

## Usage

``` r
safran_nc_to_meteo(files, points, id_col = "id", lon_col = "lon",
  lat_col = "lat", pts_crs = "EPSG:4326",
  cols = list(date = "date", rain_liq = "PRELIQ_Q", rain_sol = "PRENEI_Q",
              pet = "ETP_Q"))
```

## Arguments

- files:

  Named character vector of NetCDF paths (names = variable codes).

- points:

  Data frame of points with id and lon/lat columns.

- id_col, lon_col, lat_col:

  Column names in `points`.

- pts_crs:

  CRS of the point coordinates (default EPSG:4326).

- cols:

  Mapping passed to
  [`safran_to_meteo`](https://pobsteta.github.io/biljouR/reference/safran_to_meteo.md).

## Value

A named list of meteo data frames keyed by point id, ready for
[`biljou_run_grid`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md).
