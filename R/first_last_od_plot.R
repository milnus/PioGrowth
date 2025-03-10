# Function to calculate innerquantile mean (IQM)
iqm <- function(x) {
  y <- mean(x[
    x >= quantile(x, 0.25) &
      x <= quantile(x, 0.75)
  ])
}

first_last_od_plot <- function(complete_calibration_data, x_pio_ods) {
  # Isolate the first and last od readings from reactors
  first_last_x_df <- complete_calibration_data$first_last_x_df

  # If no readings are given then return empty plot, else construct plot
  if (is.null(first_last_x_df)) {
    return(ggplot())
  } else {
    x_nudge <- 0.1

    p <- ggplot(first_last_x_df, aes(name, od_reading)) +
      geom_point(position = position_nudge(x = x_nudge)) +
      facet_grid(. ~ position)

    # Check if inner quartile mean or mean should be plotted
    if (x_pio_ods < 5) {
      p <- p +
        stat_summary(
          geom = "point",
          fun = "mean",
          colour = "red",
          shape = 16,
          position = position_nudge(x = -x_nudge)
        )
    } else {
      p <- p +
        stat_summary(
          geom = "point",
          fun = iqm,
          colour = "red",
          shape = 16,
          position = position_nudge(x = -x_nudge)
        )
    }

    return(p)
  }
}
