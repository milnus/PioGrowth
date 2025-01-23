# Load all libraries
library(shiny)
library(bslib)
library(stringr)
library(ggplot2)
library(gridExtra)
library(devtools)
devtools::load_all("R")

# Source all modules
source("modules/read_data_module.R")
source("modules/plot_raw_module.R")
source("modules/filter_reactor_module.R")
source("modules/calibration_module.R")

# Set options
options(shiny.maxRequestSize = 100 * 1024^2) # Increase file size for uploads
