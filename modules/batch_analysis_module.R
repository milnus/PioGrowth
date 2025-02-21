batch_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Render selection of data source buttons
    uiOutput(ns("data_source_radio")),

    # Render button to process data
    actionButton(ns("process_batch"), "Process data batch growth"),

    # Render plot of growth data
    plotOutput(ns("plot_batch_growth"))

  )
}

batch_analysis_server <- function(id, calibrated_od_data_list, raw_od_data_list) {
  moduleServer(id, function(input, output, session) {
    # Observe process button
    process_batch <- eventReactive(input$process_batch, {
      # Start progress bar
      withProgress(message = "Start processing batch data", value = 0, {
        return(TRUE)
      })
    })
    observe(message(paste("[batch_analysis_server] - Start processing as batch:", process_batch())))

    # Set data to be used for analysis
    od_data_list <- reactive({
      req(process_batch(), !is.null(calibrated_od_data_list()) | !is.null(raw_od_data_list()))

      withProgress(message = "Loading data", value = 0.2, {
        message("[batch_analysis_server] - input$data_source:", input$data_source)
        if (input$data_source == "calibrated") {
          message("[batch_analysis_server] - Using calibrated data for batch analysis")
          return(calibrated_od_data_list())
        } else {
          message("[batch_analysis_server] - Using raw data for batch analysis")
          return(raw_od_data_list())
        }
      })
    })

    # Isolate appropriate od readings depending on user choise
    od_data <- reactive({
      req(od_data_list())

      withProgress(message = "Prepping data", value = 0.3, {
        message("[batch_analysis_server] - Isolating OD readings")
        if (input$data_source == "calibrated") {
          od_data <- calibrated_od_data_list()[["calibrated_data"]]
        } else {
          od_data <- raw_od_data_list()[["filtered_data"]][["pioreactor_OD_data_wide"]]
        }

        return(od_data)
      })
    })

    # Identify outliers and insert into od_data_list
    od_data_list_outlier_detected <- reactive({
      withProgress(message = "Detecting outliers", value = 0.4, {
        message("[batch_analysis_server] - detecting outliers")
        req(od_data())

        od_data_list_outlier_detected <- od_data_list()

        od_data_list_outlier_detected[["outliers"]] <- iqr_outlier_detection(od_data())

        return(od_data_list_outlier_detected)
      })
    })

    od_data_list_neg_corrected <- reactive({
      req(od_data_list_outlier_detected())
      message("[batch_analysis_server] - correcting negative values")

      withProgress(message = "Correcting negative measurement", value = 0.5, {
        od_data_list_neg_corrected <- od_data_list_outlier_detected()

        od_data_list_neg_corrected[["negative_corrected"]] <- correct_neg_data_median(od_data(),
                                                                od_data_list_neg_corrected[["outliers"]])

        return(od_data_list_neg_corrected)
      })
    })

    fitted_spline_data <- reactive({
      req(od_data_list_neg_corrected())
      message("[batch_analysis_server] - Fit splines")

      withProgress(message = "Fitting growth curves", value = 0.6, {
        fitted_spline_data_return <- od_data_list_neg_corrected()

        fitted_spline_data_return[["spline_data"]] <- spline_growth_integration(fitted_spline_data_return,
                                                        spline_smoothing = 1.0) #input$spline_smoothing)

      return(fitted_spline_data_return)
      })
    })


    #### Plot output ####
    output$plot_batch_growth <- renderPlot({
      req(fitted_spline_data())
      message("[batch_analysis_server] - Plotting growth data")
      withProgress(message = "Creating plot", value = 0.9, {
        plot_growth_data(fitted_spline_data(), remove_points = FALSE)#, input$remove_points)
      })
    }, res = 96)

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

    observe(fitted_spline_data())
  })

}