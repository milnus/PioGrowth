calibration_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Upload of calibration value csv
    fileInput(ns("upload_calibration_file"),
              label = "Manual OD measurments table",
              accept = c(".csv", ".txt")),

    # Fixed intercept input box
    checkboxInput(
      inputId = ns("fixed_intercept"),
      label = "Force intercept through origin",
      value = FALSE
    ),
    # Origin point addition option
    uiOutput(ns("zero_point_box"))
  )
}

calibration_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    observe({
      message(paste("Fixed intercept:", input$fixed_intercept))
    })

    output$zero_point_box <- renderUI({
      # Wait for raw data and filtering information
      req(!input$fixed_intercept)
      # if intercept is not set to fixed give option for origin point
      origin_point_box()
    })

    # More server functions
	observe({
		req(input$upload_calibration_file)
		message(paste("Upload calibration file:", input$upload_calibration_file$datapath))
	})
  })
}