# test_that("multiplication works", { # Test_that() initiation with "multiplication works" description
#   expect_equal(2 * 2, 4) # Expectation
# })

test_that("Read od_readings.csv file", {
  expect_snapshot(
  raw_pio_od_data_to_wide_frame(
    test_path("Data", 
              "raw_pio_od_data_to_wide_frame", 
              "Two_reactor_test_read.csv")
    )
  )
  })


# test_that("NULL input blank return", {
#   #### Missing Reactor unit column ####
#   expect_error(raw_pio_od_data_to_wide_frame(
#     test_path("Data",
#               "raw_pio_od_data_to_wide_frame",
#               "Invalid_format_missing_unit.csv")
#   )
#   )


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