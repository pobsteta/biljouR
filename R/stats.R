#' Inter-annual statistics by day-of-year
#'
#' For each day-of-year, summarises a daily variable across the years of a
#' multi-year run: number of years, mean, standard deviation, median and
#' user-chosen quantiles. This reproduces the "statistics" curves of the online
#' tool (typically mean or median). Implemented in base R.
#'
#' @param run A \code{\link{biljou_run}} object.
#' @param var A single variable or alias (see \code{\link{biljou_plot_overlay}};
#'   default "REW").
#' @param probs Quantile probabilities to compute (default 0.1 and 0.9, in
#'   addition to the median).
#' @return A data frame with columns \code{doy}, \code{n}, \code{mean},
#'   \code{sd}, \code{median} and one column per requested quantile
#'   (e.g. \code{q10}, \code{q90}).
#' @examples
#' data(meteo_hesse)
#' # build a 2-year series by stacking the example year
#' m2 <- rbind(meteo_hesse,
#'             transform(meteo_hesse, date = meteo_hesse$date + 365))
#' run <- biljou_run(m2, biljou_soil(150), lai_max = 6, forest_type = "coniferous")
#' head(biljou_doy_stats(run, "REW"))
#' @export
biljou_doy_stats <- function(run, var = "REW", probs = c(0.1, 0.9)) {
  if (!inherits(run, "biljou_run")) stop("`run` must be a biljou_run object.")
  d <- run$daily
  cl <- .resolve_vars(var, names(d))
  doy <- d$doy
  val <- d[[cl]]
  agg1 <- function(f) tapply(val, doy, f)
  qs <- lapply(probs, function(p)
    tapply(val, doy, function(x) stats::quantile(x, p, na.rm = TRUE)))
  out <- data.frame(
    doy    = as.integer(names(agg1(mean))),
    n      = as.integer(tapply(val, doy, function(x) sum(!is.na(x)))),
    mean   = as.numeric(agg1(function(x) mean(x, na.rm = TRUE))),
    sd     = as.numeric(agg1(function(x) stats::sd(x, na.rm = TRUE))),
    median = as.numeric(agg1(function(x) stats::median(x, na.rm = TRUE)))
  )
  for (i in seq_along(probs)) {
    out[[paste0("q", round(probs[i] * 100))]] <- as.numeric(qs[[i]])
  }
  attr(out, "variable") <- cl
  out
}
