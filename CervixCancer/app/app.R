library(shiny)
library(imager)

xdim = ydim = 128

ImageList = ImageMetadata("D:/train/Type_")
im1 = list()
for(i in 1:10){
    im1[[length(im1)+1]] = load.image(paste0("D:/train/Type_1/", ImageList[[1]][i])) %>% resize(xdim, ydim)
}


shinyApp(
  ui = tagList(
    #shinythemes::themeSelector(),
    navbarPage(
        theme = shinytheme("sandstone"),  # <--- To use a theme, uncomment this
        "Cervix Cancer EDA",
        tabPanel("Gallery",
    ?tabsetPanelmainPanel(
          tabsetPanel(
            tabPanel("Type 1",
                     plotOutput("type1images", width = "100%", height = "400px"
                    ),
            tabPanel("Type 2"),
            tabPanel("Type 3")
          )
        )
      )
    )
  ),
  server = function(input, output, session) {
    # output$txtout <- renderText({
    #   paste(input$txt, input$slider, format(input$date), sep = ", ")
    # })
    # output$table <- renderTable({
    #   head(cars, 4)
    # })
    output$type1images = renderPlot({
        plot(im1[[1]])
    })
  }
)
