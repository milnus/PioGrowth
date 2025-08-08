# Function to take batch growth and extract growth parameters.
# A smooth spline and its derivative is used to extract growth parameters

spline_growth_integration_turbidostat <- function(
	split_od_data_list, # od_data_list
	n_bootstaps = 100,
	spline_smoothing = 1.0,
	reactor_name
) {
	# TODO - Implement that bootstrapping is a possibility
	message(paste("Processing Reactor:", reactor_name))

	#### Initialise lists ####
	growth_data_list <- list()

	growth_phases <- seq_along(split_od_data_list) # od_columns
	print(paste(
		"[spline_growth_integration_turbidostat] - Processing",
		length(growth_phases),
		"growth phases"
	))

	#### Loop through each reactor to find growth parameters####
	# for (description in names(growth_data)){
	for (col_i in growth_phases) {
		message(paste(
			"[spline_growth_integration_turbidostat] - Processing growth phase",
			col_i,
			"of",
			length(growth_phases)
		))

		if (nrow(split_od_data_list[[col_i]]) < 30) {
			message(paste(
				"[spline_growth_integration_turbidostat] - Reactor",
				reactor_name,
				"has less than 30 data points in growth phase",
				col_i,
				"- skipping this growth phase."
			))
			next # Skip this growth phase if it has less than 30 data points
		}

		## Construct list to hold growth data for each reactor
		reactor_growth_data_list <- list()

		mid_time_point <- max(
			split_od_data_list[[col_i]]$timestamp
		) -
			min(
				split_od_data_list[[col_i]]$timestamp
			) /
				2

		for (n_bootstap in 1:n_bootstaps) {
			#### Format data for spline analysis ####
			if (n_bootstaps == 1) {
				## Extract data with no sampling
				reactor_growth_data_list[[n_bootstap]] <- data.frame(
					"Time" = split_od_data_list[[col_i]][, "timestamp"],
					"OD_values" = split_od_data_list[[col_i]][, "od_reading"],
					"Reactor" = reactor_name
				)
			} else {
				## Extract data with sampling
				## Sample with replacement
				sampled_indices <- sample(
					1:nrow(split_od_data_list[[col_i]]),
					nrow(split_od_data_list[[col_i]]),
					replace = TRUE
				)
				## Sort the sampled indices to maintain order
				sampled_indices <- sort(sampled_indices)
				## Create a new data frame with sampled indices
				reactor_growth_data_list[[n_bootstap]] <- data.frame(
					"Time" = split_od_data_list[[col_i]][
						sampled_indices,
						"timestamp"
					],
					"OD_values" = split_od_data_list[[col_i]][
						sampled_indices,
						"od_reading"
					],
					"Reactor" = reactor_name
				)
			}

			# Transform OD values to log (taking ln(y/y0))
			reactor_growth_data_list[[n_bootstap]]$OD_values_log <- log(
				reactor_growth_data_list[[n_bootstap]]$OD_values /
					reactor_growth_data_list[[n_bootstap]]$OD_values[1]
			) +
				0.01 # Add a small constant to avoid log(0) issues

			#### Do spline analysis ####
			# Construct spline smoothing function
			smoothed_spline_function <- smooth.spline(
				reactor_growth_data_list[[n_bootstap]]$Time,
				reactor_growth_data_list[[n_bootstap]]$OD_values_log,
				cv = NA, # Skips cross validation and speeds things up
				spar = spline_smoothing
			)

			#### Get growth curve metrics ####
			# # Get the growth parameters for spline - 0th derivative
			# reactor_growth_data_list[[n_bootstap]]$Spline_OD <- predict(
			# 	smoothed_spline_function,
			# 	deriv = 0
			# )$y
			# Get the growth parameters for spline - 1st derivative
			Spline_growth_rate <- predict(
				smoothed_spline_function,
				deriv = 1
			)$y

			# reactor_growth_data_list[[
			# 	n_bootstap
			# ]]$Spline_OD_log <- reactor_growth_data_list[[
			# 	n_bootstap
			# ]]$Spline_OD
			# ## Convert spline from log(y/y0) to regular OD
			# reactor_growth_data_list[[n_bootstap]]$Spline_OD <- exp(
			# 	reactor_growth_data_list[[n_bootstap]]$Spline_OD_log
			# ) *
			# 	reactor_growth_data_list[[n_bootstap]]$OD_values[1]

			## Add bootstrap number to the data frame
			reactor_growth_data_list[[
				n_bootstap
			]]$bootstrap_rep <- as.numeric(
				n_bootstap
			)

			reactor_growth_data_list[[n_bootstap]] <- data.frame(
				"mu_max" = max(
					Spline_growth_rate
				),
				"Time_mu_max" = reactor_growth_data_list[[n_bootstap]]$Time[
					which.max(Spline_growth_rate) ## Get the halfway point of the growth curve
				],
				"growth_phase" = col_i,
				"reactor_name" = reactor_name,
				"time_point" = mid_time_point
			)
		} ## End of n_bootstaps loop
		# Combine all bootstrap data into a single data frame
		growth_data_list[[paste(reactor_name, col_i, sep = "_")]] <- do.call(
			"rbind",
			reactor_growth_data_list
		)
	} ## End of growth phases loop

	## Concatenate the growth data and set type of variables
	fitted_growth_data_return <- do.call("rbind", growth_data_list)
	fitted_growth_data_return$Time <- as.numeric(
		fitted_growth_data_return$Time_mu_max
	)

	return(fitted_growth_data_return)
}
