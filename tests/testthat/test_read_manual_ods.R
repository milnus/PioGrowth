test_that("Read manual_od_readings.csv file", {
  expected <- data.frame("name" = rep(c("P13", "P14", "P15", "P16", "P17", "P20"), each = 2),
                         "pio_od" = 0.01,
                         "manual_od" = rep(c(0.05, 1.00), 6))
  expect_equal(
    read_manual_ods(
      test_path("Data", "read_manual_ods", "test_manual_od_file.csv")), 
    expected
  )
})

test_that("NULL input blank return", {
  #### Missing Reactor unit column ####
  expect_equal(read_manual_ods(NULL), NULL)
})

test_that("Read file with 'reactor' column instead od name - test back compatability", {
  expected <- data.frame("name" = rep(c("P13", "P14", "P15", "P16", "P17", "P20"), each = 2),
                         "pio_od" = 0.01,
                         "manual_od" = rep(c(0.05, 1.00), 6))
  expect_equal(
    read_manual_ods(
      test_path("Data", "read_manual_ods", "back_compatability_using_reactor_column.csv")), 
    expected
  )
})

test_that("Read file missing name column", {
  expect_error(
    read_manual_ods(test_path("Data", "read_manual_ods", "missing_name.csv")), 
    class = "Input_error"
    )
})


test_that("Read file missing manual od column", {
  expect_error(
    read_manual_ods(test_path("Data", "read_manual_ods", "missing_manual.csv")),
    class = "Input_error"
    )
})

test_that("Read file missing pio od column", {
  expected <- data.frame("name" = rep(c("P13", "P14", "P15", "P16", "P17", "P20"), each = 2),
                         "pio_od" = NA,
                         "manual_od" = rep(c(0.05, 1.00), 6))
  expect_equal(
    read_manual_ods(
      test_path("Data", "read_manual_ods", "missing_pio.csv")), 
    expected
  )
})

test_that("Indifference to order of columns", {
  expected <- data.frame("name" = rep(c("P13", "P14", "P15", "P16", "P17", "P20"), each = 2),
                         "pio_od" = 0.01,
                         "manual_od" = rep(c(0.05, 1.00), 6))
  expect_equal(
    read_manual_ods(
      test_path("Data", "read_manual_ods", "indifference_in_column_order.csv")), 
    expected
  )
})

test_that("Indifference to additional unrelated of columns", {
  expected <- data.frame("name" = rep(c("P13", "P14", "P15", "P16", "P17", "P20"), each = 2),
                         "pio_od" = 0.01,
                         "manual_od" = rep(c(0.05, 1.00), 6))
  expect_equal(
    read_manual_ods(
      test_path("Data", "read_manual_ods", "unrelated_column_test.csv")), 
    expected
  )
})

test_that("appearance of more than one manual od column", {
  expect_error(
    read_manual_ods(test_path("Data", "read_manual_ods", "additional_manual_column.csv")), 
    class = "Input_error"
  )
})

test_that("appearance of more than one name column", {
  expect_error(
    read_manual_ods(test_path("Data", "read_manual_ods", "additional_name_column.csv")), 
    class = "Input_error"
  )
})