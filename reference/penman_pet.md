# Penman potential evapotranspiration

Penman (1948) combination equation, Shuttleworth (1993) formulation,
with FAO-56 net radiation. BILJOU is calibrated on Penman PET.

## Usage

``` r
penman_pet(tmean, rg, wind, rh = NULL, ea = NULL, vpd = NULL,
  doy = NULL, latitude = NULL, altitude = 0, albedo = 0.2)
```

## Arguments

- tmean:

  Mean air temperature (deg C).

- rg:

  Incident global radiation (MJ m-2 day-1; multiply J cm-2 by 0.01).

- wind:

  Wind speed at 2 m (m s-1).

- rh:

  Mean relative humidity (%); or supply `ea` or `vpd`.

- ea:

  Actual vapour pressure (kPa).

- vpd:

  Vapour pressure deficit (kPa).

- doy:

  Day of year (for the longwave term).

- latitude:

  Latitude (decimal degrees, for the longwave term).

- altitude:

  Elevation (m, default 0).

- albedo:

  Surface albedo (default 0.2).

## Value

PET (mm day-1).

## References

Penman (1948); Shuttleworth (1993); Allen et al. (1998) FAO-56.

## Examples

``` r
penman_pet(tmean = 18, rg = 22, wind = 2, rh = 65,
           doy = 180, latitude = 48.6, altitude = 250)
#> [1] 5.081286
```
