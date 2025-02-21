batch_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
	uiOutput(ns("data_source_radio")),


	actionButton(ns("process_batch"), "Process data batch growth")

  )
}

batch_analysis_server <- function(id, calibrated_od_data_list, raw_od_data_list) {
  moduleServer(id, function(input, output, session) {
    # Observe process button
    process_batch <- eventReactive(input$process_batch, {
      TRUE
    })
    observe(message(paste("[batch_analysis_server] - Start processing as batch:", process_batch())))

    od_data_list <- reactive({
      req(process_batch())
      if (is.null(calibrated_od_data_list())) {
        message("[batch_analysis_server] - Using raw data for batch analysis")
        return(raw_od_data_list())
      } else {
        message("[batch_analysis_server] - Using calibrated data for batch analysis")
        return(calibrated_od_data_list())
      }
    })


    #### UI output ####
    # Find the data sources available
    output$data_source_radio <- renderUI({
      choices <- create_data_source_choices(
        raw_data = raw_od_data_list(),
        calibrated_data = calibrated_od_data_list()
      )

      # Only render if there are choices available
      if (length(choices) > 0) {
        radioButtons(
          inputId = session$ns("data_source"),
          label = "Select data source",
          choices = choices,
          selected = choices[1]  # Default to first available option
        )
      }
    })

  })

}