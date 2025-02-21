# Function to take batch growth and extract growth parameters. 
# A smooth spline and its derivative is used to extract growth parameters

spline_growth_integration <- function(od_data_list, bootstaps = 0, spline_smoothing = 1.0){
  # TODO - Implement that boot strapping is a possibility

  #### Initialise lists ####
  growth_data_list <- list()

  od_columns <- 2:ncol(od_data_list[["negative_corrected"]])

  #### Loop through each reactor to find growth parameters####
  # for (description in names(growth_data)){
  for (col_i in od_columns){
    reactor_name <- gsub("od_reading\\.", "",
                               colnames(od_data_list[["negative_corrected"]])[col_i])

    message(paste("Processing Reactor:", reactor_name))

    #### Format data for spline analysis ####
    # Extract relevant data
    growth_data_list[[reactor_name]] <- data.frame("Time" = od_data_list[["negative_corrected"]][, 1],
                                                "OD_values" = od_data_list[["negative_corrected"]][, col_i],
                                                "Reactor" = reactor_name)

	# Mask removed outliers
	growth_data_list[[reactor_name]] <- growth_data_list[[reactor_name]][!od_data_list[["outliers"]][, col_i], ]

	# Remove NA values
	growth_data_list[[reactor_name]] <- growth_data_list[[reactor_name]][!is.na(growth_data_list[[reactor_name]]$OD_values), ]


    # Transform OD values to log (taking ln(y/y0))
    growth_data_list[[reactor_name]]$OD_values_log = log(growth_data_list[[reactor_name]]$OD_values/growth_data_list[[reactor_name]]$OD_values[1]) + 0.01

    #### Do spline analysis ####
    # Construct spline smoothing function
    smoothed_spline_function <- smooth.spline(growth_data_list[[reactor_name]]$Time,
                                              growth_data_list[[reactor_name]]$OD_values_log,
                                              cv = NA, # Skips cross validation and speeds things up
                                              spar = spline_smoothing)

    #### Get growth curve metrics ####
    # Get the growth parameters for spline - 0th derivative
    growth_data_list[[reactor_name]]$Spline_OD <- predict(smoothed_spline_function, deriv = 0)$y
    # Get the growth parameters for spline - 1st derivative
    growth_data_list[[reactor_name]]$Spline_growth_rate <- predict(smoothed_spline_function, deriv = 1)$y

    growth_data_list[[reactor_name]]$Spline_OD_log <- growth_data_list[[reactor_name]]$Spline_OD
    # Convert spline from log(y/y0) to regular OD
    growth_data_list[[reactor_name]]$Spline_OD <- exp(growth_data_list[[reactor_name]]$Spline_OD_log) * growth_data_list[[reactor_name]]$OD_values[1]

	# Increment progress
	 incProgress(amount = 1 / length(od_columns))
  }

  # Concatenate the growth data and set type of variables
  fitted_growth_data_return <- do.call("rbind", growth_data_list)
  fitted_growth_data_return$Time <- as.numeric(fitted_growth_data_return$Time)

  return(fitted_growth_data_return)
}