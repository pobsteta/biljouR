# Changelog

## biljouR 0.1.0

First release.

- Daily forest water balance simulation
  [`biljou_run()`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  implementing `ΔW = P − In − T − Eu − D` (Granier et al. 1999, Eq. 1).
- Stand phenology / daily LAI
  ([`biljou_lai()`](https://pobsteta.github.io/biljouR/reference/biljou_lai.md)):
  constant for evergreen stands, 30-day expansion and senescence ramps
  for deciduous stands.
- Overstorey transpiration with the `r = T/PET` relationship
  ([`transpiration_ratio()`](https://pobsteta.github.io/biljouR/reference/transpiration_ratio.md),
  [`potential_transpiration()`](https://pobsteta.github.io/biljouR/reference/potential_transpiration.md);
  Eq. 2), wet-canopy reduction and water-stress regulation below
  `REWc = 0.4`.
- Rainfall interception after Aussenac (1968)
  ([`rainfall_interception()`](https://pobsteta.github.io/biljouR/reference/rainfall_interception.md);
  Eq. 3) with stand-type coefficients.
- Understorey + soil evaporation from transmitted radiation
  ([`potential_understorey_evap()`](https://pobsteta.github.io/biljouR/reference/potential_understorey_evap.md)).
- 1–3 layer soil
  ([`biljou_soil()`](https://pobsteta.github.io/biljouR/reference/biljou_soil.md))
  with macro-/micro-porosity fast-bypass drainage and root- and
  REW-weighted water uptake.
- Drought indices per year
  ([`biljou_indices()`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md))
  using the online tool’s annual-file names and definitions: `NJstress`
  (stress days), `Istress` (), `DEBstress` (onset day); the
  un-normalised Granier et al. 1999 index (Eq. 5) is also returned as
  `is_1999`.
- [`biljou_rank_droughts()`](https://pobsteta.github.io/biljouR/reference/biljou_rank_droughts.md):
  ranks years by duration, intensity and precocity (the BILJOU
  “classified drought years” output).
- Graphics module (requires ggplot2):
  [`biljou_plot_timeseries()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_timeseries.md)
  (multi-year chronicle / faceted ETP, ETR, T, Eu, drainage, REW) and
  [`biljou_plot_overlay()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_overlay.md)
  (year overlay by day-of-year with mean/median curve).
- [`biljou_doy_stats()`](https://pobsteta.github.io/biljouR/reference/biljou_doy_stats.md):
  inter-annual mean/median/quantiles per day-of-year.
- Cartographic pipeline:
  [`biljou_run_grid()`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md)
  runs the model over a grid of points;
  [`biljou_grid_to_sf()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_sf.md)
  and
  [`biljou_grid_to_raster()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_raster.md)
  export results (require sf / terra).
- [`safran_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_to_meteo.md):
  converts Meteo-France SAFRAN / SIM quotidienne data to the meteo input
  format.
- SAFRAN NetCDF mirror access (INRAE Dataverse, DOI 10.57745/BAZ12C):
  [`safran_dataverse_files()`](https://pobsteta.github.io/biljouR/reference/safran_dataverse_files.md)
  lists the per-variable NetCDF files,
  [`safran_download()`](https://pobsteta.github.io/biljouR/reference/safran_download.md)
  downloads the variables BILJOU needs, and
  [`safran_nc_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_nc_to_meteo.md)
  extracts per-point meteo from them (require jsonlite / terra).
- Annual water-balance summary
  ([`biljou_annual_balance()`](https://pobsteta.github.io/biljouR/reference/biljou_annual_balance.md)).
- Penman potential evapotranspiration helper
  ([`penman_pet()`](https://pobsteta.github.io/biljouR/reference/penman_pet.md))
  and 2 m wind adjustment
  ([`wind_to_2m()`](https://pobsteta.github.io/biljouR/reference/wind_to_2m.md)).
- Synthetic example dataset `meteo_hesse`, test suite, and an
  introductory vignette.

This package is an independent re-implementation for research and
teaching and is not produced or endorsed by INRAE.
