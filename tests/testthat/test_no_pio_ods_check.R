test_that("1 x_measurements", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                        "pio_od" = NA,
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 1
  
  fist_last_od <- c(0.01, 1.2)
  expected <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
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
  
  rownames(expected$first_last_x_df) <- c("P01.1", "P01.2", "P02.1", "P02.2")
  
  expect_equal(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements), 
               expected)
})

test_that("All Pio ODs given", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                        "pio_od" = 1.00,
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 1
  
  fist_last_od <- c(0.01, 1.2)
  expected <- list("calibration_table" = input_calibration_table,
                   "first_last_x_df" = do.call("rbind.data.frame", list())
                   )
  
  expect_equal(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements), 
               expected)
})

test_that("Some Pio ODs given", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                        "pio_od" = c(0.05, 1.20, NA, NA),
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 1
  
  fist_last_od <- c(0.01, 1.2)
  expected <- list("calibration_table" = input_calibration_table,
                   "first_last_x_df" = do.call("rbind.data.frame", list())
  )
  
  expect_equal(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements), 
               expected)
})

test_that("Reactor ODs not found for given Pio name", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P03"), each = 2),
                                        "pio_od" = NA,
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 1
  
  fist_last_od <- c(0.01, 1.2)
  expected <- list("calibration_table" = input_calibration_table,
                   "first_last_x_df" = do.call("rbind.data.frame", list())
  )
  
  expect_error(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements),
               class = "Input_error")
})

test_that("2 x_measurements", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                        "pio_od" = NA,
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 2
  
  fist_last_od <- c(0.01, 0.14, 1.14, 1.2)
  fist_last_od_mean <- c(mean(fist_last_od[1:2]), mean(fist_last_od[3:4]))
  first_last_column <- rep(c("First", "Last"), each = 2)
  expected <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                    "pio_od" = rep(fist_last_od_mean, 2),
                                                    "manual_od" = rep(c(0.05, 1.00), 2)),
                   "first_last_x_df" = do.call("rbind.data.frame", list(
                     "P01" = data.frame("position" = first_last_column,
                                        "od_reading" = fist_last_od,
                                        "name" = "P01"),
                     "P02" = data.frame("position" = first_last_column,
                                        "od_reading" = fist_last_od,
                                        "name" = "P02")
                     ))
                   )
  
  expect_equal(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements), 
               expected)
})

test_that("5 x_measurements - innerquantile mean calculation", {
  # Construct OD values with missing measurements in time
  OD_values <- round(seq(0.01, 1.2, length.out = 20), 2)
  OD_values[seq(2, 18, 2)] <- NA
  input_raw_pio_od <- list("pioreactor_OD_data_wide" = data.frame("hours" = c(1:20),
                                                                  "od_reading.P01" = OD_values,
                                                                  "od_reading.P02" = OD_values),
                           "raw_time" = data.frame())
  
  input_calibration_table <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                        "pio_od" = NA,
                                        "manual_od" = rep(c(0.05, 1.00), 2))
  input_x_measurements <- 5
  
  first_ods <- c(0.01, 0.14, 0.26, 0.39, 0.51)
  last_ods <- c(0.76, 0.89, 1.01, 1.14, 1.20)
  first_od_value <- mean(first_ods[first_ods >= quantile(first_ods, 0.25) & 
                                    first_ods <= quantile(first_ods, 0.75)])
  last_od_value <- mean(last_ods[last_ods >= quantile(last_ods, 0.25) &
                                   last_ods <= quantile(last_ods, 0.75)])
  fist_last_od_mean <- c(first_od_value, last_od_value)
  first_last_column <- rep(c("First", "Last"), each = 5)
  expected <- list("calibration_table" = data.frame("name" = rep(c("P01", "P02"), each = 2),
                                                    "pio_od" = rep(fist_last_od_mean, 1),
                                                    "manual_od" = rep(c(0.05, 1.00), 1)),
                   "first_last_x_df" = do.call("rbind.data.frame", list(
                     "P01" = data.frame("position" = first_last_column,
                                        "od_reading" = c(first_ods, last_ods),
                                        "name" = "P01"),
                     "P02" = data.frame("position" = first_last_column,
                                        "od_reading" = c(first_ods, last_ods),
                                        "name" = "P02")
                   ))
  )
  
  expect_equal(no_pio_ods_check(calibration_table = input_calibration_table, 
                                read_data = input_raw_pio_od, 
                                x_measurements_oi = input_x_measurements), 
               expected)
})