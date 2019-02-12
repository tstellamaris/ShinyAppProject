## ui.R ##

library(shinydashboard)

shinyUI(dashboardPage(
  # Header ####
  dashboardHeader(title = "Shiny Project"),
  
  # Sidebar ####
  dashboardSidebar(
    sidebarUserPanel("Stella Oliveira", "NYC Data Science Academy"),
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Charts", icon = icon("bar-chart-o"), startExpanded = FALSE,
               menuSubItem("Visa", tabName = "visa"),
               menuSubItem("Job Information", tabName = "company")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  
  # Body ####
  dashboardBody(
    tabItems(
      
      # Home tab ####
      tabItem(tabName = "home",
              fluidRow(box(h3("Data Visulization and Analysis about Work Visas Applicattions"), 
                           br(), "Approximately 140,000 immigrant visas are available each fiscal year 
                           for aliens who seek to immigrate in the USA based on their job skills*.", br(),
                           "This app aims to be a tool for both american companies and workers 
                           to visualize and analyze what skills some companies is looking 
                           for outsite of the USA to fullfill their position", br(), br(),
                           "* Information from ",  a(href="https://www.uscis.gov/working-united-states/permanent-workers", 
                                                     "US Citizenship and Immigration Service"), 
                           "website.", width = 12)),
              fluidRow(box(strong("About the App"), br(),
                           "All tabs are found on the left side of the app with the following description:", 
                           br(),
                           "Chart: bar plots and box plot about the number of visa applicants per
                           year (Visa subtab) and the job requirements (Job Information subtab).",
                           br(),
                           "Map: global map about the worker citizenship and USA map about the 
                           state where the employee is working.", width = 12))
              ),
      
      # Chart 1: Visa tab ####
      tabItem(tabName = "visa",
              fluidRow(
                box(column(checkboxGroupInput("visastatus", label = ("Choose the visa status"), 
                                       choices = visastatus,
                                       selected = visastatus), width = 6),
                    column(checkboxGroupInput("edu_vis", label = ("Choose the education level"), 
                                        choices = education,
                                        selected = education), width = 6), width = 12),
                box(plotOutput("visa_g"),width = 12))
              ),
      # Chart 2: Job Information tab ####
      tabItem(tabName = "company",
              fluidRow(
                box(textInput("com_name", label = "Search by company name", 
                                        value = ""), width = 4),
                box(textInput("job_title", label = "Search by job title", 
                              value = ""), width = 4),
                box(selectInput("var_comp", 
                                label = "Choose a variable to display",
                                choices = c("Number of Applicants", 
                                            "Average Wage Offer"),
                                selected = "Number of Applicants"), width = 4)
              ),
              fluidRow(
                tabBox(title = "Graph Options", id = "tabset1", width = 12, height = 580,
                       tabPanel("Companies", 
                                plotOutput("comp_comp")),
                       tabPanel("Job Title", 
                                plotOutput("comp_job")),
                       tabPanel("Education Level", 
                                plotOutput("comp_edu")),
                       tabPanel("Visa Type", 
                                plotOutput("comp_visa"))))
              ),
      # Map tab ####
      tabItem(tabName = "map",
              fluidRow(
                tabBox(id = "tabset_map", width = 12, height = 1200,
                       tabPanel("From: Country of Citizenship",
                                column(selectInput("var_map", 
                                            label = "Choose a variable to display",
                                            choices = c("Number of Applicants", 
                                                        "Average Wage Offer"),
                                            selected = "Number of Applicants"), width = 4),
                                column(sliderInput("year_map", 
                                            label = "Year:",
                                            min = min_year, max = max_year, value = c(min_year, max_year), 
                                            step = 1), width = 4),
                                column(checkboxGroupInput("edu_map", label = ("Choose the education level"), 
                                                          choices = education,
                                                          selected = education), width = 4),
                                hr(),
                                box(htmlOutput("map_glob"), width = 12),
                                hr(),
                                fluidRow(column(10,align = "center", h3(textOutput("dtselect")))),
                                hr(),
                                fluidRow(infoBoxOutput("max_box_gl", width = 6),
                                         infoBoxOutput("min_box_gl", width = 6))),
                       tabPanel("To: USA State", 
                                column(selectInput("var_map_usa", 
                                                   label = "Choose a variable to display",
                                                   choices = c("Number of Applicants", 
                                                               "Average Wage Offer"),
                                                   selected = "Number of Applicants"), width = 4),
                                column(sliderInput("year_map_usa", 
                                                   label = "Year:",
                                                   min = min_year, max = max_year, value = c(min_year, max_year), 
                                                   step = 1), width = 4),
                                column(checkboxGroupInput("edu_map_usa", label = ("Choose the education level"), 
                                                          choices = education,
                                                          selected = education), width = 4),
                                hr(),
                                box(htmlOutput("map_usa"), width = 12),
                                hr(),
                                fluidRow(column(10,align = "center", h3(textOutput("dtselect_us")))),
                                hr(),
                                fluidRow(infoBoxOutput("max_box_us", width = 6),
                                         infoBoxOutput("min_box_us", width = 6)))
                       ))
              ),
      # About tab ####
      tabItem(tabName = "about", 
              fluidRow(box(strong("About the author"), 
                          br(), "Stella Oliveira is a NYC Data Science fellow. This Shiny App is her
                          second project for the bootcamp.", br(), 
                          "She holds a bachelor degree in Physics from 
                          University of Sao Paulo, Brazil. She has 5 years of experience in the finance 
                          industry where she works at middle office and market risk teams. 
                          Prior to join the bootcamp, she also worked in a non-profit
                          organization based in NYC to help them to clean and organize their database.", 
                       width = 12)),
              fluidRow(box(strong("Source"), 
                          br(), "The raw dataset was download from ", 
                          a(href="https://www.foreignlaborcert.doleta.gov/performancedata.cfm", "foreignlaborcert.doleta.gov"),
                          "website.",
                          br(),
                          "The data was cleaned and saved as a csv file, which one was loaded by
                          this app.", br(),
                          "All scripts may be found ", 
                          a(href="https://github.com/tstellamaris/ShinyAppProject", "here."), width = 12)))
      )
    )
  )
)