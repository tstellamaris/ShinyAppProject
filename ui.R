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
               menuSubItem("Company", tabName = "company"),
               menuSubItem("Employee", tabName = "employee")),
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
                box(status = "primary",
                    checkboxGroupInput("visastatus", label = ("Choose the visa status"), 
                                       choices = visastatus,
                                       selected = visastatus)),
                tabBox(title = "Graph Options", id = "tabset1", width = 12,
                       tabPanel("Tab 1","First tab content"),
                       tabPanel("Tab 2", "Second tab content")))
      ),
      # Chart 2: Company tab ####
      tabItem(tabName = "company",
              fluidRow(
                tabBox(title = "Graph Options", id = "tabset1", width = 12,
                       tabPanel("Tab 1", "First tab content"),
                       tabPanel("Tab 2", "Second tab content")))
              ),
      # Chart 3: Employee tab ####
      tabItem(tabName = "employee",
              "to be replaced"
              ),
      # Map tab ####
      tabItem(tabName = "map", "map here"
              #fluidRow(box(htmlOutput("map_usa")))
              ),
      # About tab ####
      tabItem(tabName = "about", "about here"
              #fluidRow(box(htmlOutput("map_usa")))
      )
    )
  )
))