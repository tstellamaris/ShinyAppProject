order_lst <- function(lis){
  lis = lis[order(lis)]
}

mutate_edu <- function(x){
  edu = c("High School", "Associate's", "Bachelor's", "Master's", "Doctorate", "Other")
  return (ifelse(!x %in% edu, "Other", x))
}

