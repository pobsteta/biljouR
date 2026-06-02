# Drought indices from a BILJOU run

Per-year ecophysiological drought indicators, accumulated over the
leafed period for deciduous stands and the whole year for evergreen
stands.

## Usage

``` r
biljou_indices(run)
```

## Arguments

- run:

  A
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  object.

## Value

A data frame, one row per year, with the BILJOU annual-file indicators
`NJstress` (number of stress days), `Istress` (\\\sum (0.4 - REW)/0.4\\,
online-tool definition), `DEBstress` (day-of-year of drought onset),
plus `min_rew`, `is_1999` (\\\sum (0.4 - REW)\\, Granier et al. 1999 Eq.
5) and flux totals.

## References

Granier A, Breda N, Biron P, Villette S (1999) Ecological Modelling
116:269-283.
