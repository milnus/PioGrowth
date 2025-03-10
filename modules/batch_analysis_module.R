batch_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Render selection of data source buttons
    uiOutput(ns("data_source_radio")),

    # Render button to process data
    actionButton(ns("process_batch"), "Process data batch growth"),

    # Render radio button for showing of removing points in plot
    uiOutput(ns("UserPointRemoval")),

    # Let the user define what a high mu is using a slide
    uiOutput(ns("UserHighMuPercentage")),

    # Render plot of growth data
    plotOutput(ns("plot_batch_growth")),

    # Render plot of growth rate data
    plotOutput(ns("growth_rate_plot")),

    # Render download options for plots
    downloadButton(
      ns("download_growth_plot"),
      "Download Growth Plot"
    ),
    downloadButton(
      ns("download_growth_rate_plot"),
      "Download Growth Rate Plot"
    ),

    # Render summary table and download button
    downloadButton(ns("download_table"), "Download Summarised Data"),
    tableOutput(ns("summary_table")),

    # Allow download of full spline dataset
    downloadButton(
      ns("download_raw_table"),
      label = "Download Full Growth Data fit"
    )
  )
}

batch_analysis_server <- function(
  id,
  calibrated_od_data_list,
  raw_od_data_list
) {
  moduleServer(id, function(input, output, session) {
    # Observe process button
    process_batch <- eventReactive(input$process_batch, {
      # Start progress bar
      withProgress(message = "Start processing batch data", value = 0, {
        return(TRUE)
      })
    })
    observe(message(paste(
      "[batch_analysis_server] - Start processing as batch:",
      process_batch()
    )))

    # Set data to be used for analysis
    od_data_list <- reactive({
      req(
        process_batch(),
        !is.null(calibrated_od_data_list()) | !is.null(raw_od_data_list())
      )

      withProgress(message = "Loading data", value = 0.2, {
        message(
          "[batch_analysis_server] - input$data_source:",
          input$data_source
        )
        if (input$data_source == "calibrated") {
          message(
            "[batch_analysis_server] - Using calibrated data for batch analysis"
          )
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
        message("[batch_analysis_server] - detecting outliers")
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
      message("[batch_analysis_server] - correcting negative values")

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

    fitted_spline_data <- reactive({
      req(od_data_list_neg_corrected())
      message("[batch_analysis_server] - Fit splines")

      withProgress(message = "Fitting growth curves", value = 0.6, {
        fitted_spline_data_return <- od_data_list_neg_corrected()

        fitted_spline_data_return[["spline_data"]] <- spline_growth_integration(
          fitted_spline_data_return,
          spline_smoothing = 1.0
        )

        return(fitted_spline_data_return)
      })
    })

    # Summarise growth data
    # Summarise growth data
    summarised_growth_data <- reactive({
      req(fitted_spline_data())

      summarise_growth_data(
        fitted_spline_data(),
        input$high_mu_percentage / 100
      )
    })

    #### Plot output ####
    ## Let the user turn of points in growth plot
    output$UserPointRemoval <- renderUI({
      user_point_removal(session$ns, input$remove_points)
    })

    # Plot the growth data with a spline coloured by growth rate
    output$plot_batch_growth <- renderPlot(
      {
        req(fitted_spline_data(), input$remove_points)
        message("[batch_analysis_server] - Plotting growth data")
        withProgress(message = "Creating plot", value = 0.9, {
          plot_growth_data(
            fitted_spline_data(),
            remove_points = input$remove_points
          )
        })
      },
      res = 96
    )

    # Plot the growth rate over time coloured by growth rate
    output$growth_rate_plot <- renderPlot(
      {
        plot_growth_rate_data(fitted_spline_data(), summarised_growth_data())
      },
      res = 96
    )

    # Allow download of growth plot and growth rate plot
    output$download_growth_plot <- downloadHandler(
      filename = function() {
        "Growth_plot.svg"
      },
      content = function(file) {
        ggsave(
          file,
          plot_growth_data(
            fitted_spline_data(),
            remove_points = input$remove_points
          ),
          device = 'svg',
          width = 33,
          height = 19,
          units = 'cm'
        )
      }
    )

    output$download_growth_rate_plot <- downloadHandler(
      filename = function() {
        "Growth_rate_plot.svg"
      },
      content = function(file) {
        ggsave(
          file,
          plot_growth_rate_data(
            fitted_spline_data(),
            summarised_growth_data()
          ),
          device = 'svg',
          width = 33,
          height = 19,
          units = 'cm'
        )
      }
    )

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
          selected = choices[1] # Default to first available option
        )
      }
    })

    # Render a slider for high mu selection
    output$UserHighMuPercentage <- renderUI({
      high_mu_range_slider(
        session$ns,
        input$high_mu_percentage
      )
    })

    # Render summary table of growth data
    output$summary_table <- renderTable(summarised_growth_data())

    # Enable download of summarised growth data
    output$download_table <- downloadHandler(
      filename = function() {
        "Summaried_growth_rate_data.csv"
      },
      content = function(file) {
        write.table(
          summarised_growth_data(),
          file,
          row.names = F,
          col.names = T,
          sep = ","
        )
      }
    )

    # Enable download of full spline dataset
    output$download_raw_table <- downloadHandler(
      ## TODO - RE-ADD
      filename = function() {
        "Raw_growth_rate_data_batch.csv"
      },
      content = function(file) {
        write.table(
          fitted_spline_data()[["spline_data"]],
          file,
          row.names = F,
          col.names = T,
          sep = ","
        )
      }
    )
  })
}
