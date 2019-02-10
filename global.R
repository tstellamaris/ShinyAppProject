# Install and Load Appropriate Packages
list.of.packages <- c("data.table", "shiny", "ggplot2", "dplyr", "rgdal", "leaflet", "RColorBrewer", "googleVis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages)

lapply(list.of.packages, require, character.only = TRUE)

# Read functions script
source("./helper.R")

# Load the data locally
fname = "all_data.csv"
path = paste0("./data/", fname)
main_df = fread(file = path)

# Lists
visastatus = order_lst(unique(main_df$case_status))
#country = order_lst(unique(main_df$country_of_citizenship))
#state = order_lst(unique(main_df$work_state))
#company = order_lst(unique(main_df$employer_name))
#job_title = order_lst(unique(main_df$jobtitle))


