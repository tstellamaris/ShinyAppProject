setwd("~/Documents/NYCDSA/Bootcamp_Winter_2019/Project2-ShinyApp")
library(readxl)
library(dplyr)
library(mgsub)


# ********************************************************************************************************* # 
# This script is clean the raw data, concatenate all files and save it as a unique csv file.                #
# This file is going to be load at the Shiny App.                                                           #
# The purpose of this step is to load the data quicker when the user opens the Shiny App.                   #
#                                                                                                           #
# ********************************************************************************************************* #


mutate_df <- function(df){
  # ***************************************************************************** #
  # Mutate some columns from the raw data                                         #
  # Input: raw data frame                                                         #
  # Return: data frame with some columns mutated                                  #
  # ***************************************************************************** #
  unincorporsted_ter = c("puerto rico", "pr", "guam", "gu", "virgin islands", "vi", 
                         "mh", "northern mariana islands", "marshall islands", 
                         "federated states of micronesia")
  colnames(df) = tolower(colnames(df))
  colnames(df) = gsub(colnames(df), pattern = "_9089", replacement = "")
  df = df %>% 
    mutate(pw_unit_of_pay = remove_null(pw_unit_of_pay),
           job_info_work_state = set_char(job_info_work_state),
           wage_offer_unit_of_pay = remove_null(wage_offer_unit_of_pay),
           wage_offer_from = set_numeric(wage_offer_from),
           wage_offer_to = set_numeric(wage_offer_to),
           pw_amount = set_numeric(pw_amount),
           wage_offer_to = ifelse(is.na(wage_offer_to), wage_offer_from, wage_offer_to)
           )
  unincorporated_ter = c("puerto rico", "pr", "guam", "gu", "virgin islands", "vi", 
                         "mh", "northern mariana islands", "marshall islands", 
                         "federated states of micronesia")
  # Remove the lines where thw state of work is an unincorporated territorie
  df = df %>% 
    filter(!(job_info_work_state %in% unincorporated_ter))
  return (df)
}

remove_null <- function(x){
  # ***************************************************************************** #
  # Replace the string "NULL" to NA                                               #
  # Input: content of the data frame                                              #
  # Return: NA if the content is "NULL" or the content if not                     #
  # ***************************************************************************** #
  return (ifelse(x == "NULL", NA, x))
}

set_numeric <- function(x){
  # ***************************************************************************** #
  # Change the class of the content to numeric                                    #
  # Input: content of the data frame                                              #
  # Return: content as numeric                                                    #
  # ***************************************************************************** #
  gsub(pattern = ",", replacement = "", x = x) %>% 
    remove_null() %>% 
    as.numeric()
}

set_date <- function(x, fmt){
  # ***************************************************************************** #
  # Change the class of the content to date                                       #
  # Input 1: content of the data frame                                            #
  # Input 2: format of the date                                                   #
  # Return: content as date                                                       #
  # ***************************************************************************** #
  as.Date(x, format = fmt)
}

set_char <- function(x){
  # ***************************************************************************** #
  # Change the class of the content to character                                  #
  # Input: content of the data frame                                              #
  # Return: content as character                                                  #
  # ***************************************************************************** #
  tolower(x) %>% 
    remove_null() %>% 
    as.character()
}

capitalize <- function(x) {
  # ***************************************************************************** #
  # Capitalize the first letter of each word                                      #
  # Input: content of the data frame                                              #
  # Return: content capitalized                                                   #
  # ***************************************************************************** #
  x <- strsplit(x, " ")[[1]]
  return (paste(toupper(substring(x, 1,1)), substring(x, 2), sep="", collapse=" "))
}

transf_yearly <- function(freq){
  # ***************************************************************************** #
  # Find the factor to multiply by to get the amount yearly                       #
  # Input: frequency of the payment                                               #
  # Return: factor to multiply by                                                 #
  # ***************************************************************************** #
  if (is.na(freq)){
    return (NA)
  } else if (freq == "Year"){
    return (1)
  } else if (freq == "Month"){
    return (12)
  } else if (freq == "Bi-Weekly"){
    return (26)
  } else if (freq == "Week"){
    return (52)
  } else if (freq == "Hour"){
    return (2080)
  }
}


transf_state <- function(state){
  # ***************************************************************************** #
  # Tansform the state name from short name to long nome                          #
  # Input: state short name                                                       #
  # Return: state long name                                                       #
  # ***************************************************************************** #
  long_name = c("alabama", "alaska", "arizona", "arkansas", "california",
                "colorado", "connecticut", "delaware", "florida", "georgia", 
                "hawaii", "idaho", "illinois", "indiana", "iowa",
                "kansas", "kentucky", "louisiana", "maine", "maryland",
                "massachusetts", "michigan", "minnesota", "mississippi", "missouri",
                "montana", "nebraska", "nevada", "new hampshire", "new jersey",
                "new mexico", "new york", "north carolina", "north dakota", "ohio",
                "oklahoma", "oregon", "pennsylvania", "rhode island", "south carolina",
                "south dakota", "tennessee", "texas", "utah", "vermont",
                "virginia", "washington", "west virginia", "wisconsin", "wyoming",
                "district of columbia")
  short_name = c("al", "ak", "az", "ar", "ca",
                 "co", "ct", "de", "fl", "ga",
                 "hi", "id", "il", "in", "ia",
                 "ks", "ky", "la", "me", "md",
                 "ma", "mi", "mn", "ms", "mo",
                 "mt", "ne", "nv", "nh", "nj",
                 "nm", "ny", "nc", "nd", "oh",
                 "ok", "or", "pa", "ri", "sc",
                 "sd", "tn", "tx", "ut", "vt",
                 "va", "wa", "wv", "wi", "wy",
                 "dc")
  return (mgsub(string = state, pattern = long_name, replacement = short_name))
}


clean_df <- function(df){
  # ***************************************************************************** #
  # Clean the data frame                                                          #
  # Input: raw data frame                                                         #
  # Return: data frame cleaned                                                    #
  # ***************************************************************************** #
  df = mutate_df(df)
  df = df %>% 
    transmute(decision_date = set_date(decision_date, "%Y-%m-%d"),
              case_received_date = set_date(case_received_date, "%Y-%m-%d"),
              days_to_decide = decision_date - case_received_date,
              year = format(decision_date, "%Y"),
              case_status = sapply(set_char(case_status), capitalize),
              employer_name = sapply(set_char(employer_name), capitalize),
              employer_num_employees = set_numeric(employer_num_employees),
              employer_yr_estab = set_numeric(employer_yr_estab),
              job_title = set_char(pw_soc_title),
              pw_amount = sapply(pw_unit_of_pay, transf_yearly) * pw_amount,
              wage_offer_mean = (sapply(wage_offer_unit_of_pay, transf_yearly) * wage_offer_from / 2) +
                (sapply(wage_offer_unit_of_pay, transf_yearly) * wage_offer_to / 2),
              work_city = set_char(job_info_work_city),
              work_state = toupper(sapply(set_char(job_info_work_state), transf_state)),
              job_info_job_title = set_char(job_info_job_title),
              job_info_education = sapply(set_char(job_info_education), capitalize),
              job_info_major = set_char(job_info_major),
              job_info_experience_num_months = set_numeric(job_info_experience_num_months),
              country_of_citizenship = sapply(set_char(country_of_citizenship), capitalize),
              visa_type = toupper(set_char(class_of_admission)),
              worker_education = sapply(set_char(foreign_worker_info_education), capitalize),
              worker_major = set_char(foreign_worker_info_major),
              worker_edu_year = set_numeric(fw_info_yr_rel_edu_completed),
              worker_college = sapply(set_char(foreign_worker_info_inst), capitalize),
              industry = set_char(naics_us_title)
              )
  return (df)
}

# Reading each file and cleaning the data
dataset = data.frame()
lst_fnames = read.csv("./data/lst_fnames.txt", header = FALSE)[[1]]
for (fname in lst_fnames){
  print(paste0("Loading file ", fname))
  path = paste0("./data/", fname)
  temp = data.frame(read_xlsx(path = path, sheet = 1, col_names = TRUE), stringsAsFactors = FALSE)
  temp = clean_df(temp)
  dataset = rbind(dataset, temp)
}

# Export the final data frame to a csv file.
# Shiny App is using this file.
write.csv(dataset, "./data/all_data.csv", row.names = FALSE)



