#====== Awesome Survey Docking File======#

# Library Load-in
library(tidyverse) # For everything data
library(googlesheets4) # For interacting with Google Drive
library(janitor) # To keep things clean

# Data Process Checks====
#Program will check to see if any updates were made to the file after the first time it's ran during testing#
#If new data is found, a separate processing script is launched#

data_updated <- FALSE

#Data Load in====
Mainspreadsheet <- "https://docs.google.com/spreadsheets/d/1qmnQFRJIXdNw8DbnpP0Z1v615WlCtexffd3Es-vK7wg/edit?resourcekey#gid=686346796"

#Halting script to confirm Google Authentication===
#First time running on the system and not authenticated, will need to run gs4_auth() by itself first# 
#to get Google to pop up in a browser for initial authentication#
invisible(readline(prompt=c(gs4_auth(), "Press ENTER to confirm selection")))

#Spreadsheet being pulled into the environment===
new_data <- read_sheet(Mainspreadsheet, sheet = "Version 1" ) %>%
  select(c(2:4,6,7))

#Pulling in "Master" file to scan for any changes===
master_data <- readRDS("data/master_data.rds")

#Data "Validation"====
# Weak but quick "validation" to check for number of rows in "new" data compared to "master" data===
data_updated <- nrow(new_data) != nrow(master_data) 

# If data has changed, a separate processing program is launched. and a new master file is saved once it completes===
if(data_updated){
  source("scripts/processing_script.R")
}

# Pipelne returns to the dock and launches a new script to make visuals if the data was updated===

#Visual Creation====
if(data_updated){
  source("scripts/viz_script.R")
}

# Pipeline returns to the dock and renders the associated Markdown report
rmarkdown::render("reports/example_report.Rmd",
                  output_file = "example_report.html")

