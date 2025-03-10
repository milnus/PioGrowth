format_calibrated_od_data <- function(raw_data, calibrated_data) {
  ### Copy the raw datafra,e and substitute the calibrated data at approproate time points
  raw_data[["calibrated_data"]] <- raw_data[["filtered_data"]][[
    "pioreactor_OD_data_wide"
  ]]

  # For each calibrated reactor substitute in calibrated OD values
  for (name in names(calibrated_data)) {
    raw_data_col_oi <- grep(name, names(raw_data[["calibrated_data"]]))

    hours_to_substitute <- raw_data[["calibrated_data"]]["hours"] %in%
      calibrated_data[[name]]["hours"]

    raw_data[["calibrated_data"]][
      hours_to_substitute,
      raw_data_col_oi
    ] <- calibrated_data[[name]]["Calibrated_OD"]
  }

  return(raw_data)
}
