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
              fluidRow(box(h2("Box content here"), br(), "More content", width = 12))
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
      # Chart 2: Company tab ####
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
                tabBox(title = "Graph Options", id = "tabset1", width = 12, height = 600,
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
                tabBox(id = "tabset_map", width = 12, height = 800,
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
                                box(htmlOutput("map_glob"), width = 12)),
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
                                box(htmlOutput("map_usa"), width = 12))))
              ),
      # About tab ####
      tabItem(tabName = "about", "about here")
      )
    )
  )
)