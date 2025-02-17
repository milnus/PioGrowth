test_that("No fixed_intercept nor zero_point", {
  fist_last_od <- c(0.01, 1.2)
  input <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                    "pio_od" = rep(fist_last_od, 2),
                                                    "manual_od" = rep(c(0.05, 1.00), 2)),
                "first_last_x_df" = do.call("rbind.data.frame", list(
                  "P01" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P01"),
                  "P02" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P02")
                  )))
  
  expect_snapshot(split_od_per_reactor(input, fixed_intercept = F, add_zero_point = F))
})

test_that("Add fixed_intercept", {
  fist_last_od <- c(0.01, 1.2)
  input <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                 "pio_od" = rep(fist_last_od, 2),
                                                 "manual_od" = rep(c(0.05, 1.00), 2)),
                "first_last_x_df" = do.call("rbind.data.frame", list(
                  "P01" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P01"),
                  "P02" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P02")
                )))
  
  expect_snapshot(split_od_per_reactor(input, fixed_intercept = T, add_zero_point = F))
})

test_that("Add zero_point", {
  fist_last_od <- c(0.01, 1.2)
  input <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                 "pio_od" = rep(fist_last_od, 2),
                                                 "manual_od" = rep(c(0.05, 1.00), 2)),
                "first_last_x_df" = do.call("rbind.data.frame", list(
                  "P01" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P01"),
                  "P02" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P02")
                )))
  
  expect_snapshot(split_od_per_reactor(input, fixed_intercept = F, add_zero_point = T))
})

test_that("Both fixed_intercept and zero_point", {
  fist_last_od <- c(0.01, 1.2)
  input <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                 "pio_od" = rep(fist_last_od, 2),
                                                 "manual_od" = rep(c(0.05, 1.00), 2)),
                "first_last_x_df" = do.call("rbind.data.frame", list(
                  "P01" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P01"),
                  "P02" = data.frame("position" = c("First", "Last"),
                                     "od_reading" = fist_last_od,
                                     "name" = "P02")
                )))
  
  expect_snapshot(split_od_per_reactor(input, fixed_intercept = T, add_zero_point = T))
})