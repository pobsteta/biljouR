\name{transpiration_ratio}
\alias{transpiration_ratio}
\title{Potential stand transpiration ratio r = T / PET}
\usage{transpiration_ratio(lai, r_max = 0.75, lai_threshold = 6)}
\arguments{
\item{lai}{Leaf area index.}
\item{r_max}{Maximum T/PET ratio at high LAI (default 0.75).}
\item{lai_threshold}{LAI above which r is saturated (default 6).}
}
\value{T/PET ratio.}
\description{\eqn{r = 0.125\,LAI} for \eqn{LAI \le 6}, else \eqn{r = 0.75}
(Granier et al. 1999, Eq. 2).}
