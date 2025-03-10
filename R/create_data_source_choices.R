create_data_source_choices <- function(raw_data, calibrated_data) {
  # Initialize choices vector
  choices <- c()

  # Add choices based on available data
  if (!is.null(calibrated_data)) {
    choices <- c(choices, "calibrated" = "calibrated")
  }
  if (!is.null(raw_data)) {
    choices <- c(choices, "raw" = "raw")
  }
  # Not yet implemented in the app
  # if (!is.null(raw_data) && !is.null(calibrated_data)) {
  #   choices <- c(choices, "compare" = "compare")
  # }

  return(choices)
}
