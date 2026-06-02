#' Run BILJOU over a grid of points (cartographic pipeline)
#'
#' Applies \code{\link{biljou_run}} to each point of a spatial grid and extracts
#' annual drought indicators, yielding a long table of (point, year, indicator,
#' value) with coordinates - ready to map with \code{\link{biljou_grid_to_sf}}
#' or \code{\link{biljou_grid_to_raster}}. This is the building block to
#' reproduce BILJOU's national drought maps from a gridded climate dataset such
#' as SAFRAN (see the package README / vignette for data access).
#'
#' Meteorology and (optionally) soil and LAI are supplied per point so that the
#' grid can mix climates and site conditions.
#'
#' @param points A data frame with one row per grid point, including identifier
#'   and coordinate columns (see \code{id_col}, \code{lon_col}, \code{lat_col}).
#' @param meteo Per-point meteorology, given as either: a function
#'   \code{function(id) -> data.frame}, a named list of data frames keyed by
#'   point id, or a single data frame applied to every point.
#' @param soil A \code{\link{biljou_soil}} applied to all points, or a function
#'   \code{function(id) -> biljou_soil}, or a named list of soils.
#' @param lai_max Maximum LAI (single value), or a function \code{function(id)}.
#' @param forest_type "broadleaved" or "coniferous" (single value or function).
#' @param budburst,leaf_fall Day-of-year for deciduous stands (single value or
#'   function of id), passed to \code{\link{biljou_run}}.
#' @param indicators Which annual indicators to keep (columns returned by
#'   \code{\link{biljou_indices}}); default the three BILJOU indicators plus
#'   \code{min_rew} and \code{drainage}.
#' @param years Optional integer vector to keep only some years.
#' @param id_col,lon_col,lat_col Column names in \code{points}.
#' @param verbose Print progress (default TRUE).
#' @param ... Extra arguments passed to \code{\link{biljou_run}}.
#' @return A data frame of class \code{biljou_grid} with columns \code{id},
#'   \code{lon}, \code{lat}, \code{year}, \code{indicator}, \code{value}.
#' @export
biljou_run_grid <- function(points, meteo, soil, lai_max, forest_type,
                            budburst = NULL, leaf_fall = NULL,
                            indicators = c("NJstress", "Istress", "DEBstress",
                                           "min_rew", "drainage"),
                            years = NULL,
                            id_col = "id", lon_col = "lon", lat_col = "lat",
                            verbose = TRUE, ...) {
  for (cl in c(id_col, lon_col, lat_col))
    if (!cl %in% names(points)) stop("`points` must contain column '", cl, "'.")

  as_fun <- function(x, what) {
    if (is.function(x)) return(x)
    if (is.list(x) && !is.data.frame(x) && !inherits(x, "biljou_soil"))
      return(function(id) x[[as.character(id)]])
    function(id) x                                   # constant / single object
  }
  get_meteo <- if (is.function(meteo)) meteo
               else if (is.data.frame(meteo)) function(id) meteo
               else function(id) meteo[[as.character(id)]]
  get_soil  <- as_fun(soil, "soil")
  get_lai   <- as_fun(lai_max, "lai_max")
  get_type  <- as_fun(forest_type, "forest_type")
  get_bb    <- as_fun(budburst, "budburst")
  get_lf    <- as_fun(leaf_fall, "leaf_fall")

  ids <- points[[id_col]]
  n <- length(ids)
  res <- vector("list", n)
  for (i in seq_len(n)) {
    id <- ids[i]
    if (verbose && (i %% max(1, n %/% 20) == 0 || i == n))
      message(sprintf("  point %d/%d", i, n))
    m <- get_meteo(id)
    if (is.null(m) || !nrow(m)) { res[[i]] <- NULL; next }
    run <- tryCatch(
      biljou_run(m, get_soil(id), lai_max = get_lai(id),
                 forest_type = get_type(id),
                 budburst = get_bb(id), leaf_fall = get_lf(id), ...),
      error = function(e) { warning("point ", id, ": ", conditionMessage(e)); NULL })
    if (is.null(run)) next
    idx <- biljou_indices(run)
    if (!is.null(years)) idx <- idx[idx$year %in% years, , drop = FALSE]
    if (!nrow(idx)) next
    keep <- intersect(indicators, names(idx))
    long <- do.call(rbind, lapply(keep, function(v)
      data.frame(id = id,
                 lon = points[[lon_col]][i], lat = points[[lat_col]][i],
                 year = idx$year, indicator = v, value = idx[[v]],
                 stringsAsFactors = FALSE)))
    res[[i]] <- long
  }
  out <- do.call(rbind, res)
  if (is.null(out)) out <- data.frame(id = character(), lon = numeric(),
                                      lat = numeric(), year = integer(),
                                      indicator = character(), value = numeric())
  structure(out, class = c("biljou_grid", "data.frame"))
}

#' @export
print.biljou_grid <- function(x, ...) {
  cat("<biljou_grid>:", length(unique(x$id)), "points,",
      length(unique(x$year)), "year(s),",
      length(unique(x$indicator)), "indicator(s)\n")
  cat("Indicators:", paste(unique(x$indicator), collapse = ", "), "\n")
  NextMethod()
}

.grid_slice <- function(grid, indicator, year) {
  inds <- unique(grid$indicator); yrs <- unique(grid$year)
  if (is.null(indicator)) {
    if (length(inds) > 1) stop("Several indicators present; choose `indicator`: ",
                               paste(inds, collapse = ", "))
    indicator <- inds
  }
  if (is.null(year)) {
    if (length(yrs) > 1) stop("Several years present; choose `year`: ",
                              paste(yrs, collapse = ", "))
    year <- yrs
  }
  g <- grid[grid$indicator == indicator & grid$year == year, , drop = FALSE]
  if (!nrow(g)) stop("No rows for indicator='", indicator, "', year=", year, ".")
  attr(g, "indicator") <- indicator; attr(g, "year") <- year
  g
}

#' Convert a grid result to an sf points layer
#'
#' @param grid A \code{biljou_grid} (output of \code{\link{biljou_run_grid}}).
#' @param indicator Indicator to map (required if several are present).
#' @param year Year to map (required if several are present).
#' @param crs Coordinate reference system (default EPSG:4326).
#' @return An \pkg{sf} object with a \code{value} column.
#' @export
biljou_grid_to_sf <- function(grid, indicator = NULL, year = NULL, crs = 4326) {
  if (!requireNamespace("sf", quietly = TRUE))
    stop("Package 'sf' is required. install.packages('sf').", call. = FALSE)
  g <- .grid_slice(grid, indicator, year)
  sf::st_as_sf(g, coords = c("lon", "lat"), crs = crs)
}

#' Rasterise a grid result with terra
#'
#' Builds a \pkg{terra} \code{SpatRaster} from the (lon, lat, value) triplets.
#' Points are expected to lie on a regular grid (as SAFRAN does); the raster
#' resolution is inferred from the coordinate spacing unless given.
#'
#' @param grid A \code{biljou_grid}.
#' @param indicator,year Indicator and year to map (required if several present).
#' @param crs CRS for the raster (default EPSG:4326).
#' @return A \pkg{terra} \code{SpatRaster} (single layer named by the indicator).
#' @export
biljou_grid_to_raster <- function(grid, indicator = NULL, year = NULL, crs = "EPSG:4326") {
  if (!requireNamespace("terra", quietly = TRUE))
    stop("Package 'terra' is required. install.packages('terra').", call. = FALSE)
  g <- .grid_slice(grid, indicator, year)
  r <- terra::rast(data.frame(x = g$lon, y = g$lat, value = g$value),
                   type = "xyz", crs = crs)
  names(r) <- attr(g, "indicator")
  r
}
