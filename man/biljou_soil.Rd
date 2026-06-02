\name{biljou_soil}
\alias{biljou_soil}
\alias{print.biljou_soil}
\title{Define a soil profile}
\usage{biljou_soil(ewm, roots = NULL, macro = NULL, micro = NULL, init = 1)}
\arguments{
\item{ewm}{Maximum extractable water per layer (mm), length 1-3.}
\item{roots}{Fine-root fractions per layer (sum to 1); default proportional to ewm.}
\item{macro, micro}{Optional macro-/micro-porosity per layer controlling the
fast-bypass fraction \code{macro/(macro+micro)} during infiltration.}
\item{init}{Initial relative extractable water (0-1) per layer (default 1).}
}
\value{An object of class \code{biljou_soil}.}
\description{Describes the 1-3 layer soil profile used by \code{\link{biljou_run}}.}
