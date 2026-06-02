# Daily potential overstorey transpiration

\\T_p = r(LAI) \times PET\\. Stress and wet-canopy reductions are
applied in
[`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md).

## Usage

``` r
potential_transpiration(pet, lai, r_max = 0.75, lai_threshold = 6)
```

## Arguments

- pet:

  Potential evapotranspiration (mm).

- lai:

  Leaf area index.

- r_max, lai_threshold:

  See
  [`transpiration_ratio`](https://pobsteta.github.io/biljouR/reference/transpiration_ratio.md).

## Value

Potential transpiration (mm).
