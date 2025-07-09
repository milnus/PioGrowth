test_that("read correct dosing event + long od_readings file", {
  input_od_file <- "Data/read_dosing_automation_events_data/Long_Pio-Experiment-od_readings.csv"
  
  input_automated_dosing_events_file <- "Data/read_dosing_automation_events_data/Pio-Experiment-dosing_automation_events.csv"
  
  expected <- data.table::data.table(
    "pioreactor_unit" = c("P06", "P06", "P06", "P07", 
                          "P10", "P06", "P06", "P10", 
                          "P08", "P07", "P06", "P08", 
                          "P06", "P10", "P06"),
    "hours" = as.difftime(c(15.516, 17.966, 21.929, 
                            25.366, 25.375, 25.741, 
                            29.870, 31.475, 31.774, 
                            33.212, 34.354, 37.416, 
                            39.616, 40.675, 45.554), 
                          units = "hours"))
  
  
  ## Test
  expect_equal(object = read_dosing_automation_events_data(
    od_readings_csv = input_od_file, 
    dosing_automation_events_csv = input_automated_dosing_events_file), 
    expected = expected)
})

test_that("read correct dosing event + short od_readings file", {
  input_od_file <- "Data/read_dosing_automation_events_data/Short_Pio-Experiment-od_readings.csv"
  
  input_automated_dosing_events_file <- "Data/read_dosing_automation_events_data/Pio-Experiment-dosing_automation_events.csv"
  
  expected <- data.table::data.table(
    "pioreactor_unit" = c("P06", "P06", "P06", "P07", 
                          "P10", "P06", "P06", "P10", 
                          "P08", "P07", "P06", "P08", 
                          "P06", "P10", "P06"),
    "hours" = as.difftime(c(15.516, 17.966, 21.929, 
                            25.366, 25.375, 25.741, 
                            29.870, 31.475, 31.774, 
                            33.212, 34.354, 37.416, 
                            39.616, 40.675, 45.554), 
                          units = "hours"))
  
  
  ## Test
  expect_equal(object = read_dosing_automation_events_data(
    od_readings_csv = input_od_file, 
    dosing_automation_events_csv = input_automated_dosing_events_file), 
    expected = expected)
})

test_that("Read empty dosing event", {
  input_od_file <- "Data/read_dosing_automation_events_data/Empty_Pio-Experiment-od_readings.csv"
  
  input_automated_dosing_events_file <- "Data/read_dosing_automation_events_data/Empty_Pio-Experiment-od_readings.csv"
  
  expect_null(read_dosing_automation_events_data(od_readings_csv = input_od_file, 
                                     dosing_automation_events_csv = input_automated_dosing_events_file))
})

test_that("No DilutionEvents in file", {
  input_od_file <- "Data/read_dosing_automation_events_data/No_DilutionEvent_Pio-Experiment-dosing_automation_events.csv"
  
  input_automated_dosing_events_file <- "Data/read_dosing_automation_events_data/Long_Pio-Experiment-od_readings.csv"
  
  expect_null(read_dosing_automation_events_data(od_readings_csv = input_od_file, 
                                                 dosing_automation_events_csv = input_automated_dosing_events_file))
})