#### Filter out pioreactors based on user feedback ####

filter_reactors <- function(
  pioreactor_data,
  pios_of_interest = c(),
  filt_strat
) {
  # Check if filtering is required
  if (!is.null(pios_of_interest)) {
    # Construct regex string and search for reactor columns
    regex_str <- paste0(pios_of_interest, collapse = "|")
    columns_oi <- grep(
      regex_str,
      names(pioreactor_data[[1]]),
      ignore.case = TRUE
    )

    # Keep reactors selected by user else remove:
    if (filt_strat == "Keep") {
      pioreactor_data <- lapply(
        pioreactor_data,
        function(x) x[, c(1, columns_oi)]
      )
    } else {
      pioreactor_data <- lapply(
        pioreactor_data,
        function(x) x[, c(-columns_oi)]
      )
    }
  }

  if (is.vector(pioreactor_data[[1]])) {
    message("[filter_reactors()] - All reactors filtered out")
    return()
  }

  return(pioreactor_data)
}
