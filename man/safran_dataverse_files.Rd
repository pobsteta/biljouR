\name{safran_dataverse_files}
\alias{safran_dataverse_files}
\alias{safran-download}
\title{List the files of the SAFRAN NetCDF dataset}
\usage{safran_dataverse_files(doi = "doi:10.57745/BAZ12C",
  server = "https://entrepot.recherche.data.gouv.fr")}
\arguments{
\item{doi}{Dataverse persistent id (default the SIM quotidienne mirror).}
\item{server}{Dataverse server base URL.}
}
\value{A data frame with \code{id}, \code{filename}, \code{contentType}, \code{size_mb}.}
\description{Queries the Dataverse API to list the per-variable NetCDF files of
the SAFRAN SIM quotidienne mirror (INRAE, DOI 10.57745/BAZ12C). Requires a
network connection and \pkg{jsonlite}. Reuse mention: "Source : Meteo-France".}
