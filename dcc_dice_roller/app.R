library(shiny)

shinyApp(
  ui = fluidPage(
    # Add custom CSS styles
    tags$head(
      tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Comic+Neue&family=Creepster&display=swap');
        body {
          background-image: url('dice_roller_background.png');
          background-size: cover;
          font-family: 'Comic Neue', cursive;
          text-transform: uppercase;
        }
        /* Style for radio buttons and roll button */
        .radio-inline, .btn {
          font-family: 'Comic Neue', cursive;
          text-transform: uppercase;
          color: white !important;
        }
        .radio-inline input[type='radio']:checked + span {
          background-color: #800020;
          padding: 2px 5px;
          border-radius: 3px;
        }
        /* Style for the result display */
        #result_frame {
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          padding: 40px;
          background-color: #800020;
          border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
          box-shadow: 0 0 0 15px #800020,
                      0 0 0 30px #90001a,
                      0 0 0 45px #a00015;
          animation: pulsate 2s ease-out infinite;
        }
        @keyframes pulsate {
          0% { transform: translate(-50%, -50%) scale(1); }
          50% { transform: translate(-50%, -50%) scale(1.05); }
          100% { transform: translate(-50%, -50%) scale(1); }
        }
        #result {
          font-family: 'Creepster', cursive;
          font-size: 28px;
          color: #000000;
          text-shadow: 1px 1px 2px #ffffff;
          text-transform: none;
        }
      "))
    ),
    
    # Radio buttons for dice selection
    radioButtons("dice", "Choose your die:",
                 choices = c("d3", "d4", "d5", "d6", "d7", "d8", "d10", "d12", "d14", "d16", "d20", "d24", "d30"),
                 inline = TRUE),
    
    # Button to roll the die
    actionButton("roll", "Roll the die!", 
                 style = "margin-top: 10px; background-color: #800020;"),
    
    # Frame to display the result
    div(id = "result_frame",
        textOutput("result")
    )
  ),
  
  server = function(input, output) {
    # Reactive value to store the roll result
    result <- reactiveVal()
    
    # Observer to handle die rolling
    observeEvent(input$roll, {
      # Extract the number of sides from the selected die
      dice_sides <- as.numeric(substr(input$dice, 2, nchar(input$dice)))
      # Generate a random number based on the die sides
      roll_result <- sample(1:dice_sides, 1)
      # Store the result
      result(roll_result)
    })
    
    # Render the result text
    output$result <- renderText({
      if (!is.null(result())) {
        paste(result(), "on a", input$dice)
      }
    })
  }
)