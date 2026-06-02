\name{biljou_rank_droughts}
\alias{biljou_rank_droughts}
\title{Rank years by drought severity}
\usage{biljou_rank_droughts(run)}
\arguments{\item{run}{A \code{\link{biljou_run}} object or a
\code{\link{biljou_indices}} data frame.}}
\value{The per-year indices with added \code{rank_duration},
\code{rank_intensity} and \code{rank_precocity} columns (1 = most severe).}
\description{Reproduces the BILJOU "classified drought years" output, ranking
years by duration (\code{NJstress}), intensity (\code{Istress}) and earliness
of onset (\code{DEBstress}).}
