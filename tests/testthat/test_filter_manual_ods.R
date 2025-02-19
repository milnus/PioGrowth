test_that("Filtering of manual ods - Remove", {
  input_manual_od_readings <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                         "pio_od" = rep(c(0.01, 1.20), 2),
                                         "manual_od" = rep(c(0.05, 1.00), 2))
  
  input_od_data_list <- list("raw_data" = list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                                                      "P01" = 50:55,
                                                                                      "P02" = 100:105),
                                               "raw_time" = data.frame("hours" = 0:5,
                                                                       "P01" = 1:6,
                                                                       "P02" = 7:12)),
                             "filtered_data" = list("pioreactor_OD_data_wide" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 50:55),
                                                    "raw_time" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 1:6)),
                             "filtering_state" = list("reactors_selected" = c("P02"),
                                                      "filtering_strategy" = "Remove"))
  
  expected <- data.frame("name" = rep(c("P01"), each = 2),
                         "pio_od" = c(0.01, 1.20),
                         "manual_od" = c(0.05, 1.00))
  
  expect_equal(filter_manual_ods(manual_od_readings = input_manual_od_readings, 
                                 od_data_list = input_od_data_list),
               expected)
})

test_that("Filtering of manual ods - Keep", {
  input_manual_od_readings <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                         "pio_od" = rep(c(0.01, 1.20), 2),
                                         "manual_od" = rep(c(0.05, 1.00), 2))
  
  input_od_data_list <- list("raw_data" = list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                                                      "P01" = 50:55,
                                                                                      "P02" = 100:105),
                                               "raw_time" = data.frame("hours" = 0:5,
                                                                       "P01" = 1:6,
                                                                       "P02" = 7:12)),
                             "filtered_data" = list("pioreactor_OD_data_wide" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 50:55),
                                                    "raw_time" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 1:6)),
                             "filtering_state" = list("reactors_selected" = c("P01"),
                                                      "filtering_strategy" = "Keep"))
  
  expected <- data.frame("name" = rep(c("P01"), each = 2),
                         "pio_od" = c(0.01, 1.20),
                         "manual_od" = c(0.05, 1.00))
  
  expect_equal(filter_manual_ods(manual_od_readings = input_manual_od_readings, 
                                 od_data_list = input_od_data_list),
               expected)
})
  

test_that("no filtering of manual ods - Keep", {
  input_manual_od_readings <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                         "pio_od" = rep(c(0.01, 1.20), 2),
                                         "manual_od" = rep(c(0.05, 1.00), 2))
  
  input_od_data_list <- list("raw_data" = list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                                                      "P01" = 50:55,
                                                                                      "P02" = 100:105),
                                               "raw_time" = data.frame("hours" = 0:5,
                                                                       "P01" = 1:6,
                                                                       "P02" = 7:12)),
                             "filtered_data" = list("pioreactor_OD_data_wide" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 50:55),
                                                    "raw_time" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 1:6)),
                             "filtering_state" = list("reactors_selected" = c(),
                                                      "filtering_strategy" = "Keep"))
  
  expected <- input_manual_od_readings
  
  expect_equal(filter_manual_ods(manual_od_readings = input_manual_od_readings, 
                                 od_data_list = input_od_data_list),
               expected)
})

test_that("no filtering of manual ods - Remove", {
  input_manual_od_readings <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                         "pio_od" = rep(c(0.01, 1.20), 2),
                                         "manual_od" = rep(c(0.05, 1.00), 2))
  
  input_od_data_list <- list("raw_data" = list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                                                      "P01" = 50:55,
                                                                                      "P02" = 100:105),
                                               "raw_time" = data.frame("hours" = 0:5,
                                                                       "P01" = 1:6,
                                                                       "P02" = 7:12)),
                             "filtered_data" = list("pioreactor_OD_data_wide" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 50:55),
                                                    "raw_time" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 1:6)),
                             "filtering_state" = list("reactors_selected" = c(),
                                                      "filtering_strategy" = "Remove"))
  
  expected <- input_manual_od_readings
  
  expect_equal(filter_manual_ods(manual_od_readings = input_manual_od_readings, 
                                 od_data_list = input_od_data_list),
               expected)
})

test_that("Filtering all of the manual ods", {
  input_manual_od_readings <- data.frame("name" = rep(c("P01", "P02"), each = 2),
                                         "pio_od" = rep(c(0.01, 1.20), 2),
                                         "manual_od" = rep(c(0.05, 1.00), 2))
  
  input_od_data_list <- list("raw_data" = list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                                                      "P01" = 50:55,
                                                                                      "P02" = 100:105),
                                               "raw_time" = data.frame("hours" = 0:5,
                                                                       "P01" = 1:6,
                                                                       "P02" = 7:12)),
                             "filtered_data" = list("pioreactor_OD_data_wide" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 50:55),
                                                    "raw_time" = 
                                                      data.frame("hours" = 0:5,
                                                                 "P01" = 1:6)),
                             "filtering_state" = list("reactors_selected" = c("P01", "P02"),
                                                      "filtering_strategy" = "Remove"))
  
  expected <- NULL
  
  expect_equal(filter_manual_ods(manual_od_readings = input_manual_od_readings, 
                                 od_data_list = input_od_data_list),
               expected)
})