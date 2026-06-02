# Daily rainfall interception (Granier et al. 1999, Eq. 3)

Throughfall \\Th = exp(a + b\\R/R0 + c\\P + d\\P^2)\\ and \\In = P -
Th\\, after Aussenac (1968). \\R/R0\\ is percent transmitted radiation
\\100\\exp(-k\\LAI)\\. In is clamped to \[0, P\].

## Usage

``` r
rainfall_interception(p, lai, forest_type = c("broadleaved", "coniferous"),
  k = 0.5, coef = NULL, min_rain = NULL)
```

## Arguments

- p:

  Incident rainfall (mm).

- lai:

  Leaf area index.

- forest_type:

  "broadleaved" or "coniferous".

- k:

  Light extinction coefficient (default 0.5).

- coef:

  Optional named a,b,c,d overriding the default coefficients.

- min_rain:

  Threshold below which In = P (default 1 broadleaved, 2 coniferous).

## Value

Interception (mm).

## References

Aussenac G (1968) Ann. Sci. For. 25:135-156.
