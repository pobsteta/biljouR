# Rasterise a grid result with terra

Builds a SpatRaster from (lon, lat, value) triplets on a regular grid.
Requires terra.

## Usage

``` r
biljou_grid_to_raster(grid, indicator = NULL, year = NULL, crs = "EPSG:4326")
```

## Arguments

- grid:

  A `biljou_grid`.

- indicator, year:

  Indicator and year to map (required if several present).

- crs:

  CRS (default EPSG:4326).

## Value

A terra `SpatRaster`.
