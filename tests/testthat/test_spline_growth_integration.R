test_that("simple spline", {
  n <- 5
  OD_values <- exp(1:n)
  input_od_data_list <- list("raw_data" = list(),
    "filtered_data" = list(),
    "filtering_state" = list(),
    "outliers" = data.frame("hours" = 1:n,
                            "od_reading.P01" = rep(F, n),
                            "od_reading.P02" = rep(F, n)),
    "negative_corrected" = data.frame("hours" = 1:n,
                                      "od_reading.P01" = OD_values,
                                      "od_reading.P02" = OD_values)
  )
  
  expect_snapshot(spline_growth_integration(input_od_data_list))
})

test_that("spline w. NA", {
  n <- 5
  OD_values <- exp(1:n)
  OD_values[1] <- NA
  input_od_data_list <- list("raw_data" = list(),
                             "filtered_data" = list(),
                             "filtering_state" = list(),
                             "outliers" = data.frame("hours" = 1:n,
                                                     "od_reading.P01" = rep(F, n),
                                                     "od_reading.P02" = rep(F, n)),
                             "negative_corrected" = data.frame("hours" = 1:n,
                                                               "od_reading.P01" = OD_values,
                                                               "od_reading.P02" = OD_values)
  )
  
  expect_snapshot(spline_growth_integration(input_od_data_list))
})

test_that("spline w. outlier", {
  n <- 5
  OD_values <- exp(1:n)
  outlier_vector <- c(T, rep(F, n-1))
  input_od_data_list <- list("raw_data" = list(),
                             "filtered_data" = list(),
                             "filtering_state" = list(),
                             "outliers" = data.frame("hours" = 1:n,
                                                     "od_reading.P01" = outlier_vector,
                                                     "od_reading.P02" = outlier_vector),
                             "negative_corrected" = data.frame("hours" = 1:n,
                                                               "od_reading.P01" = OD_values,
                                                               "od_reading.P02" = OD_values)
  )
  
  expect_snapshot(spline_growth_integration(input_od_data_list))
})

test_that("spline w. outlier and NA", {
  n <- 10
  OD_values <- exp(1:n)
  OD_values[3] <- NA
  outlier_vector <- c(T, rep(F, n-1))
  input_od_data_list <- list("raw_data" = list(),
                             "filtered_data" = list(),
                             "filtering_state" = list(),
                             "outliers" = data.frame("hours" = 1:n,
                                                     "od_reading.P01" = outlier_vector,
                                                     "od_reading.P02" = outlier_vector),
                             "negative_corrected" = data.frame("hours" = 1:n,
                                                               "od_reading.P01" = OD_values,
                                                               "od_reading.P02" = OD_values)
  )
  
  expect_snapshot(spline_growth_integration(input_od_data_list))
})