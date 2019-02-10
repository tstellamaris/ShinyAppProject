## server.R ##

shinyServer(function(input, output){
  
  output$value <- renderPrint({ input$checkGroup })
  
  output$hist <- renderPlot({
    hist(main_df$year, col = 'darkgray', border = 'white')
  })
  
})