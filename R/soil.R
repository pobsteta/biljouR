#' BILJOU soil description and water movement
#'
#' The soil profile is described by one to three horizontal layers. Each layer
#' is characterised by its maximum extractable water (\code{ewm}, mm), the
#' fraction of fine roots it contains, and optionally its macro-/micro-porosity
#' which controls how fast water bypasses the layer during infiltration
#' (Granier et al. 1999, section 3.4).
#'
#' @name biljou-soil
NULL

#' Define a soil profile
#'
#' @param ewm Numeric vector: maximum extractable water of each layer (mm),
#'   i.e. field capacity minus wilting point integrated over the layer depth.
#'   Length 1-3.
#' @param roots Numeric vector of fine-root fractions per layer (summing to 1).
#'   Defaults to proportional to \code{ewm}.
#' @param macro,micro Optional numeric vectors giving the macro- and
#'   micro-porosity (any consistent unit) of each layer. If supplied, on each
#'   day a fraction \code{macro/(macro+micro)} of the water entering a layer
#'   bypasses it through fast (gravitational) flow and reaches the next layer,
#'   while the complementary fraction refills the layer. If \code{NULL}
#'   (default) a simple bucket cascade is used (a layer fills to field capacity
#'   before any water drains to the next one).
#' @param init Initial relative extractable water (0-1) for every layer
#'   (default 1, i.e. field capacity).
#' @return An object of class \code{biljou_soil}.
#' @export
biljou_soil <- function(ewm, roots = NULL, macro = NULL, micro = NULL, init = 1) {
  ewm <- as.numeric(ewm)
  n <- length(ewm)
  if (n < 1 || n > 3) stop("BILJOU uses between 1 and 3 soil layers.")
  if (any(ewm <= 0)) stop("All layer EWM values must be positive.")
  if (is.null(roots)) {
    roots <- ewm / sum(ewm)
  } else {
    roots <- as.numeric(roots)
    if (length(roots) != n) stop("`roots` must have one value per layer.")
    if (abs(sum(roots) - 1) > 1e-6) roots <- roots / sum(roots)
  }
  use_macro <- !is.null(macro) && !is.null(micro)
  if (use_macro) {
    if (length(macro) != n || length(micro) != n)
      stop("`macro` and `micro` must have one value per layer.")
    bypass <- macro / (macro + micro)          # fraction bypassing each layer
  } else {
    bypass <- rep(0, n)
  }
  structure(
    list(ewm = ewm, roots = roots, bypass = bypass,
         use_macro = use_macro, init = init, n = n,
         ewm_total = sum(ewm)),
    class = "biljou_soil"
  )
}

#' @export
print.biljou_soil <- function(x, ...) {
  cat("<biljou_soil>:", x$n, "layer(s)\n")
  df <- data.frame(layer = seq_len(x$n), ewm_mm = x$ewm,
                   root_frac = round(x$roots, 3),
                   bypass_frac = round(x$bypass, 3))
  print(df, row.names = FALSE)
  cat("Total extractable water (EWM):", round(x$ewm_total, 1), "mm\n")
  invisible(x)
}

# ---------------------------------------------------------------------------
# Infiltration & drainage (one day)
# ---------------------------------------------------------------------------

# ew: current extractable water per layer (mm)
# throughfall: water arriving at the soil surface (mm)
# Returns list(ew = updated extractable water, drainage = water leaving bottom)
.infiltrate <- function(ew, throughfall, soil) {
  n <- soil$n
  inflow <- throughfall
  for (i in seq_len(n)) {
    capacity <- soil$ewm[i] - ew[i]          # room before field capacity
    if (soil$use_macro) {
      to_macro <- inflow * soil$bypass[i]    # fast bypass to next layer
      to_micro <- inflow - to_macro          # may refill this layer
    } else {
      to_macro <- 0
      to_micro <- inflow
    }
    refill <- min(to_micro, capacity)
    excess <- to_micro - refill              # overflow once at field capacity
    ew[i] <- ew[i] + refill
    inflow <- to_macro + excess              # passes down to layer i+1
  }
  list(ew = ew, drainage = inflow)           # water leaving the deepest layer
}

# ---------------------------------------------------------------------------
# Root water uptake (one day)
# ---------------------------------------------------------------------------

# Distribute a transpiration demand across layers, weighted by root fraction
# and current relative extractable water (so depleted layers contribute less,
# reproducing the seasonal downward shift of uptake described by INRAE).
# Any unmet demand in a saturated-out layer is redistributed to the others.
.uptake <- function(ew, demand, soil) {
  n <- soil$n
  uptake <- numeric(n)
  remaining <- demand
  available <- ew
  for (iter in seq_len(n)) {
    if (remaining <= 1e-12) break
    rew <- available / soil$ewm
    w <- soil$roots * rew
    w[available <= 1e-12] <- 0
    if (sum(w) <= 0) break
    w <- w / sum(w)
    take <- pmin(remaining * w, available)
    uptake <- uptake + take
    available <- available - take
    remaining <- demand - sum(uptake)
  }
  list(ew = available, uptake = uptake, taken = sum(uptake))
}
