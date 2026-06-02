# Package index

## Simulation

Construire le sol, lancer le bilan hydrique journalier.

- [`biljou_soil()`](https://pobsteta.github.io/biljouR/reference/biljou_soil.md)
  : Define a soil profile
- [`biljou_run()`](https://pobsteta.github.io/biljouR/reference/biljou_run.md)
  : Run the BILJOU daily water balance

## Indicateurs et bilans

Indicateurs annuels de sécheresse, classement, bilan des flux.

- [`biljou_indices()`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md)
  : Drought indices from a BILJOU run
- [`biljou_rank_droughts()`](https://pobsteta.github.io/biljouR/reference/biljou_rank_droughts.md)
  : Rank years by drought severity
- [`biljou_annual_balance()`](https://pobsteta.github.io/biljouR/reference/biljou_annual_balance.md)
  : Annual water balance summary

## Graphiques et statistiques

Chroniques, superposition d’années, statistiques inter-annuelles.

- [`biljou_plot_timeseries()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_timeseries.md)
  : Time series of daily fluxes / states (multi-year chronicle)
- [`biljou_plot_overlay()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_overlay.md)
  : Overlay years by day-of-year (inter-annual comparison)
- [`biljou_doy_stats()`](https://pobsteta.github.io/biljouR/reference/biljou_doy_stats.md)
  : Inter-annual statistics by day-of-year

## Cartographie

Exécution sur une grille de points et export SIG.

- [`biljou_run_grid()`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md)
  : Run BILJOU over a grid of points (cartographic pipeline)
- [`biljou_grid_to_sf()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_sf.md)
  : Convert a grid result to an sf points layer
- [`biljou_grid_to_raster()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_raster.md)
  : Rasterise a grid result with terra

## Données météo (SAFRAN) et ETP

Accès aux données SAFRAN, conversion, évapotranspiration potentielle.

- [`safran_dataverse_files()`](https://pobsteta.github.io/biljouR/reference/safran_dataverse_files.md)
  : List the files of the SAFRAN NetCDF dataset
- [`safran_download()`](https://pobsteta.github.io/biljouR/reference/safran_download.md)
  : Download SAFRAN NetCDF variable files
- [`safran_nc_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_nc_to_meteo.md)
  : Read SAFRAN NetCDF files at grid points into per-point meteo
- [`safran_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_to_meteo.md)
  : Convert SAFRAN / SIM quotidienne data to the biljou meteo format
- [`penman_pet()`](https://pobsteta.github.io/biljouR/reference/penman_pet.md)
  : Penman potential evapotranspiration
- [`wind_to_2m()`](https://pobsteta.github.io/biljouR/reference/wind_to_2m.md)
  : Adjust wind speed to a 2 m reference height

## Fonctions de flux élémentaires

Briques du modèle (phénologie, transpiration, interception…).

- [`biljou_lai()`](https://pobsteta.github.io/biljouR/reference/biljou_lai.md)
  : Daily leaf area index from phenology
- [`transpiration_ratio()`](https://pobsteta.github.io/biljouR/reference/transpiration_ratio.md)
  : Potential stand transpiration ratio r = T / PET
- [`potential_transpiration()`](https://pobsteta.github.io/biljouR/reference/potential_transpiration.md)
  : Daily potential overstorey transpiration
- [`rainfall_interception()`](https://pobsteta.github.io/biljouR/reference/rainfall_interception.md)
  : Daily rainfall interception (Granier et al. 1999, Eq. 3)
- [`potential_understorey_evap()`](https://pobsteta.github.io/biljouR/reference/potential_understorey_evap.md)
  : Potential understorey + soil evaporation
- [`radiation_transmittance()`](https://pobsteta.github.io/biljouR/reference/radiation_transmittance.md)
  : Fraction of incident radiation transmitted through the canopy

## Jeu de données

- [`meteo_hesse`](https://pobsteta.github.io/biljouR/reference/meteo_hesse.md)
  : Synthetic daily meteorology (one temperate year)

## Le package

- [`biljouR-package`](https://pobsteta.github.io/biljouR/reference/biljouR-package.md)
  [`biljouR`](https://pobsteta.github.io/biljouR/reference/biljouR-package.md)
  : biljouR: a daily forest water balance model
