
select_col <- function(df){
  # ***************************************************************************** #
  # Select the columns from the raw data that is relevant for the analysis        #
  # Input: raw data frame                                                         #
  # Return: data frame with the columns selected                                  #
  # ***************************************************************************** #
  
  # Vector with the desire columns
  col_sel = c("DECISION_DATE", 
              "CASE_STATUS",
              "CASE_RECEIVED_DATE", 
              "EMPLOYER_NAME", 
              "EMPLOYER_NUM_EMPLOYEES",
              "EMPLOYER_YR_ESTAB",
              "PW_SOC_TITLE",
              "PW_AMOUNT_9089",
              "PW_UNIT_OF_PAY_9089",
              "WAGE_OFFER_FROM_9089",
              "WAGE_OFFER_TO_9089",
              "WAGE_OFFER_UNIT_OF_PAY_9089",
              "JOB_INFO_WORK_CITY",
              "JOB_INFO_WORK_STATE",
              "JOB_INFO_JOB_TITLE",
              "JOB_INFO_EDUCATION",
              "JOB_INFO_MAJOR",
              "JOB_INFO_EXPERIENCE_NUM_MONTHS",
              "COUNTRY_OF_CITIZENSHIP",
              "CLASS_OF_ADMISSION",
              "FOREIGN_WORKER_INFO_EDUCATION",
              "FOREIGN_WORKER_INFO_MAJOR",
              "FW_INFO_YR_REL_EDU_COMPLETED",
              "FOREIGN_WORKER_INFO_INST",
              "NAICS_US_TITLE")
  df = df %>% 
    select(col_sel)
  colnames(df) = tolower(colnames(df))
  colnames(df) = gsub(colnames(df), pattern = "_9089", replacement = "")
  return (df)
}

mutate_df <- function(df){
  # ***************************************************************************** #
  # Mutate some columns from the raw data                                         #
  # Input: raw data frame                                                         #
  # Return: data frame with some columns mutated                                  #
  # ***************************************************************************** #
  df = df %>% 
    mutate(pw_unit_of_pay = remove_null(pw_unit_of_pay),
           wage_offer_unit_of_pay = remove_null(wage_offer_unit_of_pay),
           wage_offer_from = is.numeric(wage_offer_from),
           wage_offer_to = is.numeric(wage_offer_from),
           pw_amount = is.numeric(pw_amount),
           wage_offer_to = ifelse(is.na(wage_offer_to), wage_offer_from, wage_offer_to)
           )
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
  return (as.numeric(x))
}

set_date <- function(x, fmt){
  # ***************************************************************************** #
  # Change the class of the content to date                                       #
  # Input 1: content of the data frame                                            #
  # Input 2: format of the date                                                   #
  # Return: content as date                                                       #
  # ***************************************************************************** #
  return (as.Date(x, format = fmt))
}

set_char <- function(x){
  # ***************************************************************************** #
  # Change the class of the content to character                                  #
  # Input: content of the data frame                                              #
  # Return: content as character                                                  #
  # ***************************************************************************** #
  return (as.character(x))
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

clean_df <- function(df){
  # ***************************************************************************** #
  # Clean the data frame                                                          #
  # Input: raw data frame                                                         #
  # Return: data frame cleaned                                                    #
  # ***************************************************************************** #
  df = select_col(df)
  df = mutate_df(df)
  df = df %>% 
    transmute(decision_date = set_date(decision_date, "%Y-%m-%d"),
              case_received_date = set_date(case_received_date, "%Y-%m-%d"),
              days_to_decide = decision_date - case_received_date,
              case_status = set_char(remove_null(case_status)),
              employer_name = set_char(remove_null(employer_name)),
              employer_num_employees = set_numeric(remove_null(employer_num_employees)),
              employer_yr_estab = set_numeric(remove_null(employer_yr_estab)),
              pw_soc_title = set_char(remove_null(pw_soc_title)),
              pw_amount = sapply(pw_unit_of_pay, transf_yearly) * pw_amount,
              wage_offer_mean = (sapply(wage_offer_unit_of_pay, transf_yearly) * wage_offer_from / 2) +
                (sapply(wage_offer_unit_of_pay, transf_yearly) * wage_offer_to / 2),
              job_info_work_city = set_char(remove_null(job_info_work_city)),
              job_info_work_state = set_char(remove_null(job_info_work_state)),
              job_info_job_title = set_char(remove_null(job_info_job_title)),
              job_info_education = set_char(remove_null(job_info_education)),
              job_info_major = set_char(remove_null(job_info_major)),
              job_info_experience_num_months = set_numeric(remove_null(job_info_experience_num_months)),
              country_of_citizenship = set_char(remove_null(country_of_citizenship)),
              visa_type = set_char(remove_null(class_of_admission)),
              foreign_worker_info_education = set_char(remove_null(foreign_worker_info_education)),
              foreign_worker_info_major = set_char(remove_null(foreign_worker_info_major)),
              fw_info_yr_rel_edu_completed = set_numeric(remove_null(fw_info_yr_rel_edu_completed)),
              foreign_worker_info_inst = set_char(remove_null(foreign_worker_info_inst)),
              naics_us_title = set_char(remove_null(naics_us_title))
              )
  return (df)
}

