ui_num_od_read <- function(ns) {
  out_ui <- numericInput(
    inputId = ns("x_pio_ods"),
    label = "Number of first and last PioReactor OD readings to use for calibration",
    value = 10,
    min = 1,
    max = 50
  )
  return(out_ui)
}
