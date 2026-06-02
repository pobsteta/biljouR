\name{potential_transpiration}
\alias{potential_transpiration}
\title{Daily potential overstorey transpiration}
\usage{potential_transpiration(pet, lai, r_max = 0.75, lai_threshold = 6)}
\arguments{
\item{pet}{Potential evapotranspiration (mm).}
\item{lai}{Leaf area index.}
\item{r_max, lai_threshold}{See \code{\link{transpiration_ratio}}.}
}
\value{Potential transpiration (mm).}
\description{\eqn{T_p = r(LAI) \times PET}. Stress and wet-canopy reductions are
applied in \code{\link{biljou_run}}.}
