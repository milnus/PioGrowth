turbidostat_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Render selection of data source buttons
    uiOutput(ns("data_source_radio")),

    # Render button to process data
    actionButton(ns("process_turbidostat"), "Process turbidostat growth data"),
  )
}

turbidostat_analysis_server <- function(
  id,
  calibrated_od_data_list,
  raw_od_data_list
) {
  moduleServer(id, function(input, output, session) {
    # Observe process button
    process_turbidostat <- eventReactive(input$process_turbidostat, {
      # Start progress bar
      withProgress(message = "Start processing turbidostat data", value = 0, {
        return(TRUE)
      })
    })

    observe(message(paste(
      "[turbidostat_analysis_server] - Start processing as turbidostat:",
      process_turbidostat()
    )))

    # Set data to be used for analysis
    od_data_list <- reactive({
      req(
        process_turbidostat(),
        !is.null(calibrated_od_data_list()) | !is.null(raw_od_data_list())
      )

      withProgress(message = "Loading data", value = 0.2, {
        message(
          "[turbidostat_analysis_server] - input$data_source:",
          input$data_source
        )
        if (input$data_source == "calibrated") {
          message(
            "[turbidostat_analysis_server] - 
            Using calibrated data for turbidostat analysis"
          )
          return(calibrated_od_data_list())
        } else {
          message(
            "[turbidostat_analysis_server] - 
            Using raw data for turbidostat analysis"
          )
          return(raw_od_data_list())
        }
      })
    })

    # Isolate appropriate od readings depending on user choise
    od_data <- reactive({
      req(od_data_list())

      withProgress(message = "Prepping data", value = 0.3, {
        message("[turbidostat_analysis_server] - Isolating OD readings")
        if (input$data_source == "calibrated") {
          od_data <- calibrated_od_data_list()[["calibrated_data"]]
        } else {
          od_data <- raw_od_data_list()[["filtered_data"]][[
            "pioreactor_OD_data_wide"
          ]]
        }

        return(od_data)
      })
    })

    # Identify outliers and insert into od_data_list
    od_data_list_outlier_detected <- reactive({
      withProgress(message = "Detecting outliers", value = 0.4, {
        message("[turbidostat_analysis_server] - detecting outliers")
        req(od_data())

        od_data_list_outlier_detected <- od_data_list()

        od_data_list_outlier_detected[[
          "outliers"
        ]] <- iqr_outlier_detection(od_data())

        return(od_data_list_outlier_detected)
      })
    })

    od_data_list_neg_corrected <- reactive({
      req(od_data_list_outlier_detected())
      message("[turbidostat_analysis_server] - correcting negative values")

      withProgress(message = "Correcting negative measurement", value = 0.5, {
        od_data_list_neg_corrected <- od_data_list_outlier_detected()

        od_data_list_neg_corrected[[
          "negative_corrected"
        ]] <- correct_neg_data_median(
          od_data(),
          od_data_list_neg_corrected[["outliers"]]
        )

        return(od_data_list_neg_corrected)
      })
    })

    # Run growth analysis for turbidostat data

    # #### Plot output ####
    # ## Let the user turn of points in growth plot
    # output$UserPointRemoval <- renderUI({
    #   user_point_removal(session$ns, input$remove_points)
    # })

    # Plot the growth data with a spline coloured by growth rate

    # Plot the growth rate over time as points and insecurity

    # # Allow download of growth plot and growth rate plot

    # #### UI output ####
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
          selected = choices[1] # Default to first available option
        )
      }
    })

    # # Render a slider for high mu selection
    # output$UserHighMuPercentage <- renderUI({
    #   high_mu_range_slider(
    #     session$ns,
    #     input$high_mu_percentage
    #   )
    # })

    # # Render slider for setting spline smoothing
    # output$UserSplineSmoothing <- renderUI({
    #   smoothing_slider(
    #     session$ns,
    #     input$spline_smoothing
    #   )
    # })

    # # Render summary table of growth data
    # output$summary_table <- renderTable(summarised_growth_data())

    # # Enable download of summarised growth data
    # output$download_table <- downloadHandler(
    #   filename = function() {
    #     "Summaried_growth_rate_data.csv"
    #   },
    #   content = function(file) {
    #     write.table(
    #       summarised_growth_data(),
    #       file,
    #       row.names = F,
    #       col.names = T,
    #       sep = ","
    #     )
    #   }
    # )

    # # Enable download of full spline dataset
    # output$download_raw_table <- downloadHandler(
    #   ## TODO - RE-ADD
    #   filename = function() {
    #     "Raw_growth_rate_data_turbidostat.csv"
    #   },
    #   content = function(file) {
    #     write.table(
    #       fitted_spline_data()[["spline_data"]],
    #       file,
    #       row.names = F,
    #       col.names = T,
    #       sep = ","
    #     )
    #   }
    # )
  })
}
