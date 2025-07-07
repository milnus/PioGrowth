# Function for plotting all raw od readings from reactors
plot_raw_data <- function(raw_data, filter_vector, filt_strat) {
  # Check if input data in not given
  if (is.null(raw_data)) {
    return()
  }

  print("raw_data")
  print(raw_data)

  df_list <- sapply(
    2:ncol(raw_data),
    function(x) {
      data.frame(
        "timestamp" = raw_data[, 1],
        "od_reading" = raw_data[, x]
      )
    },
    simplify = FALSE
  )

  # Name the indexes of the list after rectors
  names(df_list) <- colnames(raw_data)[2:ncol(raw_data)]

  # Plot od over time for each reactor and save in a list of plots
  ind_plots <- sapply(
    seq_along(df_list),
    function(i) {
      plot_dataframe_raw(
        dataframe = df_list[[i]],
        name = names(df_list)[i],
        filter_vector = filter_vector,
        filt_strat = filt_strat
      )
    },
    simplify = FALSE
  )

  # Arrange the list of plots into a grid
  do.call(gridExtra::grid.arrange, c(ind_plots))
}
