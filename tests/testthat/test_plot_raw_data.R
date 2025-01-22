library(ggplot2)
test_that("Plot raw data grid simple",{
  input_df <- data.frame("hours" = 0:5, 
                         "od_reading.P02" = 50:55,
                         "od_reading.P03" = 55:60)
  
  vdiffr::expect_doppelganger("plot_grid_simple_example", 
                              plot_raw_data(raw_data = input_df, 
                                            filter_vector = c(), 
                                            filt_strat = "Keep"))
})

test_that("Plot raw data single plot",{
  input_df <- data.frame("hours" = 0:5, 
                         "od_reading.P03" = 55:60)
  
  vdiffr::expect_doppelganger("plot_single_simple_example", 
                              plot_raw_data(raw_data = input_df, 
                                            filter_vector = c(), 
                                            filt_strat = "Keep"))
})

test_that("Plot raw data grid keep",{
  input_df <- data.frame("hours" = 0:5, 
                         "od_reading.P02" = 50:55,
                         "od_reading.P03" = 55:60)
  
  vdiffr::expect_doppelganger("plot_grid_keep_example", 
                              plot_raw_data(raw_data = input_df, 
                                            filter_vector = c("P03"), 
                                            filt_strat = "Keep"))
})
test_that("Plot raw data grid remove",{
  input_df <- data.frame("hours" = 0:5, 
                         "od_reading.P02" = 50:55,
                         "od_reading.P03" = 55:60)
  
  vdiffr::expect_doppelganger("plot_grid_remove_example", 
                              plot_raw_data(raw_data = input_df, 
                                            filter_vector = c("P03"), 
                                            filt_strat = "Remove"))
})