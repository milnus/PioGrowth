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
                    input$reactor_selection))
      message(paste("[filter_reactors_server] - input$filt_strat:",
                    input$filt_strat))

      # Set filering state for return
      filter_rv(list(
        reactor_selection = input$reactor_selection,
        filt_strat = input$filt_strat
      ))
    })

    # Return the reactive values with filtering stat
    reactive({
      filter_rv()
    })
  })
}