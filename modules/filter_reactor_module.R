filter_reactors_ui <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(ns("filt_strat"), label = "Filtering strategy",
                 choices = c("Remove", "Keep")),
    uiOutput(ns("UserFilters"))
  )
}

filter_reactors_server <- function(id, read_data) {
  moduleServer(id, function(input, output, session) {
    # Create a reactive value to store the filter state
    filter_rv <- reactiveVal()
    # Create a reactive value for filtered reactor list
    filtered_reactor_list <- reactiveVal()

    # Render the input selection for reactors
    output$UserFilters <- renderUI({
      user_pio_selection(read_data(),
                         input$reactor_selection,
                         session$ns)
    })

    # Make list of filtering information for plotting
    observe({
      # Message for tracking
      message(paste("[filter_reactors_server] - input$reactor_selection:",
                    paste(input$reactor_selection, collapse = ", ")))
      message(paste("[filter_reactors_server] - input$filt_strat:",
                    input$filt_strat))

      # Set filering state for return
      filter_rv(list(
        reactor_selection = input$reactor_selection,
        filt_strat = input$filt_strat
      ))

      # Filter dataframe of reactors
      filtered_data <- filter_reactors(
          pioreactor_data = read_data(),
          pios_of_interest = input$reactor_selection,
          filt_strat = input$filt_strat
      )

      # Create list with raw reactor data filtered for reactors of interest
      filtered_reactor_list(list("raw_reactor_data" = filtered_data))

      # Add message for dimensions
      message(paste("[filter_reactors_server] - dimensions of filtered raw data:",
                    paste(dim(filtered_data), collapse = " x ")))
    })

    # Return the reactive values with filtering stat
    return(reactive({
      list(
        "filter_rv" = filter_rv(),
        "od_data_list" = filtered_reactor_list()
      )
    }))
  })
}