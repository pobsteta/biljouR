# Potential stand transpiration ratio r = T / PET

\\r = 0.125\\LAI\\ for \\LAI \le 6\\, else \\r = 0.75\\ (Granier et al.
1999, Eq. 2).

## Usage

``` r
transpiration_ratio(lai, r_max = 0.75, lai_threshold = 6)
```

## Arguments

- lai:

  Leaf area index.

- r_max:

  Maximum T/PET ratio at high LAI (default 0.75).

- lai_threshold:

  LAI above which r is saturated (default 6).

## Value

T/PET ratio.
