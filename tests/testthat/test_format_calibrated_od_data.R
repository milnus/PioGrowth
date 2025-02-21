test_that("formatting calibrated multiple reactors", {
  OD_values <- seq(0.01, 1.2, length.out = 5)
  input_raw_pio_od <- list("raw_data" = list(
    "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                           "od_reading.P01" = OD_values,
                                           "od_reading.P02" = OD_values),
    "raw_time" = data.frame()),
    "filtered_data" = list(
      "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                             "od_reading.P01" = OD_values,
                                             "od_reading.P02" = OD_values),
      "raw_time" = data.frame()
      ),
    "filtering_state" = list("reactors_selected" = c(),
                             "filtering_strategy" = "Remove")
  )
  
  calibrated_data <- list("P01" = data.frame('hours' = c(1:5),
                                             'Calibrated_OD' = seq(0.05, 1.0, length.out = 5),
                                             'raw_time' = 0:4),
                          "P02" = data.frame('hours' = c(1:5),
                                             'Calibrated_OD' = seq(1.05, 2.0, length.out = 5),
                                             'raw_time' = 0:4))
  
  expected <- list("raw_data" = list(
    "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                           "od_reading.P01" = OD_values,
                                           "od_reading.P02" = OD_values),
    "raw_time" = data.frame()),
    "filtered_data" = list(
      "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                             "od_reading.P01" = OD_values,
                                             "od_reading.P02" = OD_values),
      "raw_time" = data.frame()
    ),
    "filtering_state" = list("reactors_selected" = c(),
                             "filtering_strategy" = "Remove"),
    "calibrated_data" = data.frame("hours" = c(1:5),
                                   "od_reading.P01" = seq(0.05, 1.0, length.out = 5),
                                   "od_reading.P02" = seq(1.05, 2.0, length.out = 5))
  )
  
  expect_equal(format_calibrated_od_data(input_raw_pio_od, calibrated_data), expected)
})

test_that("formatting calibrated single reactor", {
  OD_values <- seq(0.01, 1.2, length.out = 5)
  input_raw_pio_od <- list("raw_data" = list(
    "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                           "od_reading.P01" = OD_values,
                                           "od_reading.P02" = OD_values),
    "raw_time" = data.frame()),
    "filtered_data" = list(
      "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                             "od_reading.P01" = OD_values),
      "raw_time" = data.frame()
    ),
    "filtering_state" = list("reactors_selected" = c("P02"),
                             "filtering_strategy" = "Remove")
  )
  
  calibrated_data <- list("P01" = data.frame('hours' = c(1:5),
                                             'Calibrated_OD' = seq(0.05, 1.0, length.out = 5),
                                             'raw_time' = 0:4))
  
  expected <- list("raw_data" = list(
    "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                           "od_reading.P01" = OD_values,
                                           "od_reading.P02" = OD_values),
    "raw_time" = data.frame()),
    "filtered_data" = list(
      "pioreactor_OD_data_wide" = data.frame("hours" = c(1:5),
                                             "od_reading.P01" = OD_values),
      "raw_time" = data.frame()
    ),
    "filtering_state" = list("reactors_selected" = c("P02"),
                             "filtering_strategy" = "Remove"),
    "calibrated_data" = data.frame("hours" = c(1:5),
                                   "od_reading.P01" = seq(0.05, 1.0, length.out = 5))
  )
  
  
  
  expect_equal(format_calibrated_od_data(input_raw_pio_od, calibrated_data), expected)
})