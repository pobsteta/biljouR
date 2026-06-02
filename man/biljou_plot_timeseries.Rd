\name{biljou_plot_timeseries}
\alias{biljou_plot_timeseries}
\alias{biljou-plots}
\title{Time series of daily fluxes / states (multi-year chronicle)}
\usage{biljou_plot_timeseries(run,
  vars = c("ETP","ETR","transpiration","understorey","drainage","REW"),
  from = NULL, to = NULL, free_y = TRUE)}
\arguments{
\item{run}{A \code{\link{biljou_run}} object.}
\item{vars}{Variables or aliases (ETP=pet, ETR=et, T=transpiration, Eu=understorey, Dr=drainage, In=interception, P=rain, REW=rew).}
\item{from, to}{Optional date bounds.}
\item{free_y}{Free y-axis per facet (default TRUE).}
}
\value{A \pkg{ggplot2} object.}
\description{Faceted line plot of one or several daily variables; with a
multi-year run this is the multi-year chronicle. Requires \pkg{ggplot2}.}
