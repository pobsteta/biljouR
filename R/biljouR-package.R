#' biljouR: a daily forest water balance model
#'
#' An independent R re-implementation of the BILJOU lumped daily forest water
#' balance model (Granier, Breda, Biron & Villette, 1999, Ecological Modelling
#' 116:269-283), as documented by INRAE UMR Silva at
#' \url{https://appgeodb.nancy.inrae.fr/biljou/}.
#'
#' @section Main functions:
#' \describe{
#'   \item{\code{\link{biljou_soil}}}{Define a 1-3 layer soil profile.}
#'   \item{\code{\link{biljou_run}}}{Run the daily water balance.}
#'   \item{\code{\link{biljou_indices}}}{Drought indices per year.}
#'   \item{\code{\link{biljou_annual_balance}}}{Annual flux totals.}
#'   \item{\code{\link{penman_pet}}}{Penman potential evapotranspiration.}
#' }
#'
#' @section Disclaimer:
#' This package is an independent re-implementation for research and teaching.
#' It is not produced or endorsed by INRAE. Several constants that are only
#' described qualitatively in the public documentation (the macro-/micro-porosity
#' split, the root-uptake weighting, the understorey-evaporation coefficient and
#' the interception regression behaviour at high rainfall) are implemented here
#' with documented, transparent choices; they should be validated against the
#' official BILJOU tool before use in production.
#'
#' @docType package
#' @name biljouR
NULL

#' Synthetic daily meteorology (one temperate year)
#'
#' A one-year synthetic daily meteorological series with a dry summer, used in
#' the examples. Not real measurements.
#'
#' @format A data frame with 365 rows and 4 columns:
#' \describe{
#'   \item{date}{Date.}
#'   \item{doy}{Day of year (1-365).}
#'   \item{pet}{Potential evapotranspiration (mm day-1).}
#'   \item{rain}{Rainfall (mm day-1).}
#' }
"meteo_hesse"
