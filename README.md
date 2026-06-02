# biljouR

An independent **R re-implementation of the BILJOU forest water balance model**
(Granier, Bréda, Biron & Villette, 1999, *Ecological Modelling* 116:269-283),
as documented by INRAE UMR Silva at <https://appgeodb.nancy.inrae.fr/biljou/>.

> ⚠️ This package is an independent re-implementation for research and teaching.
> It is **not** produced or endorsed by INRAE. For authoritative simulations,
> use the official online tool.

## What it does

Runs the daily soil water balance `ΔW = P − In − T − Eu − D` for a forest stand
and returns daily fluxes, soil water content, relative extractable water (REW)
and drought indices (number of stress days, water-stress index *Is*, intensity,
precocity).

## Install

```r
# from the package source directory
install.packages("path/to/biljouR_0.1.0.tar.gz", repos = NULL, type = "source")
```

## Quick start

```r
library(biljouR)
data(meteo_hesse)

soil <- biljou_soil(ewm = c(70, 70, 40), roots = c(0.6, 0.3, 0.1))
run  <- biljou_run(meteo_hesse, soil, lai_max = 6,
                   forest_type = "broadleaved", budburst = 110, leaf_fall = 300)

run
biljou_indices(run)
plot(run)
```

## Inputs

* **Meteo** (daily): `pet` (mm, Penman) and `rain` (mm). A `penman_pet()` helper
  is provided if you need to compute PET from temperature, radiation, wind and
  humidity.
* **Stand**: `lai_max`, `forest_type` (and budburst/leaf-fall dates if
  deciduous).
* **Soil**: 1-3 layers, each with maximum extractable water, fine-root fraction
  and optional macro-/micro-porosity.

## Model components

| Process | Function | Reference |
|---|---|---|
| Phenology / LAI | `biljou_lai()` | Granier et al. 1999 |
| Transpiration | `transpiration_ratio()`, `potential_transpiration()` | Eq. 2 |
| Interception | `rainfall_interception()` | Aussenac 1968; Eq. 3 |
| Understorey evap. | `potential_understorey_evap()` | §3.3 |
| Soil & drainage | `biljou_soil()`, internal infiltration | §3.4 |
| Drought indices | `biljou_indices()` | Eqs. 4-5 |
| Penman PET | `penman_pet()` | Penman 1948 / FAO-56 |

## Caveats

Constants only described qualitatively in the public documentation (macro/micro
split, root-uptake weighting, understorey coefficient, interception behaviour at
high rainfall) are implemented with transparent, documented choices and should
be validated against the official BILJOU tool.

## License

GPL-3.
