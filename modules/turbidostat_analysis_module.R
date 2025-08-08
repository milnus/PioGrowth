##### Turbidostat analysis ui #####
turbidostat_analysis_ui <- function(id) {
  ns <- NS(id)
  useShinyjs()
  tagList(
    # Render selection of data source buttons
    uiOutput(ns("data_source_radio")),

    # Add Event Dosing Data upload
    fileInput(
      ns("dosing_event_upload"),
      label = "Load PioReactor dosing_automation_events csv file",
      accept = c(".csv", ".txt")
    ),
    # textOutput(ns("status")) # Add status text output

    # Render button to process data
    br(),
    actionButton(
      ns("process_turbidostat_btn"),
      "Process turbidostat growth data",
      class = "btn-primary"
    ),

    # Add download buttons
    br(),
    downloadButton(
      ns("download_table"),
      "Download Summary Data",
      class = "btn-success"
    ),
    downloadButton(
      ns("download_raw_table"),
      "Download Raw Spline Data",
      class = "btn-info"
    ),

    # Add table output for summary data
    br(),
    tableOutput(ns("summary_table"))
  )
}

##### Turbidostat analysis server #####
turbidostat_analysis_server <- function(
  id,
  calibrated_od_data_list,
  raw_od_data_list
) {
  moduleServer(id, function(input, output, session) {
    ##### Control availability of process button based on upload of files #####
    # Reactive expression to check if both files are uploaded
    files_uploaded <- reactive({
      print("file upload check")
      # req(
      #   !is.null(raw_od_data_list()[["file_path"]]) &
      #     !is.null(input$dosing_event_upload)
      # )
      print("File upload check pass req()")
      !is.null(raw_od_data_list()[["file_path"]]) & # OD readings file
        !is.null(input$dosing_event_upload) # Dosing event file
    })

    # Enable/disable button based on file upload status
    observe({
      # TODO - fully make this botton's reactive/disable state work or switch for a small "state" text output giving uploaded and missing files.
      req(raw_od_data_list())
      message("[turbidostat_analysis_server] - Checking if files are uploaded")
      if (files_uploaded()) {
        message("[turbidostat_analysis_server] -  - Files are uploaded")
        shinyjs::enable(session$ns("process_turbidostat_btn"))
      } else {
        message("[turbidostat_analysis_server] -  - Files NOT uploaded")
        shinyjs::disable(session$ns("process_turbidostat_btn"))
      }
    })

    # Observe process button
    process_turbidostat <- eventReactive(input$process_turbidostat_btn, {
      # Start progress bar
      withProgress(message = "Start processing turbidostat data", value = 0, {
        return(TRUE)
      })
    })

    ##### Preprocess data #####
    observe(message(paste(
      "[turbidostat_analysis_server] - Start processing as turbidostat:",
      process_turbidostat()
    )))

    # Set data to be used for analysis
    od_data_list <- reactive({
      req(
        process_turbidostat(),
        !is.null(input$dosing_event_upload),
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
            "[turbidostat_analysis_server] - Using raw data for turbidostat analysis"
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
          od_data <- od_data_list()[["calibrated_data"]]
        } else {
          od_data <- od_data_list()[["filtered_data"]]
        }
        message("[turbidostat_analysis_server] - Isolating OD readings - END")

        return(od_data)
      })
    })

    # Identify outliers and insert into od_data_list
    od_data_list_outlier_detected <- reactive({
      withProgress(message = "Detecting outliers", value = 0.4, {
        req(od_data())
        message("[turbidostat_analysis_server] - detecting outliers")

        od_data_list_outlier_detected <- od_data_list()

        # Run IQR outlier detection
        od_data_list_outlier_detected[[
          "outliers"
        ]] <- iqr_outlier_detection(od_data())

        # Run Spline outlier detection
        od_data_list_outlier_detected[[
          "outliers"
        ]] <- spline_outlier_detection(
          od_data(),
          od_data_list_outlier_detected[["outliers"]]
        )

        return(od_data_list_outlier_detected)
      })
    })

    od_data_list_neg_corrected <- reactive({
      req(od_data_list_outlier_detected())
      message("[turbidostat_analysis_server] - Correcting negative values")

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

    # # Run growth analysis for turbidostat data
    # spline_peak_data <- reactive({
    #   peak_detection_spline_workflow(
    #     od_data_list_neg_corrected()[["negative_corrected"]],
    #     od_data_list_neg_corrected()[["outliers"]]
    #   )
    # })

    # observe({
    #   spline_peak_data()
    # })

    ## Search and read the dilution event data
    od_dilution_event_data <- reactive({
      req(!is.null(od_data_list_neg_corrected()))
      message("[turbidostat_analysis_server] - reading dilution event data")

      message(
        "[turbidostat_analysis_server] - uploaded dosing_event_upload:",
        input$dosing_event_upload
      )

      withProgress(message = "Reading dilution event data", value = 0.6, {
        od_dilution_event_data <- od_data_list_neg_corrected()

        od_dilution_event_data[[
          "dosing_event_data"
        ]] <- read_dosing_automation_events_data(
          od_data_list_neg_corrected()[["file_path"]],
          input$dosing_event_upload$datapath
        )
      })

      return(od_dilution_event_data)
    })

    od_data_split_turbidostat <- reactive({
      req(od_dilution_event_data())

      od_reactor_data_split <- od_dilution_event_data()

      ## Split turbidostat data into individual growth curves
      message("[turbidostat_analysis_server] - splitting turbidostat data")
      od_reactor_data_split[[
        "split_turbidostat_data"
      ]] <- split_turbidostat_data(
        od_reactor_data_split[["negative_corrected"]],
        od_reactor_data_split[["dosing_event_data"]],
        od_reactor_data_split[["outliers"]]
      )

      return(od_reactor_data_split)
    })

    spline_fitted_growths <- reactive(
      {
        req(od_data_split_turbidostat())
        message(
          "[turbidostat_analysis_server] - Fitting spline to turbidostat data"
        )
        withProgress(
          message = "Fitting spline to turbidostat data",
          value = 0.7,
          {
            # Loop through each split data and fit spline
            message(
              "[turbidostat_analysis_server] - Fitting spline to each growth phase"
            )
            fitted_spline_data <- lapply(
              od_data_split_turbidostat()[["split_turbidostat_data"]],
              function(x) {
                spline_growth_integration_turbidostat(
                  x,
                  spline_smoothing = 1.0,
                  reactor_name = names(x)[1]
                )
              }
            )

            # Combine all fitted data into a single data frame
            # do.call(rbind, fitted_spline_data)
            return(fitted_spline_data)
          }
        )
      }
      # tt <- sapply(
      #   1:length(od_data_split_turbidostat()[["split_turbidostat_data"]]),
      #   function(x) {
      #     spline_growth_integration_turbidostat(
      #       od_data_split_turbidostat()[["split_turbidostat_data"]][[x]],
      #       reactor_name = names(od_data_split_turbidostat()[[
      #         "split_turbidostat_data"
      #       ]])[x]
      #     )
      #   }
      # )
    )

    summarised_growth_data <- reactive({
      req(spline_fitted_growths())
      message("[turbidostat_analysis_server] - Summarising growth data")

      summarise_growth_list_turbidostat(
        spline_fitted_growths(),
        plot_data = T
      )
    })

    ##### Plot output #####
    # ## Let the user turn of points in growth plot
    # output$UserPointRemoval <- renderUI({
    #   user_point_removal(session$ns, input$remove_points)
    # })

    # Plot the growth data with a spline coloured by growth rate

    # Plot the growth rate over time as points and insecurity

    # # Allow download of growth plot and growth rate plot

    ##### UI output #####
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
        "Raw_growth_rate_data_turbidostat.csv"
      },
      content = function(file) {
        write.table(
          do.call("rbind.data.frame", spline_fitted_growths()),
          file,
          row.names = F,
          col.names = T,
          sep = ","
        )
      }
    )
  })
}
