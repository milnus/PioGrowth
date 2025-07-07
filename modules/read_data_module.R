read_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(
      ns("upload"),
      label = "Load PioReactor OD_readings csv file",
      accept = c(".csv", ".txt")
    ),
    textOutput(ns("status")) # Add status text output
  )
}

read_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(message("[read_data_server] - Starting read_data_server module"))

    # Create a reactive value to store status
    status <- reactiveVal("No file loaded")

    # Observe the uploading of file and read it
    read_data <- reactive({
      req(input$upload)

      # Update status and show notification
      status("Processing file...")

      status(paste("File loaded:", input$upload$name))
      showNotification(
        paste("Successfully loaded:", input$upload$name),
        type = "message"
      )

      message(paste("Pioreactor input OD file:", input$upload$datapath))
      raw_pio_od_data_to_wide_frame(input$upload$datapath)
    })

    # Render the status text
    output$status <- renderText({
      status()
    })

    reactive(message("[read_data_server] - Ending read_data_server module"))
    return(read_data)
  })
}
