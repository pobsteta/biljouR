\name{biljou_indices}
\alias{biljou_indices}
\title{Drought indices from a BILJOU run}
\usage{biljou_indices(run)}
\arguments{\item{run}{A \code{\link{biljou_run}} object.}}
\value{A data frame, one row per year, with \code{stress_days},
\code{is_index} (\eqn{Is = \sum SWD/EWM}), \code{max_rel_deficit},
\code{min_rew}, \code{precocity_doy} and flux totals.}
\description{Per-year drought indicators (Granier et al. 1999, Eqs. 4-5),
accumulated over the leafed period for deciduous stands.}
