test_that("biljou_run_grid returns a tidy long table over points/years/indicators", {
  data(meteo_hesse)
  pts <- data.frame(id = c("a", "b", "c"),
                    lon = c(6.0, 6.2, 6.4), lat = c(48.6, 48.6, 48.6))
  meteo_fun <- function(id) {
    f <- c(a = 1.2, b = 0.8, c = 0.5)[id]
    transform(meteo_hesse, rain = rain * f)
  }
  g <- biljou_run_grid(pts, meteo = meteo_fun, soil = biljou_soil(140),
                       lai_max = 5, forest_type = "broadleaved",
                       budburst = 110, leaf_fall = 300,
                       indicators = c("NJstress", "min_rew"), verbose = FALSE)
  expect_s3_class(g, "biljou_grid")
  expect_setequal(names(g), c("id", "lon", "lat", "year", "indicator", "value"))
  expect_setequal(unique(g$id), c("a", "b", "c"))
  expect_setequal(unique(g$indicator), c("NJstress", "min_rew"))
  # 3 points x 1 year x 2 indicators
  expect_equal(nrow(g), 3 * 1 * 2)
})

test_that("drier points have more stress days and lower minimum REW", {
  data(meteo_hesse)
  pts <- data.frame(id = c("wet", "dry"), lon = c(6.0, 6.2), lat = c(48.6, 48.6))
  meteo_fun <- function(id) {
    f <- c(wet = 1.3, dry = 0.4)[id]
    transform(meteo_hesse, rain = rain * f)
  }
  g <- biljou_run_grid(pts, meteo = meteo_fun, soil = biljou_soil(140),
                       lai_max = 5, forest_type = "coniferous",
                       indicators = c("NJstress", "min_rew"), verbose = FALSE)
  nj <- g[g$indicator == "NJstress", ]
  mr <- g[g$indicator == "min_rew", ]
  expect_gt(nj$value[nj$id == "dry"], nj$value[nj$id == "wet"])
  expect_lt(mr$value[mr$id == "dry"], mr$value[mr$id == "wet"])
})

test_that("meteo can be supplied as a single data frame or a named list", {
  data(meteo_hesse)
  pts <- data.frame(id = c("x", "y"), lon = c(1, 2), lat = c(48, 48))
  g1 <- biljou_run_grid(pts, meteo = meteo_hesse, soil = biljou_soil(120),
                        lai_max = 4, forest_type = "coniferous",
                        indicators = "NJstress", verbose = FALSE)
  lst <- list(x = meteo_hesse, y = meteo_hesse)
  g2 <- biljou_run_grid(pts, meteo = lst, soil = biljou_soil(120),
                        lai_max = 4, forest_type = "coniferous",
                        indicators = "NJstress", verbose = FALSE)
  # same meteo for both points -> identical NJstress, and list == single df
  expect_equal(g1$value, g2$value)
  expect_equal(length(unique(g1$value)), 1L)
})

test_that("years filtering keeps only requested years", {
  data(meteo_hesse)
  m2 <- rbind(meteo_hesse, transform(meteo_hesse, date = meteo_hesse$date + 365))
  pts <- data.frame(id = "z", lon = 6, lat = 48)
  g <- biljou_run_grid(pts, meteo = m2, soil = biljou_soil(140),
                       lai_max = 5, forest_type = "coniferous",
                       indicators = "NJstress", years = 2004, verbose = FALSE)
  expect_equal(unique(g$year), 2004)
})

test_that("grid converters need their suggested packages / arguments", {
  data(meteo_hesse)
  pts <- data.frame(id = c("a", "b"), lon = c(6, 6.2), lat = c(48.6, 48.6),
                    stringsAsFactors = FALSE)
  g <- biljou_run_grid(pts, meteo = meteo_hesse, soil = biljou_soil(140),
                       lai_max = 5, forest_type = "coniferous",
                       indicators = c("NJstress", "min_rew"), verbose = FALSE)
  # ambiguous slice (several indicators) should error before touching sf/terra
  expect_error(biljou_grid_to_sf(g), "indicator")

  skip_if_not_installed("sf")
  layer <- biljou_grid_to_sf(g, indicator = "NJstress", year = 2003)
  expect_s3_class(layer, "sf")
  expect_equal(nrow(layer), 2)
})

test_that("safran_to_meteo maps SIM columns to the meteo format", {
  sim <- data.frame(
    DATE = c("20030101", "20030102", "20030103"),
    PRELIQ_Q = c(0, 2.5, 0),
    PRENEI_Q = c(1.0, 0, 0),
    ETP_Q = c(0.3, 0.5, 0.8)
  )
  m <- safran_to_meteo(sim)
  expect_setequal(names(m), c("date", "doy", "rain", "pet"))
  expect_equal(m$rain, c(1.0, 2.5, 0))          # liquid + solid
  expect_equal(m$pet, c(0.3, 0.5, 0.8))         # from ETP_Q
  expect_s3_class(m$date, "Date")
})
