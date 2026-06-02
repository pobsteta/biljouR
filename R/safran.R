#' Access the SAFRAN NetCDF mirror (INRAE Dataverse)
#'
#' Helpers to list and download the per-variable NetCDF files of the
#' "SIM quotidienne (SAFRAN)" reanalysis mirrored on the INRAE Recherche Data
#' Gouv repository (a Dataverse instance), DOI \code{10.57745/BAZ12C}. One
#' NetCDF file is published per SIM variable for the whole reanalysis period,
#' which makes it convenient to fetch only the few variables BILJOU needs
#' (\code{PRELIQ_Q}, \code{PRENEI_Q}, \code{ETP_Q}).
#'
#' These functions query the standard Dataverse API
#' (\code{/api/datasets/:persistentId} to list, \code{/api/access/datafile/{id}}
#' to download). They require a network connection and the suggested package
#' \pkg{jsonlite}; the NetCDF reader additionally requires \pkg{terra}.
#'
#' Data are free to reuse with the mention "Source : Meteo-France".
#'
#' @name safran-download
NULL


#' List the files of the SAFRAN NetCDF dataset
#'
#' @param doi Dataverse persistent id (default the SIM quotidienne mirror).
#' @param server Dataverse server base URL.
#' @return A data frame with columns \code{id}, \code{filename},
#'   \code{contentType}, \code{size_mb}.
#' @export
safran_dataverse_files <- function(doi = "doi:10.57745/BAZ12C", server = "https://entrepot.recherche.data.gouv.fr") {
  if (!requireNamespace("jsonlite", quietly = TRUE))
    stop("Package 'jsonlite' is required. install.packages('jsonlite').",
         call. = FALSE)
  url <- paste0(server, "/api/datasets/:persistentId/?persistentId=", doi)
  js <- tryCatch(jsonlite::fromJSON(url, simplifyVector = FALSE),
                 error = function(e)
                   stop("Could not query the Dataverse API at ", server,
                        " (", conditionMessage(e), "). Check the URL/network.",
                        call. = FALSE))
  if (!identical(js$status, "OK"))
    stop("Dataverse API returned status: ", js$status)
  files <- js$data$latestVersion$files
  if (!length(files)) stop("No files found for ", doi, ".")
  do.call(rbind, lapply(files, function(f) {
    df <- f$dataFile
    data.frame(id = df$id,
               filename = if (!is.null(df$filename)) df$filename else f$label,
               contentType = if (!is.null(df$contentType)) df$contentType else NA,
               size_mb = if (!is.null(df$filesize)) round(df$filesize / 1e6, 1) else NA,
               stringsAsFactors = FALSE)
  }))
}

#' Download SAFRAN NetCDF variable files
#'
#' Resolves, among the dataset files, those matching the requested SIM variable
#' codes and downloads them. By default a file matches a variable if its name
#' contains the variable code (e.g. "PRELIQ_Q").
#'
#' @param variables Character vector of SIM variable codes to fetch (default the
#'   three BILJOU inputs: liquid rain, solid rain, reference ET).
#' @param dest_dir Destination directory (created if needed).
#' @param doi,server See \code{\link{safran_dataverse_files}}.
#' @param files Optional pre-fetched output of \code{\link{safran_dataverse_files}}
#'   (avoids a second API call).
#' @param overwrite Re-download existing files (default FALSE).
#' @param quiet Suppress download progress (default FALSE).
#' @return A named character vector of local file paths (names = variables).
#' @export
safran_download <- function(variables = c("PRELIQ_Q", "PRENEI_Q", "ETP_Q"),
                            dest_dir = "safran",
                            doi = "doi:10.57745/BAZ12C", server = "https://entrepot.recherche.data.gouv.fr",
                            files = NULL, overwrite = FALSE, quiet = FALSE) {
  if (is.null(files)) files <- safran_dataverse_files(doi, server)
  if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
  paths <- character(0)
  for (v in variables) {
    hit <- files[grepl(v, files$filename, fixed = TRUE), , drop = FALSE]
    if (!nrow(hit)) {
      warning("No file matching variable '", v, "' in the dataset; skipped.")
      next
    }
    if (nrow(hit) > 1)
      message("Several files match '", v, "'; taking the first: ",
              hit$filename[1])
    fid <- hit$id[1]; fname <- hit$filename[1]
    dest <- file.path(dest_dir, fname)
    if (file.exists(dest) && !overwrite) {
      message("Already present, skipping: ", fname)
    } else {
      durl <- paste0(server, "/api/access/datafile/", fid, "?format=original")
      utils::download.file(durl, destfile = dest, mode = "wb", quiet = quiet)
    }
    paths[v] <- dest
  }
  if (!length(paths)) stop("Nothing downloaded.")
  paths
}

#' Read SAFRAN NetCDF files at grid points into per-point meteo
#'
#' Extracts daily time series from the downloaded per-variable NetCDF files at a
#' set of points and assembles them into the meteo format expected by
#' \code{\link{biljou_run}} / \code{\link{biljou_run_grid}} (one data frame per
#' point, with \code{date}, \code{doy}, \code{rain}, \code{pet}). Uses
#' \pkg{terra}, which reads the time axis and reprojects points to the raster
#' CRS automatically.
#'
#' Note: the SAFRAN NetCDF grid geometry/variable names can vary between
#' products. Inspect a file first with \code{terra::rast(path)} and adjust
#' \code{var_names} / \code{cols} accordingly. This reader could not be tested
#' against the live files; treat its output as provisional and check it.
#'
#' @param files Named character vector of NetCDF paths, names = variable codes
#'   (the output of \code{\link{safran_download}}).
#' @param points Data frame of points with id and lon/lat columns.
#' @param id_col,lon_col,lat_col Column names in \code{points}.
#' @param pts_crs CRS of the point coordinates (default EPSG:4326).
#' @param cols Mapping passed to \code{\link{safran_to_meteo}} to build
#'   \code{rain}/\code{pet} from the extracted variables.
#' @return A named list of meteo data frames, keyed by point id.
#' @export
safran_nc_to_meteo <- function(files, points,
                               id_col = "id", lon_col = "lon", lat_col = "lat",
                               pts_crs = "EPSG:4326",
                               cols = list(date = "date", rain_liq = "PRELIQ_Q",
                                           rain_sol = "PRENEI_Q", pet = "ETP_Q")) {
  if (!requireNamespace("terra", quietly = TRUE))
    stop("Package 'terra' is required. install.packages('terra').", call. = FALSE)
  if (is.null(names(files))) stop("`files` must be named by variable code.")

  vpts <- terra::vect(as.data.frame(points), geom = c(lon_col, lat_col),
                      crs = pts_crs)
  ids <- as.character(points[[id_col]])

  per_var <- list()
  dates <- NULL
  for (v in names(files)) {
    r <- terra::rast(files[[v]])
    tt <- terra::time(r)
    if (is.null(dates)) dates <- as.Date(tt)
    vp <- terra::project(vpts, terra::crs(r))
    ex <- terra::extract(r, vp, ID = FALSE)        # rows = points, cols = times
    per_var[[v]] <- ex
  }

  out <- lapply(seq_along(ids), function(i) {
    wide <- data.frame(date = dates)
    for (v in names(per_var)) wide[[v]] <- as.numeric(per_var[[v]][i, ])
    m <- safran_to_meteo(wide, cols = cols)
    m
  })
  names(out) <- ids
  out
}
