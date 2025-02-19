no_pio_ods_check <- function(calibration_table, od_data_list, x_measurements_oi) {
  ##TODO - Make so that this function can be used if only some reactors have calibration measurements from pio and manual
  print("[no_pio_ods_check] - STARTING")

  # Create a return list with first and last ten for later plotting.
  first_last_x_list <- list()

  # Isolate the raw pio od readings
  raw_pio_od <- od_data_list[["filtered_data"]][["pioreactor_OD_data_wide"]]
  message(raw_pio_od)

  # Check if no PioReactor ODs were given
  if (all(is.na(calibration_table[, "pio_od"]))) {
    for (name in unique(calibration_table[, "name"])) {
      print(paste("[no_pio_ods_check]   -   ", name))

      # grep out the column
      od_column_oi <- grep(paste0("od_reading.", name), colnames(raw_pio_od))

      if (length(od_column_oi) == 0) {
        shiny::showNotification(ui = paste("No reactor found in dataset named:", name,
                                           "\nWill skip calibration and processing of this reactor"),
                                duration = NULL, type = "error")
        # stop(errorCondition(message =
        #     paste("No reactor found in dataset named:", name),
        #     class = "Input_error"))
      }

      od_readings_oi <- raw_pio_od[, od_column_oi]

      # Remove NAs
      od_readings_oi <- od_readings_oi[!is.na(od_readings_oi)]

      # Identify first and last X measurements
      first_od_oi <- od_readings_oi[1:x_measurements_oi]
      last_od_oi <- od_readings_oi[(length(od_readings_oi) - x_measurements_oi + 1):length(od_readings_oi)]

      # Save the top and last X measurements in return list
      first_last_x_list[[name]] <- data.frame(
                                                 "position" = rep(c("First", "Last"),
                                                                  each = x_measurements_oi),
                                                 "od_reading" = c(first_od_oi, last_od_oi),
                                                 "name" = name)

      # Calculate the average (median or IQR mean) and insert the manual OD.
      first_od_value <- NA
      last_od_value <- NA

      # Set type of mean used depending on number of samples to use from PrioReactor
      mean_type <- ifelse(x_measurements_oi < 5, "Mean", "Innerquantile mean")

      if (mean_type == "Mean") {
        first_od_value <- mean(first_od_oi)
        last_od_value <- mean(last_od_oi)
      } else {
        if (mean_type == "Innerquantile mean"){
          first_od_value <- mean(first_od_oi[first_od_oi >= quantile(first_od_oi, 0.25) & 
                                               first_od_oi <= quantile(first_od_oi, 0.75)])
          last_od_value <- mean(last_od_oi[last_od_oi >= quantile(last_od_oi, 0.25) &
                                             last_od_oi <= quantile(last_od_oi, 0.75)])
        }
      }
      reading_order <- order(calibration_table[calibration_table[,"name"] == name, "manual_od"])
      calibration_table[calibration_table[,"name"] == name, "pio_od"][reading_order] <- c(first_od_value, last_od_value)
    }
  }

  # Create a dataframe that contains the first and last X measurements for each reactor
  first_last_x_df <- do.call("rbind.data.frame", first_last_x_list)

  return(list("calibration_table" = calibration_table,
              "first_last_x_df" = first_last_x_df))
}