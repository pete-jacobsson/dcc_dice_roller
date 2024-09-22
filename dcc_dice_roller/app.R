library(shiny)

shinyApp(
  ui = fluidPage(
    titlePanel("Dice Roller"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput("dice", "Choose a die:", 
                    choices = paste0("D", 2:30)),
        actionButton("roll", "Roll the die!")
      ),
      
      mainPanel(
        h3("Result:"),
        textOutput("result")
      )
    )
  ),
  
  server = function(input, output) {
    result <- reactiveVal()
    
    observeEvent(input$roll, {
      dice_sides <- as.numeric(substr(input$dice, 2, nchar(input$dice)))
      roll_result <- sample(1:dice_sides, 1)
      result(roll_result)
    })
    
    output$result <- renderText({
      if (!is.null(result())) {
        paste("You rolled a", result(), "on a", input$dice)
      }
    })
  }
)