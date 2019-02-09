setwd("~/Documents/NYCDSA/Bootcamp_Winter_2019/Project2-ShinyApp")
library(data.table)

fname = "all_data.csv"
path = paste0("./data/", fname)

main_df = fread(file = path)