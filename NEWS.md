# biljouR 0.1.0

First release.

* Daily forest water balance simulation `biljou_run()` implementing
  `ΔW = P − In − T − Eu − D` (Granier et al. 1999, Eq. 1).
* Stand phenology / daily LAI (`biljou_lai()`): constant for evergreen stands,
  30-day expansion and senescence ramps for deciduous stands.
* Overstorey transpiration with the `r = T/PET` relationship
  (`transpiration_ratio()`, `potential_transpiration()`; Eq. 2), wet-canopy
  reduction and water-stress regulation below `REWc = 0.4`.
* Rainfall interception after Aussenac (1968) (`rainfall_interception()`;
  Eq. 3) with stand-type coefficients.
* Understorey + soil evaporation from transmitted radiation
  (`potential_understorey_evap()`).
* 1–3 layer soil (`biljou_soil()`) with macro-/micro-porosity fast-bypass
  drainage and root- and REW-weighted water uptake.
* Drought indices per year (`biljou_indices()`) using the online tool's
  annual-file names and definitions: `NJstress` (stress days), `Istress`
  (\eqn{\sum (0.4-REW)/0.4}), `DEBstress` (onset day); the un-normalised
  Granier et al. 1999 index (Eq. 5) is also returned as `is_1999`.
* `biljou_rank_droughts()`: ranks years by duration, intensity and precocity
  (the BILJOU "classified drought years" output).
* Annual water-balance summary (`biljou_annual_balance()`).
* Penman potential evapotranspiration helper (`penman_pet()`) and 2 m wind
  adjustment (`wind_to_2m()`).
* Synthetic example dataset `meteo_hesse`, test suite, and an introductory
  vignette.

This package is an independent re-implementation for research and teaching and
is not produced or endorsed by INRAE.
