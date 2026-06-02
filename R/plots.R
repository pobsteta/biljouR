#' ggplot2 graphics for BILJOU runs
#'
#' These helpers return \pkg{ggplot2} objects, so they can be further themed,
#' faceted or combined by the user. They require the suggested package
#' \pkg{ggplot2}.
#'
#' Variable names accept both the data-frame column names and common aliases:
#' \code{ETP} = \code{pet}, \code{ETR} = \code{et}, \code{T} =
#' \code{transpiration}, \code{Eu} = \code{understorey}, \code{Dr} =
#' \code{drainage}, \code{In} = \code{interception}, \code{P} = \code{rain},
#' \code{REW} = \code{rew}.
#'
#' @name biljou-plots
NULL

# silence R CMD check notes for aes() column references
utils::globalVariables(c("date", "value", "variable", "doy", "year",
                         "rew", ".data"))

.var_alias <- c(ETP = "pet", ETR = "et", T = "transpiration", Tr = "transpiration",
                Eu = "understorey", REW = "rew", Dr = "drainage", D = "drainage",
                In = "interception", P = "rain", Th = "throughfall",
                W = "soil_water", SWD = "swd", LAI = "lai")

.var_label <- c(pet = "ETP (mm)", et = "ETR (mm)", transpiration = "Transpiration (mm)",
                understorey = "Sous-etage Eu (mm)", drainage = "Drainage (mm)",
                interception = "Interception (mm)", rain = "Pluie (mm)",
                throughfall = "Pluie au sol (mm)", soil_water = "Reserve (mm)",
                rew = "REW", swd = "Deficit SWD (mm)", lai = "LAI (m2 m-2)")

.resolve_vars <- function(vars, available) {
  out <- ifelse(vars %in% names(.var_alias), .var_alias[vars], vars)
  bad <- setdiff(out, available)
  if (length(bad))
    stop("Unknown variable(s): ", paste(bad, collapse = ", "),
         ". Available: ", paste(available, collapse = ", "), ".")
  unname(out)
}

.need_ggplot <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' is required for this plot. ",
         "Install it with install.packages('ggplot2').", call. = FALSE)
}

.daily_long <- function(run, vars) {
  d <- run$daily
  cols <- .resolve_vars(vars, names(d))
  long <- do.call(rbind, lapply(cols, function(cl) {
    data.frame(date = d$date, doy = d$doy,
               variable = factor(.var_label[cl], levels = .var_label[cols]),
               value = d[[cl]], stringsAsFactors = FALSE)
  }))
  long
}

#' Time series of daily fluxes / states (and multi-year chronicle)
#'
#' Faceted line plot of one or several daily variables over the whole run; with
#' a multi-year run this is the multi-year chronicle. Use \code{from}/\code{to}
#' to zoom on a period.
#'
#' @param run A \code{\link{biljou_run}} object.
#' @param vars Character vector of variables or aliases (default
#'   ETP, ETR, transpiration, understorey, drainage, REW).
#' @param from,to Optional date bounds (Date or coercible).
#' @param free_y Free y-axis per facet (default TRUE).
#' @return A \pkg{ggplot2} object.
#' @export
biljou_plot_timeseries <- function(run,
                                   vars = c("ETP", "ETR", "transpiration",
                                            "understorey", "drainage", "REW"),
                                   from = NULL, to = NULL, free_y = TRUE) {
  .need_ggplot()
  long <- .daily_long(run, vars)
  if (!is.null(from)) long <- long[long$date >= as.Date(from), ]
  if (!is.null(to))   long <- long[long$date <= as.Date(to), ]
  ggplot2::ggplot(long, ggplot2::aes(.data$date, .data$value)) +
    ggplot2::geom_line(color = "#1b6ca8", linewidth = 0.4) +
    ggplot2::facet_wrap(~variable,
                        scales = if (free_y) "free_y" else "fixed",
                        ncol = 1, strip.position = "left") +
    ggplot2::labs(x = NULL, y = NULL,
                  title = "BILJOU - chronique journaliere") +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.placement = "outside",
                   strip.background = ggplot2::element_blank())
}

#' Overlay years by day-of-year (inter-annual comparison)
#'
#' Reproduces the online tool's year-comparison view: one curve per year as a
#' function of day-of-year, with an optional mean or median summary curve. For
#' REW the critical threshold (0.4) is drawn.
#'
#' @param run A \code{\link{biljou_run}} object.
#' @param var A single variable or alias (default "REW").
#' @param stat Summary curve to overlay: "none", "mean" or "median".
#' @return A \pkg{ggplot2} object.
#' @export
biljou_plot_overlay <- function(run, var = "REW",
                                stat = c("median", "mean", "none")) {
  .need_ggplot()
  stat <- match.arg(stat)
  if (length(var) != 1) stop("`var` must be a single variable.")
  d <- run$daily
  cl <- .resolve_vars(var, names(d))
  df <- data.frame(doy = d$doy, value = d[[cl]],
                   year = factor(if (inherits(d$date, "Date"))
                     format(d$date, "%Y") else "1"))
  p <- ggplot2::ggplot(df, ggplot2::aes(.data$doy, .data$value,
                                        group = .data$year, color = .data$year)) +
    ggplot2::geom_line(alpha = 0.6, linewidth = 0.4) +
    ggplot2::labs(x = "Jour de l'annee", y = unname(.var_label[cl]),
                  color = "Annee",
                  title = paste0("Superposition annuelle - ", .var_label[cl])) +
    ggplot2::theme_bw()
  if (cl == "rew") p <- p + ggplot2::geom_hline(yintercept = run$params$rew_c,
                                                linetype = 2, color = "red")
  if (stat != "none") {
    st <- biljou_doy_stats(run, var)
    st$summ <- if (stat == "mean") st$mean else st$median
    p <- p + ggplot2::geom_line(data = st,
                                ggplot2::aes(.data$doy, .data$summ),
                                inherit.aes = FALSE,
                                color = "black", linewidth = 1)
  }
  p
}
