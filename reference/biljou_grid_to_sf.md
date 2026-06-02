# Convert a grid result to an sf points layer

Requires sf.

## Usage

``` r
biljou_grid_to_sf(grid, indicator = NULL, year = NULL, crs = 4326)
```

## Arguments

- grid:

  A `biljou_grid` (from
  [`biljou_run_grid`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md)).

- indicator, year:

  Indicator and year to map (required if several present).

- crs:

  CRS (default EPSG:4326).

## Value

An sf object with a `value` column.
