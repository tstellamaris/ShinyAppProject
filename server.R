## server.R ##

shinyServer(function(input, output){
  # Chart tab: Visa graph ####
  
  df_visa_g <- reactive({
    main_df %>%
      na.omit() %>%
      filter((worker_education %in% input$edu_vis) & 
              (case_status %in% input$visastatus) & year > 2014)
  })
  
  output$visa_g <- renderPlot({
    df_visa_g = df_visa_g()
    ggplot(df_visa_g, aes(x = year)) +
      geom_bar(fill = "#6dacdb") +
      labs(x='Year',
           y='Number of Applicants') +
      ylim(0,70000) +
      theme_bw()
  })
  
  # Chart tab: Companies graph ####
  df_comp_comp <- reactive({
    if (input$com_name != "" & input$job_title != ""){
      if (input$var_comp == "Number of Applicants"){
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                   grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
          group_by(employer_name) %>%
          summarise(vari = n()) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      } else {
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                   grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
          group_by(employer_name) %>%
          summarise(vari = mean(wage_offer_mean)) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      }
    } else if (input$com_name != "" & input$job_title == ""){
      if (input$var_comp == "Number of Applicants"){
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$com_name), tolower(employer_name))) %>% 
          group_by(employer_name) %>%
          summarise(vari = n()) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      } else {
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$com_name), tolower(employer_name))) %>% 
          group_by(employer_name) %>%
          summarise(vari = mean(wage_offer_mean)) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      }
    } else if (input$com_name == "" & input$job_title != ""){
      if (input$var_comp == "Number of Applicants"){
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
          group_by(employer_name) %>%
          summarise(vari = n()) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      } else {
        main_df %>%
          na.omit() %>%
          filter(grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
          group_by(employer_name) %>%
          summarise(vari = mean(wage_offer_mean)) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      }
    } else {
      if (input$var_comp == "Number of Applicants"){
        main_df %>%
          na.omit() %>%
          group_by(employer_name) %>%
          summarise(vari = n()) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      } else {
        main_df %>%
          na.omit() %>%
          group_by(employer_name) %>%
          summarise(vari = mean(wage_offer_mean)) %>%
          arrange(desc(vari)) %>%
          top_n(10, vari)
      }
    }
  })

   output$comp_comp <- renderPlot({
     df_comp_comp = df_comp_comp()
     ggplot(df_comp_comp, aes(x = reorder(employer_name, vari), y = vari)) +
       geom_bar(stat = "identity", fill = "#6dacdb") +
       labs(x='Company Name',
            y=input$var_comp) +
       theme_bw() +
       coord_flip()
   })
  
   # Chart tab: Job title graph ####
   df_comp_job <- reactive({
     if (input$com_name != "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = n()) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = mean(wage_offer_mean)) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       }
     } else if (input$com_name != "" & input$job_title == ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = n()) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = mean(wage_offer_mean)) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       }
     } else if (input$com_name == "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = n()) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(job_info_job_title) %>%
           summarise(vari = mean(wage_offer_mean)) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       }
     } else {
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           group_by(job_info_job_title) %>%
           summarise(vari = n()) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       } else {
         main_df %>%
           na.omit() %>%
           group_by(job_info_job_title) %>%
           summarise(vari = mean(wage_offer_mean)) %>%
           arrange(desc(vari)) %>%
           top_n(10, vari)
       }
     }
   })
   
   output$comp_job <- renderPlot({
     df_comp_job = df_comp_job()
     ggplot(df_comp_job, aes(x = reorder(job_info_job_title, vari), y = vari)) +
       geom_bar(stat = "identity", fill = "#6dacdb") +
       labs(x='Job Title',
            y=input$var_comp) +
       theme_bw() +
       coord_flip()
   })
   
   # Chart tab: Education level graph ####
   df_comp_edu <- reactive({
     if (input$com_name != "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title)) &
                    job_info_education %in% education) %>% 
           group_by(job_info_education) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title)) &
                    job_info_education %in% education)
       }
     } else if (input$com_name != "" & input$job_title == ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    job_info_education %in% education) %>% 
           group_by(job_info_education) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    job_info_education %in% education)
       }
     } else if (input$com_name == "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title)) &
                    job_info_education %in% education) %>% 
           group_by(job_info_education) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title)) &
                    job_info_education %in% education)
       }
     } else {
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(job_info_education %in% education) %>% 
           group_by(job_info_education) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>% 
           filter(job_info_education %in% education)
       }
     }
   })
   
   output$comp_edu <- renderPlot({
     df_comp_edu = df_comp_edu()
     if (input$var_comp == "Number of Applicants"){
       ggplot(df_comp_edu, aes(x = reorder(job_info_education, -vari), y = vari)) +
         geom_bar(stat = "identity", fill = "#6dacdb") +
         labs(x='Education Level',
              y=input$var_comp) +
         theme_bw()
     } else {
       ggplot(df_comp_edu, aes(x = reorder(job_info_education, wage_offer_mean, median), y = wage_offer_mean)) +
         geom_boxplot() +
         labs(x='Education Level',
              y=input$var_comp) +
         theme_bw()
     }
   })
   
   # Chart tab: Visa type graph ####
   df_comp_visa <- reactive({
     if (input$com_name != "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(visa_type) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)) &
                    grepl(tolower(input$job_title), tolower(job_info_job_title)))
       }
     } else if (input$com_name != "" & input$job_title == ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name))) %>% 
           group_by(visa_type) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$com_name), tolower(employer_name)))
       }
     } else if (input$com_name == "" & input$job_title != ""){
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title))) %>% 
           group_by(visa_type) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit() %>%
           filter(grepl(tolower(input$job_title), tolower(job_info_job_title)))
       }
     } else {
       if (input$var_comp == "Number of Applicants"){
         main_df %>%
           na.omit() %>%
           group_by(visa_type) %>%
           summarise(vari = n())
       } else {
         main_df %>%
           na.omit()
       }
     }
   })
   
   output$comp_visa <- renderPlot({
     df_comp_visa = df_comp_visa()
     if (input$var_comp == "Number of Applicants"){
       ggplot(df_comp_visa, aes(x = reorder(visa_type, vari), y = vari)) +
         geom_bar(stat = "identity", fill = "#6dacdb") +
         labs(x='Visa Type',
              y=input$var_comp) +
         theme_bw() +
         coord_flip()
     } else {
       ggplot(df_comp_visa, aes(x = reorder(visa_type, wage_offer_mean, median), y = wage_offer_mean)) +
         geom_boxplot() +
         labs(x='Visa Type',
              y=input$var_comp) +
         theme_bw()
     }
   })
   
  # Map tab: Global map ####
  df_map_glob <- reactive({
    main_df %>%
      na.omit() %>%
      filter((worker_education %in% input$edu_map) & 
               (year >= input$year_map[1] & year <= input$year_map[2])) %>% 
      group_by(country_of_citizenship) %>% 
      summarise(n_app = n(), wage_offer = mean(wage_offer_mean))
  })
  
  output$map_glob <- renderGvis({
    df_map_glob = df_map_glob()
    gvisGeoChart(df_map_glob,
                 "country_of_citizenship", 
                 ifelse(input$var_map == "Number of Applicants", "n_app", "wage_offer"),
                 options=list(width="auto", height="auto", 
                              gvis.listener.jscode = "var text = data.getValue(chart.getSelection()[0].row,0);Shiny.onInputChange('text', text.toString());"))
  })
  
  # Statistical Information: Global ####
   output$dtselect <- renderText({input$text})
  
  df_box_glob_click <- reactive({
    tryCatch({
      main_df %>%
        na.omit() %>%
        filter((worker_education %in% input$edu_map) &
                 (year >= input$year_map[1] & year <= input$year_map[2]) &
                 country_of_citizenship == input$text) %>%
        group_by(employer_name, job_info_job_title) %>%
        summarise(n_app = n(), max_wage_offer = max(wage_offer_mean), min_wage_offer = min(wage_offer_mean))
    }, error=function(e) {
      main_df %>%
        na.omit() %>%
        filter((worker_education %in% input$edu_map) &
                 (year >= input$year_map[1] & year <= input$year_map[2])) %>%
        group_by(employer_name, job_info_job_title) %>%
        summarise(n_app = n(), max_wage_offer = max(wage_offer_mean), min_wage_offer = min(wage_offer_mean))
    })
  })
  
  output$max_box_gl <- renderInfoBox({
    df_box_glob = df_box_glob_click()
    max_value = max(df_box_glob[,4])
    max_job_title <- 
      df_box_glob$job_info_job_title[df_box_glob[,4]==max_value]
    infoBox(max_job_title, max_value, icon = icon("hand-o-up"))
  })
  
  output$min_box_gl <- renderInfoBox({
    df_box_glob = df_box_glob_click()
    min_value <- min(df_box_glob[,5])
    min_job_title <- 
      df_box_glob$job_info_job_title[df_box_glob[,5]==min_value]
    infoBox(min_job_title, min_value, icon = icon("hand-o-down"))
  })
  
  
  
  # Pie Chart: Global ####
  # 
  # df_pie_glob <- reactive({
  #   if (input$text == ""){
  #     if (input$var_map == "Number of Applicants"){
  #       main_df %>%
  #         na.omit() %>%
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = n()) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     } else {
  #       main_df %>%
  #         na.omit() %>%
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = mean(wage_offer_mean)) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     }
  #   } else {
  #     if (input$var_map == "Number of Applicants"){
  #       main_df %>%
  #         na.omit() %>%
  #         filter(country_of_citizenship == input$text) %>% 
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = n()) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     } else {
  #       main_df %>%
  #         na.omit() %>%
  #         filter(country_of_citizenship == input$text) %>% 
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = mean(wage_offer_mean)) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     }
  #   }
  # })
  # 
  # output$pie_glob <- renderPlot({
  #   df_pie_glob = df_pie_glob()
  #   ggplot(data2, aes(x = 1, y = vari)) +
  #     geom_bar(aes(fill = job_info_job_title), stat = "identity") +
  #     coord_polar(theta = "y") +
  #     labs(x='Job Title',
  #          y=input$var_map) +
  #     scale_fill_discrete(name = "Job Title") +
  #     theme_bw() 
  # })
  

  
  # Map tab: USA map ####
  df_map_usa <- reactive({
    main_df %>%
      filter((worker_education %in% input$edu_map_usa) & 
               (year >= input$year_map_usa[1] & year <= input$year_map_usa[2]))
  })
  
  output$map_usa <- renderGvis({
    df_map_usa = df_map_usa() %>% 
      na.omit() %>%
      group_by(long_state) %>% 
      summarise(n_app = n(), wage_offer = mean(wage_offer_mean))
    gvisGeoChart(df_map_usa,
                 "long_state", 
                 ifelse(input$var_map_usa == "Number of Applicants", "n_app", "wage_offer"),
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width="auto", height="auto",
                              gvis.listener.jscode = "var text = data.getValue(chart.getSelection()[0].row,0);Shiny.onInputChange('text2', text.toString());"))
  })
  
  
  # Statistical Information: USA ####
  output$dtselect_us <- renderText({input$text2})
  
  df_box_us_click <- reactive({
    tryCatch({
      main_df %>%
        na.omit() %>%
        filter((worker_education %in% input$edu_map) &
                 (year >= input$year_map[1] & year <= input$year_map[2]) &
                 long_state == input$text2) %>%
        group_by(employer_name, job_info_job_title) %>%
        summarise(n_app = n(), max_wage_offer = max(wage_offer_mean), min_wage_offer = min(wage_offer_mean))
    }, error=function(e) {
      main_df %>%
        na.omit() %>%
        filter((worker_education %in% input$edu_map) &
                 (year >= input$year_map[1] & year <= input$year_map[2])) %>%
        group_by(employer_name, job_info_job_title) %>%
        summarise(n_app = n(), max_wage_offer = max(wage_offer_mean), min_wage_offer = min(wage_offer_mean))
    })
  })
  
  output$max_box_us <- renderInfoBox({
    df_box_us = df_box_us_click()
    max_value = max(df_box_us[,4])
    max_job_title <- 
      df_box_us$job_info_job_title[df_box_us[,4]==max_value]
    infoBox(max_job_title, max_value, icon = icon("hand-o-up"))
  })
  
  output$min_box_us <- renderInfoBox({
    df_box_us = df_box_us_click()
    min_value <- min(df_box_us[,5])
    min_job_title <- 
      df_box_us$job_info_job_title[df_box_us[,5]==min_value]
    infoBox(min_job_title, min_value, icon = icon("hand-o-down"))
  })

  # Pie Chart: USA ####
  # output$dtselect_us <- renderText({input$text})
  # 
  # df_pie_us <- reactive({
  #   if (input$text == ""){
  #     if (input$var_map_usa == "Number of Applicants"){
  #       main_df %>%
  #         na.omit() %>%
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = n()) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     } else {
  #       main_df %>%
  #         na.omit() %>%
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = mean(wage_offer_mean)) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     }
  #   } else {
  #     if (input$var_map_usa == "Number of Applicants"){
  #       main_df %>%
  #         na.omit() %>%
  #         filter(work_state == input$text) %>% 
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = n()) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     } else {
  #       main_df %>%
  #         na.omit() %>%
  #         filter(work_state == input$text) %>% 
  #         group_by(job_info_job_title) %>% 
  #         summarise(vari = mean(wage_offer_mean)) %>% 
  #         arrange(desc(vari)) %>% 
  #         top_n(5, vari)
  #     }
  #   }
  # })
  # 
  # output$pie_us <- renderPlot({
  #   df_pie_us = df_pie_us()
  #   ggplot(data2, aes(x = 1, y = vari)) +
  #     geom_bar(aes(fill = job_info_job_title), stat = "identity") +
  #     coord_polar(theta = "y") +
  #     labs(x='Job Title',
  #          y=input$var_map) +
  #     scale_fill_discrete(name = "Job Title") +
  #     theme_bw() 
  # })

  
})