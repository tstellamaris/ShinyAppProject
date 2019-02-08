library(tidyverse)
library(readxl)

urls = c("https://www.foreignlaborcert.doleta.gov/pdf/PerformanceData/2018/PERM_Disclosure_Data_FY2018_Q4_EOY.xlsx",
        "https://www.foreignlaborcert.doleta.gov/pdf/PerformanceData/2017/PERM_Disclosure_Data_FY17.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/Performance_Data/Disclosure/FY15-FY16/PERM_Disclosure_Data_FY16.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/py2015q4/PERM_Disclosure_Data_FY15_Q4.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/py2014q4/PERM_FY14_Q4.xlsx",
        "https://www.foreignlaborcert.doleta.gov/docs/perm/PERM_FY2013.xlsx")

for (url in urls){
  vecfile = strsplit(urls[1], split = "/")[[1]]
  destfile = vecfile[grep('.xlsx', vecfile)]
  download.file(url, destfile)
  datasets = read_excel(destfile)
}