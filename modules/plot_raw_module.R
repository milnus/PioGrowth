plot_raw_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("raw_data_plot"), height = "400px")
  )
}

plot_raw_server <- function(id, read_data, filter_data) {
  moduleServer(id, function(input, output, session) {

    output$raw_data_plot <- renderPlot({
    #   req(read_data(), filter_data())

      message(paste("Reactors selected:", filter_data()$reactor_selection))
      message(paste("Filtering strategy:", filter_data()$filt_strat))

      plot_raw_data(read_data(),
	#   input$reactor_selection,
	#   filt_strat = input$filt_strat)
                    filter_data()$reactor_selection,
                    filter_data()$filt_strat)
    })

  })
}