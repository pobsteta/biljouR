# Convert SAFRAN / SIM quotidienne data to the biljou meteo format

Maps a Meteo-France SIM quotidienne (SAFRAN, 8 km daily) data frame to
the meteo columns expected by
[`biljou_run`](https://pobsteta.github.io/biljouR/reference/biljou_run.md).
Data are free from <https://meteo.data.gouv.fr>.

## Usage

``` r
safran_to_meteo(df,
  cols = list(date = "DATE", rain_liq = "PRELIQ_Q", rain_sol = "PRENEI_Q",
              pet = "ETP_Q", tmean = "T_Q", rg = "SSI_Q", wind = "FF_Q",
              rh = "HU_Q"),
  compute_pet = FALSE, latitude = NULL, altitude = 0, keep_raw = FALSE)
```

## Arguments

- df:

  A SIM quotidienne (SAFRAN) data frame.

- cols:

  Named list mapping SIM column names (open-data defaults).

- compute_pet:

  Recompute Penman PET instead of using `ETP_Q`.

- latitude, altitude:

  Site location, used only if `compute_pet = TRUE`.

- keep_raw:

  Keep mapped raw climate columns (default FALSE).

## Value

A data frame with `date`, `doy`, `rain`, `pet`.
