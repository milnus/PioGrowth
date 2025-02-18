#### Function to use calibration models to predict calibrated od values ####
predict_calibrated_ods <- function(calibration_models, read_data) {
  reactor_names <- names(calibration_models)

  raw_data <- read_data[["pioreactor_OD_data_wide"]]

  calibrated_od_list <- list()

  print(paste("reactor_names:", reactor_names))
  for (name in reactor_names){
	reactor_col_oi <- grep(name, names(raw_data))
    raw_data_isolate <- raw_data[, c(1, reactor_col_oi)]

    colnames(raw_data_isolate)[2] <- 'pio_od'
    model <- calibration_models[[name]]$calibration_model

    calibrated_od_list[[name]] <- data.frame("hours" = raw_data_isolate[, 1],
                                             "Calibrated_OD" = predict(model, raw_data_isolate),
											 "raw_time" = read_data[["raw_time"]][, reactor_col_oi-1])
  }

  return(calibrated_od_list)
}