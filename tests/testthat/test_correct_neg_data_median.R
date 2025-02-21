test_that("Single negative",{
  n <- 60
  OD_values <- 1:n
  OD_values[30] <- -1
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values,
                              "od_reading.P02" = OD_values)
  input_outlier_df <- data.frame("hours" = c(1:n),
                                 "od_reading.P01" = F,
                                 "od_reading.P02" = F)
  
  median_corrected_value <- median(OD_values[c(15:29, 31:45)])
  expected_values <- c(OD_values[1:29], median_corrected_value, OD_values[31:60])
  expected <- data.frame("hours" = c(1:n),
                         "od_reading.P01" = expected_values,
                         "od_reading.P02" = expected_values)
  
  expect_equal(correct_neg_data_median(input_od_data, input_outlier_df),
               expected)
})

test_that("multiple consecutive negative",{
  n <- 60
  OD_values <- 1:n
  OD_values[29:31] <- -1
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values,
                              "od_reading.P02" = OD_values)
  input_outlier_df <- data.frame("hours" = c(1:n),
                                 "od_reading.P01" = F,
                                 "od_reading.P02" = F)
  
  values_29 <- OD_values[c(12:28, 30:46)]
  values_30 <- OD_values[c(13:29, 31:47)]
  values_31 <- OD_values[c(14:30, 32:48)]
  
  median_corrected_value_29 <- median(values_29[values_29>0])
  median_corrected_value_30 <- median(values_30[values_30>0])
  median_corrected_value_31 <- median(values_31[values_31>0])
  expected_values <- c(OD_values[1:28], median_corrected_value_29, 
                       median_corrected_value_30, 
                       median_corrected_value_31, OD_values[32:60])
  expected <- data.frame("hours" = c(1:n),
                         "od_reading.P01" = expected_values,
                         "od_reading.P02" = expected_values)
  
  expect_equal(correct_neg_data_median(input_od_data, input_outlier_df),
               expected)
})

test_that("Single negative, w. NA",{
  n <- 60
  OD_values <- 1:n
  OD_values[30] <- -1
  OD_values[1] <- NA
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values,
                              "od_reading.P02" = OD_values)
  input_outlier_df <- data.frame("hours" = c(1:n),
                                 "od_reading.P01" = F,
                                 "od_reading.P02" = F)
  
  median_corrected_value <- median(OD_values[c(15:29, 31:45)])
  expected_values <- c(OD_values[1:29], median_corrected_value, OD_values[31:60])
  expected_values[1] <- NA
  expected <- data.frame("hours" = c(1:n),
                         "od_reading.P01" = expected_values,
                         "od_reading.P02" = expected_values)
  
  expect_equal(correct_neg_data_median(input_od_data, input_outlier_df),
               expected)
})

test_that("Single negative, w. NA in window",{
  n <- 60
  OD_values <- 1:n
  OD_values[30] <- -1
  OD_values[25] <- NA
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values,
                              "od_reading.P02" = OD_values)
  input_outlier_df <- data.frame("hours" = c(1:n),
                                 "od_reading.P01" = F,
                                 "od_reading.P02" = F)
  
  median_corrected_value <- median(OD_values[c(14:29, 31:46)], na.rm = T)
  expected_values <- c(OD_values[1:29], median_corrected_value, OD_values[31:60])
  expected <- data.frame("hours" = c(1:n),
                         "od_reading.P01" = expected_values,
                         "od_reading.P02" = expected_values)
  
  expect_equal(correct_neg_data_median(input_od_data, input_outlier_df),
               expected)
})

test_that("Single negative, w. outliers",{
  n <- 60
  OD_values <- 1:n
  OD_values[30] <- -1
  OD_values[1] <- NA
  input_od_data <- data.frame("hours" = c(1:n),
                              "od_reading.P01" = OD_values,
                              "od_reading.P02" = OD_values)
  input_outlier_df <- data.frame("hours" = c(1:n),
                                 "od_reading.P01" = F,
                                 "od_reading.P02" = F)
  
  median_corrected_value <- median(OD_values[c(15:29, 31:45)])
  expected_values <- c(OD_values[1:29], median_corrected_value, OD_values[31:60])
  expected <- data.frame("hours" = c(1:n),
                         "od_reading.P01" = expected_values,
                         "od_reading.P02" = expected_values)
  
  expect_equal(correct_neg_data_median(input_od_data, input_outlier_df),
               expected)
})