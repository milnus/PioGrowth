batch_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
	actionButton(ns("process_batch"), "Process data batch growth"),
  )
}

batch_analysis_server <- function(id, od_data_list) {
  moduleServer(id, function(input, output, session) {
	# Observe process button
    reactor_groups <- eventReactive(input$process_batch, {
    TRUE
  })

  observe(message(paste("[batch_analysis_server] - Start processing as batch:", reactor_groups())))
  })

}