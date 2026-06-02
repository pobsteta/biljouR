# biljouR

<!-- badges: start -->
[![R-CMD-check](https://github.com/pobsteta/biljouR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pobsteta/biljouR/actions/workflows/R-CMD-check.yaml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
<!-- badges: end -->

Réimplémentation **indépendante en R du modèle de bilan hydrique forestier
BILJOU** (Granier, Bréda, Biron & Villette, 1999, *Ecological Modelling*
116:269-283), tel que documenté par l'INRAE UMR Silva
(<https://appgeodb.nancy.inrae.fr/biljou/>).

> ⚠️ Ce package est une réimplémentation indépendante, à des fins de recherche
> et d'enseignement. Il **n'est ni produit ni cautionné par l'INRAE**. Pour des
> simulations de référence, utilisez l'outil officiel en ligne.

## Ce qu'il fait

Calcule, au pas de temps **journalier**, le bilan hydrique du sol
`ΔW = P − In − T − Eu − D` d'un peuplement forestier et renvoie les flux
journaliers, le contenu en eau du sol, la réserve en eau relative (REW) et les
indicateurs de sécheresse (nombre de jours de stress, indice de stress
*Istress*, intensité, précocité).

## Installation

Depuis GitHub (recommandé) :

```r
# install.packages("remotes")
remotes::install_github("pobsteta/biljouR")

# avec la vignette :
remotes::install_github("pobsteta/biljouR", build_vignettes = TRUE)
```

Ou depuis une archive source locale :

```r
install.packages("chemin/vers/biljouR_0.1.0.tar.gz", repos = NULL, type = "source")
```

## Prise en main rapide

```r
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

* **Météo** (journalière) : `pet` (mm, Penman) et `rain` (mm). La fonction
  `penman_pet()` calcule l'ETP Penman à partir de la température, du
  rayonnement, du vent et de l'humidité si besoin.
* **Peuplement** : `lai_max`, `forest_type` (et dates de débourrement / chute
  des feuilles si décidu).
* **Sol** : 1 à 3 couches, chacune avec son eau extractible maximale, sa
  fraction de racines fines et, optionnellement, sa macro-/microporosité.

## Composants du modèle

| Processus | Fonction | Référence |
|---|---|---|
| Phénologie / LAI | `biljou_lai()` | Granier et al. 1999 |
| Transpiration | `transpiration_ratio()`, `potential_transpiration()` | Éq. 2 |
| Interception | `rainfall_interception()` | Aussenac 1968 ; Éq. 3 |
| Évaporation sous-étage | `potential_understorey_evap()` | §3.3 |
| Sol & drainage | `biljou_soil()`, infiltration interne | §3.4 |
| Indicateurs de sécheresse | `biljou_indices()`, `biljou_rank_droughts()` | Éq. 4-5 |
| ETP Penman | `penman_pet()` | Penman 1948 / FAO-56 |

## Correspondance avec les sorties de l'outil en ligne

| Sortie de l'outil BILJOU | Fournie par le package ? | Comment |
|---|---|---|
| Fichier de **résultats journaliers** (P, In, Th, T, Eu, ETR, ETP, drainage, REW, réserve) | ✅ Oui | `run$daily` (data.frame) |
| Fichier de **résultats annuels** (bilan + NJstress, Istress, DEBstress) | ✅ Oui | `biljou_indices()` + `biljou_annual_balance()` |
| **Classement des années** de sécheresse (3 indicateurs) | ✅ Oui | `biljou_rank_droughts()` |
| **Graphiques** intra-annuels (ETP, ETR, T, Eu, REW, drainage…) | 🟡 Partiel | `plot(run)` (REW + flux) ; toutes les variables sont dans `run$daily`, à tracer avec ggplot2/base |
| **Graphiques interactifs** (infobulles, zoom, superposition d'années) | ❌ Non | non inclus (réalisable avec plotly/dygraphs à partir de `run$daily`) |
| **Statistiques** inter-annuelles (moyenne/médiane par jour) | ❌ Non | à dériver de `run$daily` |
| **Chronique journalière** multi-années | 🟡 Partiel | `run$daily` couvre plusieurs années ; `plot()` trace toute la série |
| **Cartes de sécheresse** de France (archive SAFRAN, maille 8×8 km) | ❌ Non | service cartographique distinct, pré-calculé ; reproductible en bouclant `biljou_run()` sur une grille météo, mais ni les données SAFRAN ni le pipeline ne sont fournis |
| **Tableau de bord**, comptes, format de fichier, upload | ❌ Non | fonctionnalités de l'application web, remplacées par des appels de fonctions scriptables |

En résumé : le package reproduit **le modèle et ses sorties numériques**
(tables journalières et annuelles, les trois indicateurs, le classement des
années). Comme tout est renvoyé sous forme de data.frame, n'importe quel
graphique, statistique ou carte peut être reconstruit en quelques lignes ; mais
la **suite graphique interactive** et les **cartes nationales pré-calculées**
(SAFRAN) ne sont pas livrées clé en main.

## Limites assumées

Certaines constantes ne sont décrites que qualitativement dans la documentation
publique (partage macro/microporosité, pondération du prélèvement racinaire,
coefficient d'évaporation du sous-étage, comportement de l'interception aux
fortes pluies). Les choix faits ici sont transparents et documentés dans le
code et la vignette, et devraient être **calés sur l'outil officiel** avant tout
usage en production.

## Licence

GPL-3.
