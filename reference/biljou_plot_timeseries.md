# Time series of daily fluxes / states (multi-year chronicle)

Faceted line plot of one or several daily variables; with a multi-year
run this is the multi-year chronicle. Requires ggplot2.

## Usage

``` r
biljou_plot_timeseries(run,
  vars = c("ETP","ETR","transpiration","understorey","drainage","REW"),
  from = NULL, to = NULL, free_y = TRUE)
```

## Arguments

- run:

  A
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  object.

- vars:

  Variables or aliases (ETP=pet, ETR=et, T=transpiration,
  Eu=understorey, Dr=drainage, In=interception, P=rain, REW=rew).

- from, to:

  Optional date bounds.

- free_y:

  Free y-axis per facet (default TRUE).

## Value

A ggplot2 object.
