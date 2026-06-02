# Potential understorey + soil evaporation

Proportional to energy reaching the floor: \\Eu_p = PET \times
exp(-k\\LAI)\\. Soil-water limitation applied in
[`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md).

## Usage

``` r
potential_understorey_evap(pet, lai, k = 0.5)
```

## Arguments

- pet:

  Potential evapotranspiration (mm).

- lai:

  Leaf area index.

- k:

  Light extinction coefficient (default 0.5).

## Value

Potential understorey + soil evaporation (mm).
