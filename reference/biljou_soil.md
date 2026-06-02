# Define a soil profile

Describes the 1-3 layer soil profile used by
[`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md).

## Usage

``` r
biljou_soil(ewm, roots = NULL, macro = NULL, micro = NULL, init = 1)
```

## Arguments

- ewm:

  Maximum extractable water per layer (mm), length 1-3.

- roots:

  Fine-root fractions per layer (sum to 1); default proportional to ewm.

- macro, micro:

  Optional macro-/micro-porosity per layer controlling the fast-bypass
  fraction `macro/(macro+micro)` during infiltration.

- init:

  Initial relative extractable water (0-1) per layer (default 1).

## Value

An object of class `biljou_soil`.
