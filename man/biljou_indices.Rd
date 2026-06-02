\name{biljou_indices}
\alias{biljou_indices}
\title{Drought indices from a BILJOU run}
\usage{biljou_indices(run)}
\arguments{\item{run}{A \code{\link{biljou_run}} object.}}
\value{A data frame, one row per year, with the BILJOU annual-file indicators
\code{NJstress} (number of stress days), \code{Istress}
(\eqn{\sum (0.4 - REW)/0.4}, online-tool definition), \code{DEBstress}
(day-of-year of drought onset), plus \code{min_rew}, \code{is_1999}
(\eqn{\sum (0.4 - REW)}, Granier et al. 1999 Eq. 5) and flux totals.}
\description{Per-year ecophysiological drought indicators, accumulated over the
leafed period for deciduous stands and the whole year for evergreen stands.}
\references{Granier A, Breda N, Biron P, Villette S (1999) Ecological
Modelling 116:269-283.}
