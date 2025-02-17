test_that("Normal function",{
  calibration_data <- data.frame("pio_od" = c(0.1, 1.2),
                                 "manual_od" = c(0.05, 1.0))
  
  calibration_model <- list("P01" = list("calibration_model" = lm(formula = manual_od ~ pio_od, 
                                                                  data = calibration_data)))
  
  raw_data <- data.frame("hours" = c(1:20),
                         "P01" = seq(0.01, 1.2, length.out = 20),
                         "P01.raw_hours" = c(1:20))
  
  expect_snapshot(predict_calibrated_ods(calibration_model, raw_data))
  }
)