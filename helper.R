order_lst <- function(lis){
  # ***************************************************************************** #
  # Order a list                                                                  #
  # Input: list                                                                   #
  # Return: list ordered                                                          #
  # ***************************************************************************** #
  lis = lis[order(lis)]
}

mutate_edu <- function(x){
  # ***************************************************************************** #
  # Padronize the education level (substitute every other content to "Other")     #
  # Input: content of the data frame                                              #
  # Return: content   padronized                                                  #
  # ***************************************************************************** #
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
  # ***************************************************************************** #
  # Left join the input data frame with the state data frame by the short name    #
  # of the state.                                                                 #
  # Input: data frame                                                             #
  # Return: data frame joined                                                     #
  # ***************************************************************************** #
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

