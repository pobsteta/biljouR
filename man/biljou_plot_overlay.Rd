\name{biljou_plot_overlay}
\alias{biljou_plot_overlay}
\title{Overlay years by day-of-year (inter-annual comparison)}
\usage{biljou_plot_overlay(run, var = "REW", stat = c("median","mean","none"))}
\arguments{
\item{run}{A \code{\link{biljou_run}} object.}
\item{var}{A single variable or alias (default "REW").}
\item{stat}{Optional summary curve: "median", "mean" or "none".}
}
\value{A \pkg{ggplot2} object.}
\description{One curve per year vs day-of-year, with an optional mean/median
summary curve (and the REW=0.4 threshold for REW). Requires \pkg{ggplot2}.}
