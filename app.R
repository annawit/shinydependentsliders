# https://ux.stackexchange.com/questions/3736/how-to-build-a-budgeting-interface-sum-of-items-must-equal-100
# https://stackoverflow.com/questions/41247472/mutually-dependent-input-sliders-in-r-shiny
# https://stackoverflow.com/questions/34731975/how-to-listen-for-more-than-one-event-expression-within-a-shiny-eventreactive-ha
# https://shiny.rstudio.com/reference/shiny/0.14/updateSliderInput.html

library(shiny)

ui = pageWithSidebar(
  headerPanel("Glass fullness"),
  sidebarPanel(
    sliderInput(inputId = "Full",
                label = "% full",
                min = 0,
                max = 100,
                value = 0.2),
    sliderInput(inputId = "Empty",
                label = "% empty",
                min = 0,
                max = 100, 
                value = 1 - 0.2),
    sliderInput(inputId = "Doom",
                label = "% doom",
                min = 0,
                max = 100, 
                value = 0),
    uiOutput("Empty"),
    uiOutput("Full"),
    uiOutput("Doom")),
  mainPanel(
    textOutput("values")
  )
)

server = function(input, output, session){
  
  # when water change, update air
  observeEvent({
    input$Full
    input$Doom}, {
    updateSliderInput(session = session, inputId = "Empty", value = 100 * input$Empty/(input$Empty + input$Full + input$Doom))
  })
  
  # when air change, update water
  observeEvent({
    input$Empty
    input$Doom},  {
    updateSliderInput(session = session, inputId = "Full", value = 100 * input$Full/(input$Full + input$Empty + input$Doom))
  })

  observeEvent({
    input$Full
    input$Empty},  {
      updateSliderInput(session = session, inputId = "Doom", value = 100 * input$Doom/(input$Doom + input$Full + input$Empty))
    })
  
  output$values <- renderText({
    paste(input$Full, input$Empty, input$Doom, sum(input$Full, input$Empty, input$Doom))
    })
}

shinyApp(ui = ui, server = server)

