# Run BILJOU over a grid of points (cartographic pipeline)

Applies
[`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
to each grid point and extracts annual drought indicators, to build
BILJOU-style maps from a gridded climate dataset (e.g. SAFRAN).

## Usage

``` r
biljou_run_grid(points, meteo, soil, lai_max, forest_type,
  budburst = NULL, leaf_fall = NULL,
  indicators = c("NJstress","Istress","DEBstress","min_rew","drainage"),
  years = NULL, id_col = "id", lon_col = "lon", lat_col = "lat",
  verbose = TRUE, ...)
```

## Arguments

- points:

  Data frame with id and coordinate columns.

- meteo:

  Per-point meteo: a function(id), a named list, or one data frame for
  all.

- soil:

  A
  [`biljou_soil`](https://pobsteta.github.io/biljouR/reference/biljou_soil.md),
  a function(id) or a named list.

- lai_max, forest_type, budburst, leaf_fall:

  Single values or functions of id.

- indicators:

  Annual indicators to keep (see
  [`biljou_indices`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md)).

- years:

  Optional years to keep.

- id_col, lon_col, lat_col:

  Column names in `points`.

- verbose:

  Print progress.

- ...:

  Passed to
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md).

## Value

A `biljou_grid` data frame: id, lon, lat, year, indicator, value.
