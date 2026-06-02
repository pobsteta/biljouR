# Overlay years by day-of-year (inter-annual comparison)

One curve per year vs day-of-year, with an optional mean/median summary
curve (and the REW=0.4 threshold for REW). Requires ggplot2.

## Usage

``` r
biljou_plot_overlay(run, var = "REW", stat = c("median","mean","none"))
```

## Arguments

- run:

  A
  [`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  object.

- var:

  A single variable or alias (default "REW").

- stat:

  Optional summary curve: "median", "mean" or "none".

## Value

A ggplot2 object.
