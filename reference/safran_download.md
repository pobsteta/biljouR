# Download SAFRAN NetCDF variable files

Resolves and downloads the per-variable NetCDF files matching the
requested SIM variable codes, via the Dataverse access API.

## Usage

``` r
safran_download(variables = c("PRELIQ_Q","PRENEI_Q","ETP_Q"),
  dest_dir = "safran", doi = "doi:10.57745/BAZ12C",
  server = "https://entrepot.recherche.data.gouv.fr",
  files = NULL, overwrite = FALSE, quiet = FALSE)
```

## Arguments

- variables:

  SIM variable codes to fetch (default the three BILJOU inputs).

- dest_dir:

  Destination directory (created if needed).

- doi, server:

  See
  [`safran_dataverse_files`](https://pobsteta.github.io/biljouR/reference/safran_dataverse_files.md).

- files:

  Optional pre-fetched file list to avoid a second API call.

- overwrite:

  Re-download existing files (default FALSE).

- quiet:

  Suppress download progress.

## Value

A named character vector of local file paths (names = variables).
