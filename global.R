## Load all libraries
library(shiny)
library(bslib)
library(stringr)
library(ggplot2)
library(gridExtra)
library(devtools)
library(zoo)
devtools::load_all("R")

## Source all modules
modules <- list.files("modules", pattern = "_module.R", full.names = TRUE)
sapply(modules, source)

## Set options
options(shiny.maxRequestSize = 100 * 1024^2) # Increase file size for uploads

## Global functions
# Workaround for Chromium Issue 468227
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}
