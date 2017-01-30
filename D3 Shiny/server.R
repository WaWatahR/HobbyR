library(shiny)
library(jsonlite)

shinyServer(function(input, output, session) {
   
    d3data <- reactive({
        var_json = toJSON(data.frame(ID= c('Bar 1','Bar 2','Bar 3','Bar 4','Bar 5'), value= c(input$b1,input$b2,input$b3,input$b4,input$b5)))
        cat(var_json)
        session$sendCustomMessage(type="jsondata",var_json)
        
        
    })
 
    output$main = renderText({
        d3data()
        "D3 Reactive SVG element"
    })
    
})
