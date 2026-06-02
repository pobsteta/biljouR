# List the files of the SAFRAN NetCDF dataset

Queries the Dataverse API to list the per-variable NetCDF files of the
SAFRAN SIM quotidienne mirror (INRAE, DOI 10.57745/BAZ12C). Requires a
network connection and jsonlite. Reuse mention: "Source : Meteo-France".

## Usage

``` r
safran_dataverse_files(doi = "doi:10.57745/BAZ12C",
  server = "https://entrepot.recherche.data.gouv.fr")
```

## Arguments

- doi:

  Dataverse persistent id (default the SIM quotidienne mirror).

- server:

  Dataverse server base URL.

## Value

A data frame with `id`, `filename`, `contentType`, `size_mb`.
