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

# Mutate data
main_df = main_df %>% 
  mutate(worker_education = sapply(worker_education, mutate_edu))

# Lists
visastatus = order_lst(unique(main_df$case_status))
education = order_lst(unique(main_df$worker_education))
#country = order_lst(unique(main_df$country_of_citizenship))
#state = order_lst(unique(main_df$work_state))
#company = order_lst(unique(main_df$employer_name))
#job_title = order_lst(unique(main_df$jobtitle))


# Variables
min_year = min(main_df$year)
max_year = max(main_df$year)

