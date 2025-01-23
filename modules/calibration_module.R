calibration_ui <- function(id) {
  ns <- NS(id)
  tagList(
    checkboxInput(
      inputId = ns("fixed_intercept"),
      label = "Force intercept through origin",
      value = FALSE
    ),
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

  })
}