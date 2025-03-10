# Function to allow user to select reactors of interest
user_pio_selection <- function(read_data, reactor_selection, ns) {
  if (is.null(read_data)) {
    return()
  }

  shiny::selectInput(
    inputId = ns("reactor_selection"),
    label = "Select Pioreactors to remove or keep 
              based on option above\n(red plots will be 
              removed and green will be keep in further analyses)",
    choices = stringr::str_replace(
      names(read_data[["pioreactor_OD_data_wide"]]),
      pattern = "od_reading\\.",
      ""
    )[-1],
    selected = reactor_selection,
    multiple = TRUE
  )
}
