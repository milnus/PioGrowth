format_filter_return <- function(
  raw_data,
  filtered_data,
  reactor_selection,
  filt_strat
) {
  return_list <- list(
    "raw_data" = raw_data[["pioreactor_OD_data_wide"]],
    "filtered_data" = filtered_data[["pioreactor_OD_data_wide"]],
    "file_path" = raw_data[["file_path"]],
    "filtering_state" = list(
      "reactors_selected" = reactor_selection,
      "filtering_strategy" = filt_strat
    )
  )

  return(return_list)
}
