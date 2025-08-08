filter_manual_ods <- function(manual_od_readings, od_data_list) {
  # Check if no reactors are selected for filtering
  if (length(od_data_list[["filtering_state"]][["reactors_selected"]]) == 0) {
    return(manual_od_readings)
  }
  # Identify the rows of reactors of interest
  regex_str <- paste0(
    od_data_list[["filtering_state"]][["reactors_selected"]],
    collapse = "|"
  )
  rows_oi <- grep(regex_str, manual_od_readings$name, ignore.case = TRUE)

  if (od_data_list[["filtering_state"]][["filtering_strategy"]] == "Keep") {
    manual_od_readings_filtered <- manual_od_readings[rows_oi, ]
  } else {
    manual_od_readings_filtered <- manual_od_readings[-rows_oi, ]
  }

  if (nrow(manual_od_readings_filtered) == 0) {
    message("[filter_reactors()] - All manual readings filtered out")
    return()
  } else {
    return(manual_od_readings_filtered)
  }
}
