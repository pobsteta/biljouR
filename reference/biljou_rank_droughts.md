# Rank years by drought severity

Reproduces the BILJOU "classified drought years" output, ranking years
by duration (`NJstress`), intensity (`Istress`) and earliness of onset
(`DEBstress`).

## Usage

``` r
biljou_rank_droughts(run)
```

## Arguments

- run:

  A
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  object or a
  [`biljou_indices`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md)
  data frame.

## Value

The per-year indices with added `rank_duration`, `rank_intensity` and
`rank_precocity` columns (1 = most severe).
