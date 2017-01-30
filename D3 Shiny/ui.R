library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        "",
        titlePanel(
            navbarPage(
                title = div(img(src = "R.png", height=80), ""), 
                id="navbar",
                tabPanel("Hello D3",
                    tags$style(type="text/css", "body {font-family: 'Source Sans Pro'}"),
                    tags$head(includeCSS("styles.css")),
                    sidebarLayout(
                        sidebarPanel(
                           h3("Reactive Parameters"),
                           br(),
                           sliderInput('b1', 'Bar 1', 0, 100, 50, step = NULL, round = TRUE),
                           sliderInput('b2', 'Bar 2', 0, 100, 50, step = NULL, round = TRUE),
                           sliderInput('b3', 'Bar 3', 0, 100, 50, step = NULL, round = TRUE),
                           sliderInput('b4', 'Bar 4', 0, 100, 50, step = NULL, round = TRUE),
                           sliderInput('b5', 'Bar 5', 0, 100, 50, step = NULL, round = TRUE)
                        ),
                            
                        mainPanel(
                            tags$script(src="https://d3js.org/d3.v3.min.js"),
                            
                            #load javascript
                            tags$script(src="d3script.js"),
                            
                            #create div for reference in the d3script
                            tags$div(id="d3out"),
                            tags$div(id="d3chart", class="chart"),
                            br(),
                            
                            #reactive output 
                            textOutput('main'),
                            tags$div(id="d3chart2", class='chart')
                        )
                    )         
               )
            ),
            windowTitle="Warren D3 & R Demo"
        )
    )
)


