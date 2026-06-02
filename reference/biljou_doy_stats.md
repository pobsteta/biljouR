# Inter-annual statistics by day-of-year

Per day-of-year summary of a daily variable across the years of a
multi-year run.

## Usage

``` r
biljou_doy_stats(run, var = "REW", probs = c(0.1, 0.9))
```

## Arguments

- run:

  A
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  object.

- var:

  A single variable or alias (default "REW").

- probs:

  Quantile probabilities (default 0.1 and 0.9).

## Value

A data frame with `doy`, `n`, `mean`, `sd`, `median` and one column per
quantile (e.g. `q10`, `q90`).

## Examples

``` r
data(meteo_hesse)
m2 <- rbind(meteo_hesse, transform(meteo_hesse, date = meteo_hesse$date + 365))
run <- biljou_run(m2, biljou_soil(150), lai_max = 6, forest_type = "coniferous")
head(biljou_doy_stats(run, "REW"))
#>   doy n      mean         sd    median       q10       q90
#> 1   1 2 0.8984267 0.13655824 0.8984267 0.8211777 0.9756757
#> 2   2 2 0.8974134 0.13655824 0.8974134 0.8201644 0.9746624
#> 3   3 2 0.9390152 0.08624553 0.9390152 0.8902274 0.9878030
#> 4   4 2 0.9352296 0.08624553 0.9352296 0.8864418 0.9840175
#> 5   5 2 0.9314973 0.08624553 0.9314973 0.8827094 0.9802851
#> 6   6 2 0.9284581 0.08624553 0.9284581 0.8796702 0.9772459
```
