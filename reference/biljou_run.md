# Run the BILJOU daily water balance

Iterates \\\Delta W = P - In - T - Eu - D\\ (Granier et al. 1999, Eq. 1)
over the meteorological series following the BILJOU flow chart.

## Usage

``` r
biljou_run(meteo, soil, lai_max,
  forest_type = c("broadleaved", "coniferous"),
  budburst = NULL, leaf_fall = NULL, rew_c = 0.4, k = 0.5,
  et_max_ratio = 1.2, wet_canopy_factor = 0.2, interception_coef = NULL)
```

## Arguments

- meteo:

  Data frame with columns `date` (or `doy`), `pet` (mm) and `rain` (mm),
  one row per day.

- soil:

  A
  [`biljou_soil`](https://pobsteta.github.io/biljouR/reference/biljou_soil.md)
  object.

- lai_max:

  Maximum leaf area index.

- forest_type:

  "broadleaved" or "coniferous".

- budburst, leaf_fall:

  Day-of-year of budburst and leaf fall (deciduous).

- rew_c:

  Critical relative extractable water (default 0.4).

- k:

  Light extinction coefficient (default 0.5).

- et_max_ratio:

  Cap on actual ET as a multiple of PET (default 1.2).

- wet_canopy_factor:

  Fraction of interception subtracted from transpiration (0.2).

- interception_coef:

  Optional interception coefficient override.

## Value

An object of class `biljou_run` with element `daily`.

## References

Granier A, Breda N, Biron P, Villette S (1999) Ecological Modelling
116:269-283.

## Examples

``` r
data(meteo_hesse)
soil <- biljou_soil(ewm = c(60, 60, 60), roots = c(0.6, 0.3, 0.1))
run <- biljou_run(meteo_hesse, soil, lai_max = 6,
                  forest_type = "broadleaved", budburst = 110, leaf_fall = 300)
head(run$daily)
#>         date doy rain  pet lai interception throughfall transpiration
#> 1 2003-01-01   1  0.0 0.94   0            0         0.0             0
#> 2 2003-01-02   2  0.4 0.46   0            0         0.4             0
#> 3 2003-01-03   3 14.8 0.69   0            0        14.8             0
#> 4 2003-01-04   4  0.2 0.76   0            0         0.2             0
#> 5 2003-01-05   5  0.0 0.70   0            0         0.0             0
#> 6 2003-01-06   6  0.0 0.57   0            0         0.0             0
#>   understorey   et drainage soil_water       rew swd
#> 1        0.94 0.94      0.0     179.06 0.9947778   0
#> 2        0.46 0.46      0.0     179.00 0.9944444   0
#> 3        0.69 0.69     13.8     179.31 0.9961667   0
#> 4        0.76 0.76      0.0     178.75 0.9930556   0
#> 5        0.70 0.70      0.0     178.05 0.9891667   0
#> 6        0.57 0.57      0.0     177.48 0.9860000   0
```
