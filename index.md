# biljouR

📖 **Documentation et articles : <https://pobsteta.github.io/biljouR>**

Réimplémentation **indépendante en R du modèle de bilan hydrique
forestier BILJOU** (Granier, Bréda, Biron & Villette, 1999, *Ecological
Modelling* 116:269-283), tel que documenté par l’INRAE UMR Silva
(<https://appgeodb.nancy.inrae.fr/biljou/>).

> ⚠️ Ce package est une réimplémentation indépendante, à des fins de
> recherche et d’enseignement. Il **n’est ni produit ni cautionné par
> l’INRAE**. Pour des simulations de référence, utilisez l’outil
> officiel en ligne.

## Ce qu’il fait

Calcule, au pas de temps **journalier**, le bilan hydrique du sol
`ΔW = P − In − T − Eu − D` d’un peuplement forestier et renvoie les flux
journaliers, le contenu en eau du sol, la réserve en eau relative (REW)
et les indicateurs de sécheresse (nombre de jours de stress, indice de
stress *Istress*, intensité, précocité).

## Installation

Depuis GitHub (recommandé) :

``` r

# install.packages("remotes")
remotes::install_github("pobsteta/biljouR")

# avec la vignette :
remotes::install_github("pobsteta/biljouR", build_vignettes = TRUE)
```

Ou depuis une archive source locale :

``` r

install.packages("chemin/vers/biljouR_0.1.0.tar.gz", repos = NULL, type = "source")
```

## Prise en main rapide

``` r

library(biljouR)
data(meteo_hesse)

sol <- biljou_soil(
  ewm   = c(70, 70, 40),   # mm d'eau extractible par couche
  roots = c(0.6, 0.3, 0.1) # fractions de racines fines
)

run <- biljou_run(meteo_hesse, sol, lai_max = 6,
                  forest_type = "broadleaved",   # ou "coniferous"
                  budburst = 110, leaf_fall = 300)

run                       # résumé
biljou_indices(run)       # indicateurs annuels (NJstress, Istress, DEBstress)
biljou_annual_balance(run)# bilan annuel des flux
plot(run)                 # REW + flux journaliers
```

## Entrées

- **Météo** (journalière) : `pet` (mm, Penman) et `rain` (mm). La
  fonction
  [`penman_pet()`](https://pobsteta.github.io/biljouR/reference/penman_pet.md)
  calcule l’ETP Penman à partir de la température, du rayonnement, du
  vent et de l’humidité si besoin.
- **Peuplement** : `lai_max`, `forest_type` (et dates de débourrement /
  chute des feuilles si décidu).
- **Sol** : 1 à 3 couches, chacune avec son eau extractible maximale, sa
  fraction de racines fines et, optionnellement, sa
  macro-/microporosité.

## Composants du modèle

| Processus | Fonction | Référence |
|----|----|----|
| Phénologie / LAI | [`biljou_lai()`](https://pobsteta.github.io/biljouR/reference/biljou_lai.md) | Granier et al. 1999 |
| Transpiration | [`transpiration_ratio()`](https://pobsteta.github.io/biljouR/reference/transpiration_ratio.md), [`potential_transpiration()`](https://pobsteta.github.io/biljouR/reference/potential_transpiration.md) | Éq. 2 |
| Interception | [`rainfall_interception()`](https://pobsteta.github.io/biljouR/reference/rainfall_interception.md) | Aussenac 1968 ; Éq. 3 |
| Évaporation sous-étage | [`potential_understorey_evap()`](https://pobsteta.github.io/biljouR/reference/potential_understorey_evap.md) | §3.3 |
| Sol & drainage | [`biljou_soil()`](https://pobsteta.github.io/biljouR/reference/biljou_soil.md), infiltration interne | §3.4 |
| Indicateurs de sécheresse | [`biljou_indices()`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md), [`biljou_rank_droughts()`](https://pobsteta.github.io/biljouR/reference/biljou_rank_droughts.md) | Éq. 4-5 |
| Statistiques inter-annuelles | [`biljou_doy_stats()`](https://pobsteta.github.io/biljouR/reference/biljou_doy_stats.md) | — |
| Graphiques (ggplot2) | [`biljou_plot_timeseries()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_timeseries.md), [`biljou_plot_overlay()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_overlay.md) | — |
| Cartographie | [`biljou_run_grid()`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md), [`biljou_grid_to_sf()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_sf.md), [`biljou_grid_to_raster()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_raster.md) | — |
| Données SAFRAN | [`safran_download()`](https://pobsteta.github.io/biljouR/reference/safran_download.md), [`safran_dataverse_files()`](https://pobsteta.github.io/biljouR/reference/safran_dataverse_files.md), [`safran_nc_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_nc_to_meteo.md), [`safran_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_to_meteo.md) | INRAE / meteo.data.gouv.fr |
| ETP Penman | [`penman_pet()`](https://pobsteta.github.io/biljouR/reference/penman_pet.md) | Penman 1948 / FAO-56 |

## Correspondance avec les sorties de l’outil en ligne

| Sortie de l’outil BILJOU | Fournie par le package ? | Comment |
|----|----|----|
| Fichier de **résultats journaliers** (P, In, Th, T, Eu, ETR, ETP, drainage, REW, réserve) | ✅ Oui | `run$daily` (data.frame) |
| Fichier de **résultats annuels** (bilan + NJstress, Istress, DEBstress) | ✅ Oui | [`biljou_indices()`](https://pobsteta.github.io/biljouR/reference/biljou_indices.md) + [`biljou_annual_balance()`](https://pobsteta.github.io/biljouR/reference/biljou_annual_balance.md) |
| **Classement des années** de sécheresse (3 indicateurs) | ✅ Oui | [`biljou_rank_droughts()`](https://pobsteta.github.io/biljouR/reference/biljou_rank_droughts.md) |
| **Graphiques** intra-annuels (ETP, ETR, T, Eu, REW, drainage…) | ✅ Oui | [`biljou_plot_timeseries()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_timeseries.md) (ggplot2) |
| **Superposition d’années** / comparaison inter-annuelle | ✅ Oui | [`biljou_plot_overlay()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_overlay.md) |
| **Statistiques** inter-annuelles (moyenne/médiane par jour) | ✅ Oui | [`biljou_doy_stats()`](https://pobsteta.github.io/biljouR/reference/biljou_doy_stats.md) |
| **Chronique journalière** multi-années | ✅ Oui | [`biljou_plot_timeseries()`](https://pobsteta.github.io/biljouR/reference/biljou_plot_timeseries.md) sur un run multi-années |
| **Cartes de sécheresse** de France (archive SAFRAN, maille 8×8 km) | 🟡 Pipeline fourni | [`biljou_run_grid()`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md) → [`biljou_grid_to_sf()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_sf.md) / [`biljou_grid_to_raster()`](https://pobsteta.github.io/biljouR/reference/biljou_grid_to_raster.md) ; données SAFRAN à télécharger (voir ci-dessous) |
| **Graphiques interactifs** (infobulles natives, zoom) | 🟡 Indirect | objets ggplot2 → `plotly::ggplotly()` |
| **Tableau de bord**, comptes, upload | ❌ Non | fonctionnalités web, remplacées par des appels scriptables |

En résumé : le package reproduit désormais **les sorties numériques ET
graphiques** du modèle (tables journalières/annuelles, indicateurs,
classement, graphiques, statistiques) et fournit le **pipeline
cartographique** pour produire des cartes de type BILJOU. Seules restent
hors périmètre l’interface web et les cartes nationales
**pré-calculées** (mais elles sont reproductibles avec
[`biljou_run_grid()`](https://pobsteta.github.io/biljouR/reference/biljou_run_grid.md)
sur une grille SAFRAN).

## Cartographie et données SAFRAN

Pour produire des cartes comme l’outil en ligne, il faut une météo en
points de grille. Les données **SAFRAN** (réanalyse Météo-France, maille
8×8 km, journalier, 1958→présent) sont **gratuites** depuis 2024. Pour
ce package, le **miroir NetCDF par variable** (INRAE, DOI
10.57745/BAZ12C) est la source la plus pratique : on ne télécharge que
les variables utiles (`PRELIQ_Q`, `PRENEI_Q`, `ETP_Q`), une fois, puis
on extrait tous les points en lecture paresseuse. Le package fournit des
fonctions dédiées :

``` r

# 1. lister et télécharger les NetCDF des variables utiles (API Dataverse)
files <- safran_download(variables = c("PRELIQ_Q","PRENEI_Q","ETP_Q"),
                         dest_dir = "safran")   # -> chemins locaux nommés

# 2. extraire la météo par point depuis les NetCDF (terra)
points <- data.frame(id = c("p1","p2"), lon = c(6.0,6.2), lat = c(48.6,48.8))
meteo_list <- safran_nc_to_meteo(files, points)  # liste de data.frames par point

# 3. lancer le modèle sur la grille, puis cartographier
grid <- biljou_run_grid(points, meteo = meteo_list,
                        soil = biljou_soil(140), lai_max = 5,
                        forest_type = "broadleaved",
                        budburst = 110, leaf_fall = 300,
                        indicators = "NJstress")
r <- biljou_grid_to_raster(grid, indicator = "NJstress", year = 2003)
terra::plot(r)
```

Autres voies d’accès aux mêmes données SAFRAN :

- **meteo.data.gouv.fr** — jeu « Données changement climatique – SIM
  quotidienne » : CSV compressés par lots de 1 à 10 ans (à lire puis
  convertir avec
  [`safran_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_to_meteo.md)).
  <https://meteo.data.gouv.fr>
- **API OGC EDR SAFRAN** (1958→aujourd’hui) pour des requêtes ciblées
  par emprise/période — plus léger pour une simulation ponctuelle.
- Alternative mondiale : **ERA5-Land** (≈9 km) via le package R
  `ecmwfr`.

Mention obligatoire à la diffusion : « Source : Météo-France ». La
géométrie de la grille SAFRAN peut varier selon les produits : inspectez
un fichier avec
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html)
et ajustez le mapping de
[`safran_nc_to_meteo()`](https://pobsteta.github.io/biljouR/reference/safran_nc_to_meteo.md)
si besoin.

## Limites assumées

Certaines constantes ne sont décrites que qualitativement dans la
documentation publique (partage macro/microporosité, pondération du
prélèvement racinaire, coefficient d’évaporation du sous-étage,
comportement de l’interception aux fortes pluies). Les choix faits ici
sont transparents et documentés dans le code et la vignette, et
devraient être **calés sur l’outil officiel** avant tout usage en
production.

## Licence

GPL-3.
