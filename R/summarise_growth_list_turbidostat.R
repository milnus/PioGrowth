# Summarise mean and intervals for growth
summarise_growth_list_turbidostat <- function(growth_list, plot_data = F) {
	return_growth_list <- list()
	# Go through each list of reactors
	for (reactor in (1:length(growth_list))) {
		# Calculate statistics for growth curves
		mu_mean <- aggregate.data.frame(
			growth_list[[reactor]]$mu_max,
			by = list(growth_list[[reactor]]$growth_phase),
			mean
		)
		mu_median <- aggregate.data.frame(
			growth_list[[reactor]]$mu_max,
			by = list(growth_list[[reactor]]$growth_phase),
			median
		)
		mu_lower_bound <- aggregate.data.frame(
			growth_list[[reactor]]$mu_max,
			by = list(growth_list[[reactor]]$growth_phase),
			function(x) quantile(x, 0.025, na.rm = T)
		) #*** Use the bootstarp confidence intervall instead of sd
		mu_upper_bound <- aggregate.data.frame(
			growth_list[[reactor]]$mu_max,
			by = list(growth_list[[reactor]]$growth_phase),
			function(x) quantile(x, 0.975, na.rm = T)
		) #*** Use the bootstarp confidence intervall instead of sd
		mu_sd <- aggregate.data.frame(
			growth_list[[reactor]]$mu_max,
			by = list(growth_list[[reactor]]$growth_phase),
			sd
		) #*** Use the bootstarp confidence intervall instead of sd

		## Summarise data into table
		growth_df <- data.frame(
			'Time_point' = unique(
				growth_list[[reactor]]$time_point
			),
			'Mean_mu' = mu_mean[, 2],
			'Median_mu' = mu_median[, 2],
			'SD_mu' = mu_sd[, 2],
			'Boot_low_bound' = mu_lower_bound[, 2],
			'Boot_upper_bound' = mu_upper_bound[, 2],
			"Reactor" = names(growth_list)[reactor]
		)

		return_growth_list[[names(growth_list)[reactor]]] <- growth_df
	}

	
	bound_list <- do.call('rbind', return_growth_list)
	

	# bound_list$reactor <- unlist(sapply(1:length(return_growth_list), function(x) rep(names(return_growth_list)[x], nrow(return_growth_list[[x]]))))
	# bound_list$reactor <- gsub("\\..*", "", rownames(bound_list))

	if (plot_data == T) {
		ggplot(bound_list, aes(time_point, mean_mu, group = reactor)) +
			geom_line() +
			facet_wrap(. ~ reactor)
	}

	bound_list <- bound_list[!is.na(bound_list$Time_point), ]

	print("RETURN - bound_list")
	return(bound_list)
}
