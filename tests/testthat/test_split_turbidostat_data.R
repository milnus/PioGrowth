test_that("split multiple reactors", {
  input_od_df <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                            "od_reading.P01" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21),
                            "od_reading.P02" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21))
  
  input_dosing_events <- data.table::data.table("pioreactor_unit" = c("P01", "P02"),
                                                as.difftime(c(3, 4), units = "hours"))
  
  input_outlier_data <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                                   "od_reading.P01" = F,
                                   "od_reading.P02" = F)
  
  ## Expected is
  expected <- list("P01" = list("1" = data.frame("timestamp" = c(1, 2, 3),
                                               "od_reading" = c(0.05, 0.10, 0.20)),
                                "2" = data.frame("timestamp" = c(4, 5, 6),
                                               "od_reading" = c(0.07, 0.12, 0.21))
                                ),
                   "P02" = list("1" = data.frame("timestamp" = c(1, 2, 3, 4),
                                                 "od_reading" = c(0.05, 0.10, 0.20, 0.07)),
                                "2" = data.frame("timestamp" = c(5, 6),
                                                 "od_reading" = c(0.12, 0.21))
                   )
                   )
  
  expect_equal(split_turbidostat_data(od_data = input_od_df, 
                                      dosing_automation_events = input_dosing_events, 
                                      outlier_data = input_outlier_data), 
               expected = expected)
})

test_that("split single reactor", {
  input_od_df <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                            "od_reading.P01" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21))
  
  input_dosing_events <- data.table::data.table("pioreactor_unit" = c("P01"),
                                                as.difftime(c(3), units = "hours"))
  
  input_outlier_data <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                                   "od_reading.P01" = F)
  
  ## Expected is
  expected <- list("P01" = list("1" = data.frame("timestamp" = c(1, 2, 3),
                                                 "od_reading" = c(0.05, 0.10, 0.20)),
                                "2" = data.frame("timestamp" = c(4, 5, 6),
                                                 "od_reading" = c(0.07, 0.12, 0.21))
  )
  )
  
  expect_equal(split_turbidostat_data(od_data = input_od_df, 
                                      dosing_automation_events = input_dosing_events, 
                                      outlier_data = input_outlier_data), 
               expected = expected)
})

test_that("split multiple reactors w. outlier data", {
  input_od_df <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                            "od_reading.P01" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21),
                            "od_reading.P02" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21))
  
  input_dosing_events <- data.table::data.table("pioreactor_unit" = c("P01", "P02"),
                                                as.difftime(c(3, 4), units = "hours"))
  
  input_outlier_data <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                            "od_reading.P01" = c(F, F, T, F, F, F),
                            "od_reading.P02" = c(F, T, F, F, F, F))
  
  ## Expected is
  expected <- list("P01" = list("1" = data.frame("timestamp" = c(1, 2),
                                                 "od_reading" = c(0.05, 0.10)),
                                "2" = data.frame("timestamp" = c(4, 5, 6),
                                                 "od_reading" = c(0.07, 0.12, 0.21))
                                ),
                   "P02" = list("1" = data.frame("timestamp" = c(1, 3, 4),
                                                 "od_reading" = c(0.05, 0.20, 0.07)),
                                "2" = data.frame("timestamp" = c(5, 6),
                                                 "od_reading" = c(0.12, 0.21))
  )
  )
  
  expect_equal(split_turbidostat_data(od_data = input_od_df, 
                                      dosing_automation_events = input_dosing_events, 
                                      outlier_data = input_outlier_data), 
               expected = expected)
})

test_that("split single reactor w. outlier data", {
  input_od_df <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                            "od_reading.P01" = c(0.05, 0.10, 0.20, 0.07, 0.12, 0.21))
  
  input_dosing_events <- data.table::data.table("pioreactor_unit" = c("P01"),
                                                as.difftime(c(3), units = "hours"))
  
  input_outlier_data <- data.frame("hours" = c(1, 2, 3, 4, 5, 6),
                                   "od_reading.P01" = c(F, F, F, F, T, F))
  
  ## Expected is
  expected <- list("P01" = list("1" = data.frame("timestamp" = c(1, 2, 3),
                                                 "od_reading" = c(0.05, 0.10, 0.20)),
                                "2" = data.frame("timestamp" = c(4, 6),
                                                 "od_reading" = c(0.07, 0.21))
                                )
                   )
  
  
  expect_equal(split_turbidostat_data(od_data = input_od_df, 
                                      dosing_automation_events = input_dosing_events, 
                                      outlier_data = input_outlier_data), 
               expected = expected)
})