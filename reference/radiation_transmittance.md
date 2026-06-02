# Fraction of incident radiation transmitted through the canopy

Beer-Lambert extinction \\R/R0 = exp(-k\\LAI)\\.

## Usage

``` r
radiation_transmittance(lai, k = 0.5)
```

## Arguments

- lai:

  Leaf area index (m2 m-2).

- k:

  Light extinction coefficient (default 0.5).

## Value

Transmitted fraction in \[0, 1\].
