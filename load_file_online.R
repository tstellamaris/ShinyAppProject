library(tidyverse)
library(readxl)
library(stringr)

# ********************************************************************************************************* # 
# The purpose of this script is to download the files from the website below to a folder called "/data/"    #
# inside of the Shiny App folder.                                                                           #
# Website: https://www.foreignlaborcert.doleta.gov/performancedata.cfm                                      #
# The files does not change frequently. So it is not necessary to run this script inside of the Shiny App.  #
#                                                                                                           #
# ********************************************************************************************************* #


# There is no pattern on the file url
# Vector of the url of each file to download them
urls = c("https://www.foreignlaborcert.doleta.gov/pdf/PerformanceData/2018/PERM_Disclosure_Data_FY2018_Q4_EOY.xlsx",
        "https://www.foreignlaborcert.doleta.gov/pdf/PerformanceData/2017/PERM_Disclosure_Data_FY17.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/Performance_Data/Disclosure/FY15-FY16/PERM_Disclosure_Data_FY16.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/py2015q4/PERM_Disclosure_Data_FY15_Q4.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/py2014q4/PERM_FY14_Q4.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/perm/PERM_FY2013.xlsx")


get_string <- function(str_pattern, str_string, str_split){
  # ***************************************************************************** #
  # Function to return the string that constains certain pattern ("str_pattern")  #
  # from an input string ("str_string") that is going to be split by "str_split"  #
  # Input 1: "str_pattern" -> String that contains the desire pattern             #
  # Input 2: "str_string" -> String where the desire string is                    #
  # Input 3: "str_split -> String that str_string is going to be split by         #
  # Return: String                                                                #
  # ***************************************************************************** #
  vec = strsplit(str_string, split = str_split)[[1]]
  if (str_pattern != ".xlsx"){
    vec = gsub(pattern = ".xlsx", replacement = "", x = vec)
  }
  return(vec[grep(str_pattern, vec)])
}


# Character with the name of the files that were downloaded to the data folder 
lst_fnames = character()


# For loop to download oll the files that is in the url vector
for (url in urls){
  destfile = get_string(".xlsx", url, "/")
  year = as.integer(paste0("20", str_sub(get_string("FY", destfile, "_"), start = -2)))
  dataset = tryCatch(
    {
      print(paste0("Downloading file of the year ", year))
      fname = paste0(year, ".xlsx")
      path = paste0("./data/", fname)
      download.file(url, path)
    },
    error = function(e){
      print(paste0("File of the year ", year, " does not exist"))
      NULL
    }
  )
  if (length(dataset) != 0){
    i = length(lst_fnames) + 1
    lst_fnames[i] = fname
  }
}


# Create a .txt file with the name of the files that were downloaded to the data folder
# This file is going to be used by the Shiny App to load the files locally
write(lst_fnames, "data/lst_fnames.txt")




