split_turbidostat_data <- function(
	od_data,
	dosing_automation_events,
	outlier_data
) {
	## Expected return is a list of lists with data frames
	## Each list contains data frames for each segment of the spline
	## Each data frame contains 'timestamp' and 'od_reading' columns
	## The first list is names as per the bioreactor unit
	## The second list is names as per the segment id

	## Mask outlier data
	od_data_outliers_masked <- od_data[, -1]
	od_data_outliers_masked[as.matrix(outlier_data[, -1])] <- NA
	od_data_outliers_masked <- cbind.data.frame(
		"hours" = od_data[, 1],
		od_data_outliers_masked
	)

	## Split the of each reactor based on Dilution Events
	split_reactor_data <- list()

	for (i in 2:ncol(od_data_outliers_masked)) {
		## Isolate timestamps and OD values
		reactor_df <- od_data_outliers_masked[, c(1, i)]

		## Rename columns
		colnames(reactor_df) <- c("timestamp", "od_reading")

		## Remove NA values (non-observed and outliers)
		reactor_df <- reactor_df[!is.na(reactor_df[, "od_reading"]), ]

		## Isolate the reactor name
		reactor_name <- colnames(outlier_data)[i]
		reactor_name <- gsub("od_reading\\.", "", reactor_name)

		## Isolate the dilution events for the reactor
		reactor_dosing_times <- as.vector(
			dosing_automation_events[
				dosing_automation_events$pioreactor_unit == reactor_name,
				2
			],
			mode = "numeric"
		)

		## Split data based on dosing events
		# Use cut to assign group labels based on breaks
		reactor_df$group <- cut(
			reactor_df$timestamp,
			breaks = c(-Inf, reactor_dosing_times, Inf),
			labels = FALSE,
			right = TRUE
		)

		# Split into a list of data.frames
		split_list <- split(
			reactor_df[, c("timestamp", "od_reading")],
			reactor_df$group
		)

		split_list <- lapply(
			split_list,
			function(x) {
				rownames(x) <- NULL
				return(x)
			}
		)

		split_reactor_data[[reactor_name]] <- split_list
	}

	return(split_reactor_data)
}
