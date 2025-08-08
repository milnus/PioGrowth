spline_outlier_detection <- function(
	od_data,
	outlier_df = NULL,
	input_df = 200
) {
	#### Function to use spline and residual statistics to identify outliers
	#### For each reactor identify outliers and add a column indicating these

	# Isolate od data
	od_columns <- 2:ncol(od_data)

	# Isolate predefined outlier data, if any
	if (is.null(outlier_df)) {
		outlier_df <- data.frame(matrix(
			data = FALSE,
			ncol = ncol(od_data),
			nrow = nrow(od_data)
		))
		# Insert time column
		outlier_df[, 1] <- od_data[, 1]
		# Give colnames
		colnames(outlier_df) <- colnames(od_data)
	}

	for (column_i in od_columns) {
		# Set any prevuous outliers to NA
		od_data[, column_i][outlier_df[, column_i]] <- NA

		# condense column for NA's
		data_oi <- od_data[, c(1, column_i)]
		data_oi <- data_oi[!is.na(data_oi[, 2]), ]

		# Construct a spline for the od values
		spline_regression <- smooth.spline(
			data_oi[, 1],
			data_oi[, 2],
			df = input_df,
			cv = FALSE
		)
		# Predict od values for fitted spline
		spline_od <- predict(spline_regression, deriv = 0)$y

		# Calculate residuals
		spline_residuals <- data_oi[, 2] - spline_od
		# Calculate mean and standard deviation of residuals
		mean_spline_od <- mean(spline_residuals)
		sd_spline_od <- sd(spline_residuals)

		# For each od value, check if it is an outlier
		for (row_i in 1:(nrow(data_oi))) {
			if (
				abs(spline_od[row_i] - data_oi[row_i, 2]) >
					mean_spline_od + 1.96 * sd_spline_od
			) {
				outlier_df[
					outlier_df[, 1] == data_oi[row_i, 1],
					column_i
				] <- TRUE
			}
		}
	}
	return(outlier_df)
}
