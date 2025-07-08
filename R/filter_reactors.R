#### Filter out pioreactors based on user feedback ####

filter_reactors <- function(
  pioreactor_data,
  pios_of_interest = c(),
  filt_strat
) {
  # Check if filtering is required
  if (!is.null(pios_of_interest)) {
    ## Construct regex string and search for reactor columns
    regex_str <- paste0(pios_of_interest, collapse = "|")
    columns_oi <- grep(
      regex_str,
      colnames(pioreactor_data[["pioreactor_OD_data_wide"]]),
      ignore.case = TRUE
    )

    ## Keep reactors selected by user else remove:
    if (filt_strat == "Keep") {
      pioreactor_data[c("pioreactor_OD_data_wide", "raw_time")] <- lapply(
        pioreactor_data[c("pioreactor_OD_data_wide", "raw_time")],
        function(x) x[, c(1, columns_oi)]
      )
    } else {
      pioreactor_data[c("pioreactor_OD_data_wide", "raw_time")] <- lapply(
        pioreactor_data[c("pioreactor_OD_data_wide", "raw_time")],
        function(x) x[, c(-columns_oi)]
      )
    }
  }

  ## Check if any reactors are left after filtering
  if (is.vector(pioreactor_data[["pioreactor_OD_data_wide"]])) {
    message("[filter_reactors()] - All reactors filtered out")
    return()
  }

  return(pioreactor_data)
}
