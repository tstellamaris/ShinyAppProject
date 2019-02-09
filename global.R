library(readxl)
library(dplyr)
setwd("~/Documents/NYCDSA/Bootcamp_Winter_2019/Project2-ShinyApp")

source("./clean_data.R")

dataset = data.frame()
lst_fnames = read.csv("./data/lst_fnames.txt", header = FALSE)[[1]]
for (fname in lst_fnames){
  path = paste0("./data/", fname)
  temp = data.frame(read_xlsx(path = path, sheet = 1, col_names = TRUE), stringsAsFactors = FALSE)
  temp = clean_df(temp)
  dataset = rbind(dataset, temp)
}
