plot_raw_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("raw_data_plot"), height = "400px")
  )
}

plot_raw_server <- function(id, read_data, filter_data) {
  moduleServer(id, function(input, output, session) {

    output$raw_data_plot <- renderPlot({
      # Wait for raw data and filtering information
      req(read_data(), filter_data())

      filter_strategy <- filter_data()$filtering_state$filtering_strategy
      reactors_selected <- filter_data()$filtering_state$reactors_selected

      # Return messages for tracking
      message(paste("[plot_raw_server] - Filtering strategy:",
                    filter_strategy))
      message(paste("[plot_raw_server] - Reactors selected:",
                    paste(reactors_selected,
                          collapse = ", ")))

      # Plot the raw data indicating filtering of reactors
      plot_raw_data(read_data(),
                    reactors_selected,
                    filter_strategy)
    })

  })
}