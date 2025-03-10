correct_neg_data_median <- function(od_data, outlier_df) {
  # Hanndle NA reading and add the outlier masking/removal
  # Set window to take median
  k_range <- 31
  k <- k_range %/% 2

  od_columns <- 2:ncol(od_data)

  od_data_neg_corrected <- od_data

  for (col_i in od_columns) {
    # Mask outliers
    od_data_neg_corrected[outlier_df[, col_i], col_i] <- NA
    # Get indexes of negative measurments
    neg_indexes <- which(od_data[, col_i] < 0)
    neg_indexes <- neg_indexes[!is.na(neg_indexes)]

    if (length(neg_indexes)) {
      od_data_neg_corrected[, col_i][neg_indexes] <-
        sapply(neg_indexes, function(i) {
          lower_bound <- i - k
          upper_bound <- i + k

          lower_bound <- ifelse(lower_bound > 0, lower_bound, 1)
          upper_bound <- ifelse(
            upper_bound > nrow(od_data),
            nrow(od_data),
            upper_bound
          )

          # Find the values in the range k
          k_values <- od_data[, col_i][lower_bound:upper_bound]
          # Find number of positive measurements in k values
          n_pos <- sum(k_values > 0, na.rm = TRUE)

          # if range is less than the specified expand until k positive values are reached
          while (n_pos < k_range) {
            k <- k + 1

            lower_bound <- i - k
            upper_bound <- i + k

            lower_bound <- ifelse(lower_bound > 0, lower_bound, 1)
            upper_bound <- ifelse(
              upper_bound > nrow(od_data),
              nrow(od_data),
              upper_bound
            )

            k_values <- od_data[, col_i][lower_bound:upper_bound]

            n_pos <- sum(k_values > 0, na.rm = TRUE)
          }

          # reset k
          k <- k_range %/% 2

          # Calculate the median
          median_k_value <- median(k_values[k_values > 0], na.rm = TRUE)

          return(median_k_value)
        })
    }
  }
  return(od_data_neg_corrected)
}
