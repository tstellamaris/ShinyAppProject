library(data.table)
library(shiny)
library(ggplot2)
library(dplyr)
library(rgdal)
library(leaflet)
library(RColorBrewer)
library(googleVis)
library(ggthemes)

# Read functions script
source("./helper.R")

# Load the data locally
fname = "all_data.csv"
path = paste0("./data/", fname)
main_df = fread(file = path)

# Mutate data
main_df = main_df %>% 
  mutate(worker_education = sapply(worker_education, mutate_edu)) %>% 
  transf_state()


# Lists
visastatus = order_lst(unique(main_df$case_status))
education = c("High School", "Associate's", "Bachelor's", "Master's", "Doctorate", "Other")
country = order_lst(unique(main_df$country_of_citizenship))
state = order_lst(unique(main_df$long_state))

# Variables
min_year = min(main_df$year)
max_year = max(main_df$year)

