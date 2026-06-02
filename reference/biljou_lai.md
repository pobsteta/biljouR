# Daily leaf area index from phenology

Coniferous stands keep constant LAI; deciduous stands ramp from 0 to
`lai_max` over 30 days after budburst and back to 0 over the 30 days
before leaf fall.

## Usage

``` r
biljou_lai(doy, lai_max, forest_type = c("broadleaved", "coniferous"),
  budburst = NULL, leaf_fall = NULL, ramp = 30)
```

## Arguments

- doy:

  Integer vector of day-of-year values (1-366).

- lai_max:

  Maximum (plateau) leaf area index.

- forest_type:

  "broadleaved" (deciduous) or "coniferous" (evergreen).

- budburst:

  Day-of-year of budburst (deciduous only).

- leaf_fall:

  Day-of-year of complete leaf fall (deciduous only).

- ramp:

  Duration of the leaf expansion/senescence ramp, days (default 30).

## Value

Numeric vector of daily LAI.
