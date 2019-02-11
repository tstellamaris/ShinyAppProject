## server.R ##

shinyServer(function(input, output){
  
  output$value <- renderPrint({ input$checkGroup })
  
  output$hist <- renderPlot({
    hist(main_df$year, col = 'darkgray', border = 'white')
  })
  
  # Map tab: Global map ####
  df_map_glob <- reactive({
    main_df %>%
      na.omit() %>%
      filter((worker_education %in% input$edu_map) & 
               (year >= input$year_map[1] & year <= input$year_map[2])) %>% 
      group_by(country_of_citizenship) %>% 
      summarise(n_app = n(), wage_offer = mean(wage_offer_mean)) %>% 
      mutate(perc_app = n_app/sum(n_app) * 100)
  })
  
  output$map_glob <- renderGvis({
    df = df_map_glob()
    gvisGeoChart(df,
                 "country_of_citizenship", 
                 ifelse(input$var_map == "Number of Applicants", "n_app", "wage_offer"),
                 options=list(width="auto", height="auto"))
  })
  
  # Map tab: USA map ####
  df_map_usa <- reactive({
    main_df %>%
      filter((worker_education %in% input$edu_map_usa) & 
               (year >= input$year_map_usa[1] & year <= input$year_map_usa[2]))
  })
  
  output$map_usa <- renderGvis({
    df = df_map_usa() %>% 
      na.omit() %>%
      group_by(work_state) %>% 
      summarise(n_app = n(), wage_offer = mean(wage_offer_mean)) %>% 
      mutate(perc_app = n_app/sum(n_app) * 100)
    gvisGeoChart(df,
                 "work_state", 
                 ifelse(input$var_map_usa == "Number of Applicants", "n_app", "wage_offer"),
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width="auto", height="auto"))
  })
  
})