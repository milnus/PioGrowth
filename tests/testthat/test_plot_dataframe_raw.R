library(ggplot2)
test_that("Plot simple raw data",{
  input_df <- data.frame("timestamp" = 0:5, 
                         "od_reading" = 50:55)
  
  vdiffr::expect_doppelganger("Simple_raw_data_plot", 
                              plot_dataframe_raw(dataframe = input_df, 
                                                 name = "od_reading.P02", 
                                                 filter_vector = c(), 
                                                 filt_strat = "Keep"))
})

test_that("Plot simple raw data - KEEP",{
  input_df <- data.frame("timestamp" = 0:5, 
                         "od_reading" = 50:55)
  
  vdiffr::expect_doppelganger("Simple_raw_data_plot_keep", 
                              plot_dataframe_raw(dataframe = input_df, 
                                                 name = "od_reading.P02", 
                                                 filter_vector = c("P02"), 
                                                 filt_strat = "Keep"))
})

test_that("Plot simple raw data - REMOVE",{
  input_df <- data.frame("timestamp" = 0:5, 
                         "od_reading" = 50:55)
  
  vdiffr::expect_doppelganger("Simple_raw_data_plot_remove", 
                              plot_dataframe_raw(dataframe = input_df, 
                                                 name = "od_reading.P02", 
                                                 filter_vector = c("P02"), 
                                                 filt_strat = "Remove"))
})

test_that("Plot simple raw data - negative od",{
  input_df <- data.frame("timestamp" = 0:5, 
                         "od_reading" = -1:4)
  
  vdiffr::expect_doppelganger("Simple_raw_data_plot_negative_od", 
                              plot_dataframe_raw(dataframe = input_df, 
                                                 name = "od_reading.P02", 
                                                 filter_vector = c(""), 
                                                 filt_strat = "Keep"))
})