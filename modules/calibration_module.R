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

calibration_server <- function(id, read_data) {
  moduleServer(id, function(input, output, session) {


    # Look for upload of manual calibration file and calibrate ods
    observe({
      req(input$upload_calibration_file, read_data())
      message(paste("[calibration_server] - Upload calibration file:",
                    input$upload_calibration_file$datapath))
      
      # Read the manual OD readings file
      manual_od_readings <- read_manual_ods(input$upload_calibration_file$datapath)

      # Pass manual OD readings to calibration function
      complete_od_data <- no_pio_ods_check(manual_od_readings, read_data(), 5) # Add input from ui input "calibration_points"

      message(manual_od_readings)

      message(complete_od_data)
    })

  # Look at the fixed intercept option and render UI for zero point addition
    observe({
      message(paste("[calibration_server] - Fixed intercept:", input$fixed_intercept))
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