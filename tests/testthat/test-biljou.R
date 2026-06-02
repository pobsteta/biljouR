test_that("water balance closes", {
  data(meteo_hesse)
  soil <- biljou_soil(ewm = c(70, 70, 40), roots = c(0.6, 0.3, 0.1))
  run <- biljou_run(meteo_hesse, soil, lai_max = 6,
                    forest_type = "broadleaved", budburst = 110, leaf_fall = 300)
  d <- run$daily
  P  <- sum(d$rain)
  ET <- sum(d$et)
  Dr <- sum(d$drainage)
  dW <- tail(d$soil_water, 1) - soil$ewm_total * soil$init
  expect_equal(P - ET - Dr - dW, 0, tolerance = 1e-6)
})

test_that("transpiration ratio follows Eq. 2", {
  expect_equal(transpiration_ratio(4), 0.5)      # 0.125 * 4
  expect_equal(transpiration_ratio(6), 0.75)
  expect_equal(transpiration_ratio(8), 0.75)     # saturated
})

test_that("deciduous LAI is zero outside the leafed period", {
  lai <- biljou_lai(c(50, 110, 200, 320), lai_max = 6,
                    forest_type = "broadleaved", budburst = 110, leaf_fall = 300)
  expect_equal(lai[1], 0)     # before budburst
  expect_equal(lai[3], 6)     # plateau
  expect_equal(lai[4], 0)     # after leaf fall
})

test_that("evergreen LAI is constant", {
  lai <- biljou_lai(1:365, lai_max = 8, forest_type = "coniferous")
  expect_true(all(lai == 8))
})

test_that("small rain events are fully intercepted", {
  expect_equal(rainfall_interception(0.5, lai = 6, "broadleaved"), 0.5)
  expect_equal(rainfall_interception(1.5, lai = 6, "coniferous"), 1.5)
})

test_that("REW never leaves [0, 1]", {
  data(meteo_hesse)
  soil <- biljou_soil(ewm = 120)
  run <- biljou_run(meteo_hesse, soil, lai_max = 5, forest_type = "coniferous")
  expect_true(all(run$daily$rew >= -1e-9 & run$daily$rew <= 1 + 1e-9))
})

test_that("Penman PET is positive and seasonal", {
  summer <- penman_pet(20, 25, 2, rh = 60, doy = 180, latitude = 48.6, altitude = 250)
  winter <- penman_pet(3, 4, 2, rh = 85, doy = 15, latitude = 48.6, altitude = 250)
  expect_gt(summer, winter)
  expect_gt(winter, 0)
})
