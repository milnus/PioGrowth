test_that("Construct filter retrun list", {
  
  raw_readings <- list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                          "P01" = 50:55,
                                                          "P02" = 100:105),
                   "raw_time" = data.frame("hours" = 0:5,
                                           "P01" = 1:6,
                                           "P02" = 7:12))
  
  filtered_readings <- list("pioreactor_OD_data_wide" = data.frame(hours = 0:5, "P01" = 50:55),
                      "raw_time" = data.frame("hours" = 0:5, "P01" = 1:6))
  
  reactor_selection_input <- c()
  filt_strat_input <- "Keep" # Keep or Remove
  
  expected_list <- list("raw_data" = raw_readings,
                        "filtered_data" = filtered_readings,
                        "filtering_state" = list("reactors_selected" = reactor_selection_input,
                                                 "filtering_strategy" = filt_strat_input))
  
  expect_equal(
    format_filter_return(raw_readings, filtered_readings, reactor_selection_input, filt_strat_input),
    expected_list)
})