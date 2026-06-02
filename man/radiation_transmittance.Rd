\name{radiation_transmittance}
\alias{radiation_transmittance}
\title{Fraction of incident radiation transmitted through the canopy}
\usage{radiation_transmittance(lai, k = 0.5)}
\arguments{
\item{lai}{Leaf area index (m2 m-2).}
\item{k}{Light extinction coefficient (default 0.5).}
}
\value{Transmitted fraction in [0, 1].}
\description{Beer-Lambert extinction \eqn{R/R0 = exp(-k\,LAI)}.}
