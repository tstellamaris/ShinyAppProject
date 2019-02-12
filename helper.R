order_lst <- function(lis){
  lis = lis[order(lis)]
}

mutate_edu <- function(x){
  edu = c("High School", "Associate's", "Bachelor's", "Master's", "Doctorate", "Other")
  return (ifelse(!x %in% edu, "Other", x))
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


transf_state <- function(df){
  long_state = c("alabama", "alaska", "arizona", "arkansas", "california",
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
  short_state = c("al", "ak", "az", "ar", "ca",
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
  state_df = data.frame(short_state = toupper(short_state), 
                        long_state = sapply(long_state, capitalize, USE.NAMES = FALSE), 
                        stringsAsFactors = FALSE)
  df = df %>% 
    left_join(x = df, y = state_df, by = c("work_state" = "short_state"))
  return (df)
}

