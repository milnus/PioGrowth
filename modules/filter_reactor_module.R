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

    output$UserFilters <- renderUI({
    user_pio_selection(read_data(), input$reactor_selection, session$ns)
    })

    # Make list of filtering information for plotting
    observe({

      message(paste("input$reactor_selection:", input$reactor_selection))
      message(paste("input$filt_strat:", input$filt_strat))

      filter_rv(list(
        reactor_selection = input$reactor_selection,
        filt_strat = input$filt_strat
      ))
    })

	# Return the reactive values
    reactive({
      filter_rv()
    })
  })
}