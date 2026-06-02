\name{biljou_annual_balance}
\alias{biljou_annual_balance}
\title{Annual water balance summary}
\usage{biljou_annual_balance(run)}
\arguments{\item{run}{A \code{\link{biljou_run}} object.}}
\value{A data frame of yearly flux totals (mm).}
\description{Sums the elementary water fluxes by calendar year so that
\eqn{P \approx In + T + Eu + D + \Delta W} can be checked.}
