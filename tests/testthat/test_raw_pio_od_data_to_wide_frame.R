test_that("Read od_readings.csv file", {
  expect_snapshot(
  raw_pio_od_data_to_wide_frame(
    test_path("Data", 
              "raw_pio_od_data_to_wide_frame", 
              "Two_reactor_test_read.csv")
    )
  )
})


test_that("NULL input blank return", {
  #### Missing Reactor unit column ####
  expect_equal(raw_pio_od_data_to_wide_frame(NULL), NULL)
})


test_that("Read invalidly formatted file", {
  #### Missing Reactor unit column ####
  expect_error(raw_pio_od_data_to_wide_frame(
    test_path("Data",
              "raw_pio_od_data_to_wide_frame",
              "Invalid_format_missing_unit.csv")
    )
  )
  
  #### Missing time stamp column ####
  expect_error(raw_pio_od_data_to_wide_frame(
    test_path("Data",
              "raw_pio_od_data_to_wide_frame",
              "Invalid_format_missing_timestamp.csv")
  )
  )
})