raw_pio_od_data_to_wide_frame <- function(od_readings_csv) {
  # Check if od_readings_csv is null - i.e. not given
  if (is.null(od_readings_csv)) {
    return()
  }

  # Read in OD data
  pioreactor_OD_data <- data.table::fread(od_readings_csv)

  # Convert time to hours
  pioreactor_OD_data$timestamp <- as.POSIXct(pioreactor_OD_data$timestamp)
  pioreactor_OD_data$hours <- difftime(pioreactor_OD_data$timestamp,
    min(pioreactor_OD_data$timestamp),
    units = "hours"
  )

  # Reshape the data into a wide format
  columns_oi <- c("hours", "pioreactor_unit", "od_reading", "timestamp_localtime")
  growth_data_oi <- pioreactor_OD_data[, columns_oi]

  pioreactor_OD_data_wide <- as.data.frame(reshape(
    data = growth_data_oi,
    idvar = "hours",
    timevar = "pioreactor_unit",
    direction = "wide"
  ))

  # Order reactor columns
  reactor_column_names <- colnames(pioreactor_OD_data_wide)[2:ncol(pioreactor_OD_data_wide)]
  column_order <- match(reactor_column_names, sort(reactor_column_names))
  pioreactor_OD_data_wide <- pioreactor_OD_data_wide[, c(1, column_order + 1)]
  pioreactor_OD_data_wide <- pioreactor_OD_data_wide[, sort(colnames(pioreactor_OD_data_wide))]

  # Isolate OD from raw_time columns
  od_max_col <- (ncol(pioreactor_OD_data_wide) - 1) / 2 + 1
  min_raw_time_col <- od_max_col + 1
  max_raw_time_col <- ncol(pioreactor_OD_data_wide)
  
  raw_data_list <- list("pioreactor_OD_data_wide" = pioreactor_OD_data_wide[, c(1, 2:od_max_col)],
                        "raw_time" = pioreactor_OD_data_wide[, c(1, min_raw_time_col:max_raw_time_col)])

  #return(pioreactor_OD_data_wide)
  return(raw_data_list)
}
