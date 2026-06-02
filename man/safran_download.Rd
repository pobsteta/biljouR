\name{safran_download}
\alias{safran_download}
\title{Download SAFRAN NetCDF variable files}
\usage{safran_download(variables = c("PRELIQ_Q","PRENEI_Q","ETP_Q"),
  dest_dir = "safran", doi = "doi:10.57745/BAZ12C",
  server = "https://entrepot.recherche.data.gouv.fr",
  files = NULL, overwrite = FALSE, quiet = FALSE)}
\arguments{
\item{variables}{SIM variable codes to fetch (default the three BILJOU inputs).}
\item{dest_dir}{Destination directory (created if needed).}
\item{doi, server}{See \code{\link{safran_dataverse_files}}.}
\item{files}{Optional pre-fetched file list to avoid a second API call.}
\item{overwrite}{Re-download existing files (default FALSE).}
\item{quiet}{Suppress download progress.}
}
\value{A named character vector of local file paths (names = variables).}
\description{Resolves and downloads the per-variable NetCDF files matching the
requested SIM variable codes, via the Dataverse access API.}
