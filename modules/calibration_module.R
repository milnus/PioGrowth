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

    # Add downlload button for calibrated data
    uiOutput(ns("download_button_ui")),

    # Add sliders for plot height and width
    sliderInput(ns("height"), "Plot height",
                min = 250,
                max = 1000, 
                value = 500),
    sliderInput(ns("width"), "Plot width",
                min = 250,
                max = 1000,
                value = 500),

    # Add plot of linear calibration regression models
    plotOutput(ns("zero_intercept_plot")),
    plotOutput(ns("no_pio_values_plot"))
  )
}

calibration_server <- function(id, od_data_list) {
  moduleServer(id, function(input, output, session) {

    # Look for upload of manual calibration file and calibrate ods
    complete_od_data <- reactive({
      req(input$upload_calibration_file, od_data_list())
      message(paste("[calibration_server] - Upload calibration file:",
                    input$upload_calibration_file$datapath))

      # Read the manual OD readings file
      manual_od_readings <- read_manual_ods(input$upload_calibration_file$datapath)

      # Filter manual readings based on filtering strategy
      filtered_manual_od <- filter_manual_ods(manual_od_readings, od_data_list())

      # Pass manual OD readings to calibration function
      complete_od_data <- no_pio_ods_check(filtered_manual_od,
                                           od_data_list(),
                                           input$x_pio_ods)

      return(complete_od_data)
    })

    calibration_models <- reactive({
      req(complete_od_data())
      # Split OD data per reactor
      manual_lm_models <- split_od_per_reactor(complete_od_data(),
                                               as.logical(input$fixed_intercept),
                                               input$origin_point)

      # Return the calibrated data
      return(manual_lm_models)
    })

    calibrated_data <- reactive({
      req(calibration_models())
      # Require both inputs and validate they're not NULL
      req(input$upload_calibration_file, od_data_list())

      predict_calibrated_ods(calibration_models(), od_data_list())
    })

    formatted_calibration_data <- reactive({
      req(od_data_list(), !is.null(calibrated_data()))

      data_list <- format_calibrated_od_data(od_data_list(),
                                             calibrated_data())
      return(data_list)
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
      req(od_data_list())
      message(paste("[calibration_server] - Add point through origin of calibration:",
                    input$origin_point))
    })

    observe({
      req(od_data_list())
      message(paste("[calibration_server] - Number of ods from pio for calibration:",
                    input$x_pio_ods))
    })

    # Render origin selection box
    output$x_pio_ods_box <- renderUI({
      # if intercept is not set to fixed give option for origin point
      ui_num_od_read(session$ns)
    })

    ##### Plots #####
    # Plot the points that are used for calibration of the pio reactors
    output$zero_intercept_plot <- renderPlot({
      first_last_od_plot(complete_od_data(), input$x_pio_ods)
    }, res = 96,
    width = function() input$width,
    height = function() input$height)

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

    # Render download button
    output$download_button_ui <- renderUI({
      req(!is.null(calibrated_data()))
      downloadButton(session$ns("download_table"),
                     label = "Download calibrated data")
      # }
    })

    return(reactive({
      message("[calibration_server] - RETURN: try od_data_list")
      tryCatch(
        {
          result <- formatted_calibration_data()
          if (is.null(result)) return(NULL)
          result
        },
        error = function(e) {
          message("[calibration_server] - RETURN: od_data_list failed - returning NULL")
          NULL
        }
      )
    }))
  })
}