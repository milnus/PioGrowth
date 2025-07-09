read_dosing_automation_events_data <- function(
	od_readings_csv,
	dosing_automation_events_csv
) {
	## dosing_automation_events file contains only what may be a summary of the dilution event of the Pio reactor
	## dosing_events file contain all additions and removals of media events.

	## Read the first lines of the od file to find the first time a/all reactors to align the dosing events
	od_data <- data.table::fread(od_readings_csv, nrows = 20)

	# od_data <- od_data[!duplicated(od_data$pioreactor_unit),]

	## Read the dosing events file
	dosing_event_data <- data.table::fread(
		dosing_automation_events_csv,
		header = TRUE
	)

	## Check if the dosing_event_data has rows
	if (nrow(dosing_event_data) == 0) {
		message(
			"[read_dosing_automation_events_data] - No dosing automation events data found."
		)
		return(NULL)
	}

	## Calculate hours for events
	dosing_event_data$hours <- difftime(
		dosing_event_data$timestamp_localtime,
		min(od_data$timestamp_localtime),
		units = 'hours'
	)

	## Round ours to 3 decimal places
	dosing_event_data$hours <- round(dosing_event_data$hours, 3)

	## Isolate DilutionEvent
	dosing_event_data <- dosing_event_data[
		grepl("DilutionEvent", dosing_event_data$event_name),
	]

	## Return NULL if no DilutionEvent found
	if (nrow(dosing_event_data) == 0) {
		message(
			"[read_dosing_automation_events_data] - No DilutionEvent found in dosing automation events data."
		)
		return(NULL)
	}

	return(dosing_event_data[, c("pioreactor_unit", "hours")])
}
