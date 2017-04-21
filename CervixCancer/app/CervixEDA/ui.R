#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(gridExtra)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  navbarPage(
    theme = shinytheme("sandstone"),  # <--- To use a theme, uncomment this
        "Cervix Cancer EDA",
        # tabPanel("Pic Transformations",
        #          sidebarLayout(
        #              
        #              sidebarPanel(
        #                  width=2,
        #                  h1("Parameters"),
        #                  br(),
        #                  radioButtons("img_type","Image Type", 
        #                               choices = c("Type 1", "Type 2", "Type 3"),
        #                               selected = "Type 3"
        #                  ),
        #                  br(),
        #                  uiOutput("ImageInputUI"),
        #                  br(),
        #                  sliderInput("sigma", "Sigma", 0, 5, 2,step=0.5, animate=T),
        #                  br(),
        #                  sliderInput("order", "Order", 0, 2, 2,step=0.5, animate=T),
        #                  br(),
        #                  sliderInput("sharpness", "Sharpness", 0, 1, 0.6, step = 0.1, animate=T)
        #              ),
        #              mainPanel(
        #                  width=10,
        #                  h1("Image Results"),
        #                  plotOutput("pictransform", width = "1200px", height = "800px")
        #              )
        #          )
        # ),
        tabPanel("Points Of Interest",
             sidebarLayout(

                 sidebarPanel(
                     width=2,
                     h1("Parameters"),
                     br(),
                     radioButtons("img_type","Image Type",
                                  choices = c("Type 1", "Type 2", "Type 3"),
                                  selected = "Type 3"
                     ),
                     br(),
                     uiOutput("ImageInputUI")

                 ),
                 mainPanel(
                     width=10,
                     h1("Image Plots"),
                     plotOutput("redblock", width = "1200px", height = "400px"),
                     plotOutput("colchannels", width = "1200px", height = "400px")
                 )
             )
        ),
        tabPanel("Gallery",
            mainPanel(
                width=12,
                tabsetPanel(
                    tabPanel("Type 1",
                             br(),
                             fluidRow(align='right', pageruiInput('pager', 1, ceiling(length(im1)/(img_rows*img_cols)))),
                             fluidRow(offset = 0, style='padding:0px;margin:0px',
                                 uiOutput("imagegrid1")
                             )
                    ),
                    tabPanel("Type 2",
                             br(),
                            fluidRow(align='right', pageruiInput('pager2', 1, ceiling(length(im2)/(img_rows*img_cols)))),
                             fluidRow(offset = 0, style='padding:0px;margin:0px',
                                      uiOutput("imagegrid2")
                             ) 
                            ),
                    tabPanel("Type 3",
                             br(),
                             fluidRow(align='right', pageruiInput('pager3', 1, ceiling(length(im3)/(img_rows*img_cols)))),
                             fluidRow(offset = 0, style='padding:0px;margin:0px',
                                      uiOutput("imagegrid3")
                             ))
                )
            )
        )
    )
))
