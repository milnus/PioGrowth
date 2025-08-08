#### Function to read in ####
read_manual_ods <- function(manual_reading_csv) {
  message("[read_manual_ods] - STARTING")
  if (is.null(manual_reading_csv)) {
    return(NULL)
  }
  # Read the manual OD reads
  calibration_table <- read.table(manual_reading_csv, sep = ",", header = TRUE)

  # Match columns
  pio_od_col_num <- grep("pio", colnames(calibration_table), ignore.case = TRUE)
  manual_od_col_num <- grep(
    "manual",
    colnames(calibration_table),
    ignore.case = TRUE
  )
  reactor_name_col_num <- grep(
    "name|reactor",
    colnames(calibration_table),
    ignore.case = TRUE
  )

  if (length(pio_od_col_num) == 0) {
    pio_od_col_num <- 3
    calibration_table[, 3] <- NA
    colnames(calibration_table)[3] <- "pio"
  }

  # Check if all required columns are matched
  if (
    any(
      length(pio_od_col_num) > 1,
      length(manual_od_col_num) > 1,
      length(reactor_name_col_num) > 1
    )
  ) {
    stop(errorCondition(
      message = "More than one column was identified as either pioreactor name (contains: reactor), manual OD readings (contains: manual), or pio reactor OD reading: (contains: pio)",
      class = "Input_error"
    ))
  }
  if (any(length(manual_od_col_num) == 0, length(reactor_name_col_num) == 0)) {
    stop(errorCondition(
      message = "One or more of the following had no match to a column: pioreactor name (contains: reactor), manual OD readings (contains: manual), or pio reactor OD reading: (contains: pio)",
      class = "Input_error"
    ))
  }

  # reorder and name columns
  calibration_table <- calibration_table[, c(
    reactor_name_col_num,
    pio_od_col_num,
    manual_od_col_num
  )]

  colnames(calibration_table) <- c("name", "pio_od", "manual_od")

  return(calibration_table)
}
