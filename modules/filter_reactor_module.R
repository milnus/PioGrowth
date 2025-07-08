filter_reactors_ui <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(
      ns("filt_strat"),
      label = "Filtering strategy",
      choices = c("Remove", "Keep")
    ),
    uiOutput(ns("UserFilters"))
  )
}

filter_reactors_server <- function(id, read_data) {
  moduleServer(id, function(input, output, session) {
    # Render the input selection for reactors
    output$UserFilters <- renderUI({
      user_pio_selection(read_data(), input$reactor_selection, session$ns)
    })

    # Make list of filtering information for plotting
    filter_return_list <- reactive({
      req(read_data())
      # Message for tracking
      message(paste(
        "[filter_reactors_server] - input$reactor_selection:",
        paste(input$reactor_selection, collapse = ", ")
      ))
      message(paste(
        "[filter_reactors_server] - input$filt_strat:",
        input$filt_strat
      ))

      # Filter dataframe of reactors
      filtered_data <- filter_reactors(
        pioreactor_data = read_data(),
        pios_of_interest = input$reactor_selection,
        filt_strat = input$filt_strat
      )

      # Formate the raw data, filtered data, and filtering strategy in a list
      filter_return_list <- format_filter_return(
        read_data(),
        filtered_data,
        input$reactor_selection,
        input$filt_strat
      )

      return(filter_return_list)
    })

    # Return the formatted data list
    return(reactive({
      message("[filter_reactors_server] - RETURN: try od_data_list")
      result <- filter_return_list()

      print(paste("is.null(result)", is.null(result)))
      if (is.null(result)) {
        return(NULL)
      } else {
        message("[filter_reactors_server] - RETURN: od_data_list succeeded")
        return(result)
      }
      #   tryCatch(
      #     {
      #       result <- filter_return_list()
      #       print(result)
      #       print(paste("is.null(result)", is.null(result)))
      #       if (is.null(result)) {
      #         return(NULL)
      #       } else {
      #         message("[filter_reactors_server] - RETURN: od_data_list succeeded")
      #         return(result)
      #       }
      #     },
      #     error = function(e) {
      #       message(
      #         "[filter_reactors_server] - RETURN: od_data_list failed - returning NULL"
      #       )
      #       NULL
      #     }
      #   )
    }))
  })
}
