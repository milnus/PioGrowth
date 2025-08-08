iqr_outlier_detection <- function(od_data) {
  # Set the width of the window to search and find center of the window
  k <- 31 # 21 also worked

  # Check that K is odd, so that it has a center point.
  if (k %% 2 == 0) {
    message("k cannot be even!")
    return()
  }

  # Find the columns that contain od data
  od_columns <- 2:ncol(od_data)

  outlier_df <- od_data
  for (column_i in od_columns) {
    outlier_df[, column_i] <- FALSE

    # condence column for NA's
    data_oi <- od_data[, c(1, column_i)]
    data_oi <- data_oi[!is.na(data_oi[, 2]), ]

    # add roll to find median and IQR
    median_roll <- zoo::rollapply(
      data_oi[, 2],
      align = "center",
      fill = NA,
      width = k,
      FUN = median,
      partial = T
    )
    iqr_roll <- zoo::rollapply(
      data_oi[, 2],
      align = "center",
      fill = NA,
      width = k,
      FUN = IQR,
      partial = T
    )

    for (row_i in 1:(nrow(data_oi))) {
      # Remove points 2.5 Inner Quartile Ranges above or below median
      if (
        data_oi[row_i, 2] > median_roll[row_i] + iqr_roll[row_i] * 1.5 | # 2.5 worked well- this was the previous
          data_oi[row_i, 2] < median_roll[row_i] - iqr_roll[row_i] * 1.5
      ) {
        outlier_df[outlier_df[, 1] == data_oi[row_i, 1], column_i] <- TRUE
      }
    }
  }
  return(outlier_df)
}
