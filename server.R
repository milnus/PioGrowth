server <- function(input, output, session) {
  read_data <- read_data_server("read_data")

  filter_data <- filter_reactors_server("filter_reactors", read_data)

  plot_raw_server("raw_data_plot", read_data, filter_data)

  calibration_server("calibration_process", read_data)
}