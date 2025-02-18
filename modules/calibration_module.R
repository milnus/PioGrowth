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
    uiOutput(ns("zero_point_box")),

    # Add in the x_pio_ods_box ui input
    uiOutput(ns("x_pio_ods_box")),

    sliderInput(ns("height"), "Plot height", min = 250, max = 1000, value = 500),
    sliderInput(ns("width"), "Plot width", min = 250, max = 1000, value = 500),

    plotOutput(ns("no_pio_values_plot"))
  )
}

calibration_server <- function(id, read_data) {
  moduleServer(id, function(input, output, session) {

    # Look for upload of manual calibration file and calibrate ods
    calibration_models <- reactive({
      req(input$upload_calibration_file, read_data())
      message(paste("[calibration_server] - Upload calibration file:",
                    input$upload_calibration_file$datapath))

      # Read the manual OD readings file
      manual_od_readings <- read_manual_ods(input$upload_calibration_file$datapath)

      # Pass manual OD readings to calibration function
      complete_od_data <- no_pio_ods_check(manual_od_readings,
                                           read_data(),
                                           input$x_pio_ods)

      # Split OD data per reactor
      manual_lm_models <- split_od_per_reactor(complete_od_data,
                                               as.logical(input$fixed_intercept),
                                               input$origin_point)

      # Return the calibrated data
      return(manual_lm_models)
    })

    formatted_calibration_data <- observeEvent(calibration_models(), {
      req(read_data(), is.null(calibration_models()))

      # Use linear models to predict "true" values for PioReactors
      od_calibration_readings <- predict_calibrated_ods(calibration_models(),
                                                        read_data())

      data_list <- format_calibrated_od_data(read_data(),
                                             od_calibration_readings)
    })


    # Look at the fixed intercept option and render UI for zero point addition
    observeEvent(calibration_models(), {
      message(paste("[calibration_server] - Fixed intercept:",
                    input$fixed_intercept))
    })
    output$zero_point_box <- renderUI({
      # Wait for raw data and filtering information
      req(!input$fixed_intercept)
      # if intercept is not set to fixed give option for origin point
      origin_point_box(session$ns)
    })

    observe({
      message(paste("[calibration_server] - Add point through origin of calibration:",
                    input$origin_point))
    })

    observe({
      message(paste("[calibration_server] - Number of ods from pio for calibration:",
                    input$x_pio_ods))
    })

    # Render origin selection box
    output$x_pio_ods_box <- renderUI({
      # if intercept is not set to fixed give option for origin point
      ui_num_od_read(session$ns)
    })

    ##### Plots #####
    # Plot the regressions underlying the calibration
    output$no_pio_values_plot <- renderPlot({
      req(!is.null(calibration_models()))
      if (length(input$fixed_intercept) == 0) {
        ggplot()
      } else {
        calibration_plot(calibration_models(),
                         as.logical(input$fixed_intercept),
                         input$origin_point)
      }
    }, res = 96,
    width = function() input$width,
    height = function() input$height)

    #### Downloads ####
    # Download handler for calibrated data
    output$download_table <- downloadHandler(
      filename = function() {
        "Calibrated_OD_reading.csv"
      },
      content = function(file) {
        write.table(write_calibrate_od_to_pio_format(calibrated_data()),
                    file,
                    row.names = FALSE,
                    col.names = TRUE,
                    sep = ",", na = "",
                    quote = FALSE)
    }
  )
  })
}