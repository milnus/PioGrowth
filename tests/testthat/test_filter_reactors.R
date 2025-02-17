test_that("Keep reactor", {
  input_df <- list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                          "P01" = 50:55,
                                                          "P02" = 100:105),
                   "raw_time" = data.frame("hours" = 0:5,
                                           "P01" = 1:6,
                                           "P02" = 7:12))
  
  expected_df <- list("pioreactor_OD_data_wide" = data.frame(hours = 0:5, "P01" = 50:55),
                      "raw_time" = data.frame("hours" = 0:5, "P01" = 1:6))
  
  expect_equal(
    filter_reactors(input_df, pios_of_interest = c("P01"), filt_strat = "Keep"),
    expected_df
  )
})

test_that("Remove reactor", {
  input_df <- list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                          "P01" = 50:55,
                                                          "P02" = 100:105),
                   "raw_time" = data.frame("hours" = 0:5,
                                           "P01" = 1:6,
                                           "P02" = 7:12))
  
  expected_df <- list("pioreactor_OD_data_wide" = data.frame(hours = 0:5, "P01" = 50:55),
                      "raw_time" = data.frame("hours" = 0:5, "P01" = 1:6))
  
  expect_equal(
    filter_reactors(input_df, pios_of_interest = c("P02"), filt_strat = "Remove"),
    expected_df
  )
})

test_that("Keep/Remove all/no reactors", {
  input_df <- list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                          "P01" = 50:55,
                                                          "P02" = 100:105),
                   "raw_time" = data.frame("hours" = 0:5,
                                           "P01" = 1:6,
                                           "P02" = 7:12))
  
  expected_df <- input_df
  
  expect_equal(
    filter_reactors(input_df, pios_of_interest = c(), filt_strat = "Keep"),
    expected_df
  )
  
  expect_equal(
    filter_reactors(input_df, pios_of_interest = c(), filt_strat = "Remove"),
    expected_df
  )
})

test_that("Remove all reactors", {
  input_df <- list("pioreactor_OD_data_wide" = data.frame("hours" = 0:5,
                                                          "P01" = 50:55,
                                                          "P02" = 100:105),
                   "raw_time" = data.frame("hours" = 0:5,
                                           "P01" = 1:6,
                                           "P02" = 7:12))
  
  expected_df <- NULL
  
  expect_equal(
    filter_reactors(input_df, pios_of_interest = c("P01", "P02"), filt_strat = "Remove"),
    expected_df
  )
})