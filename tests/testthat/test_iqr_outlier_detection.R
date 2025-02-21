test_that("iqr outlier detection - multi reactor", {
  n <- 60
  OD_values <- rep(1, n)
  OD_values[30] <- 10
  input_od_data <- data.frame("hours" = c(1:n),
                                   "od_reading.P01" = OD_values,
                                   "od_reading.P02" = OD_values)
  
  expected <- data.frame("hours" = c(1:n),
                            "od_reading.P01" = OD_values!=1,
                            "od_reading.P02" = OD_values!=1)
  
  expect_equal(iqr_outlier_detection(input_od_data),
               expected)
})

test_that("iqr outlier detection - single reactor", {
  n <- 60
  OD_values <- rep(1, n)
  OD_values[30] <- 10
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values)
  
  expected <- data.frame("hours" = c(1:n),
                                      "od_reading.P01" = OD_values!=1)
  
  expect_equal(iqr_outlier_detection(input_od_data),
               expected)
})