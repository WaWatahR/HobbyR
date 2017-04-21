# count=0
# layouts = NULL
# 
# for(j in 1:img_cols){
#     row = NULL
#     for(i in 1:img_rows){
#         count = count + 1
#         block = paste0('plotOutput("t3imageblock', count, '", width = "300px", height = "250px"),')
#         row = paste(row, block, sep='\n')
#     }
#     layout = paste('column(2,', substr(row, 1, nchar(row)-1),'),', sep='\n')
#     layouts = paste(layouts, layout, sep= '\n')
# }
# # eval(parse(text=substr(layouts, 1, nchar(layouts)-1)))
# eval(parse(text = paste0('output$imagegrid <- renderUI({
#     tagList(',
#         substr(layouts, 1, nchar(layouts)-1)
#     ,')
# })')))
output$imagegrid1 <- renderUI({
         tagList(
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock1", width = "300px", height = "250px"),
                   plotOutput("t1imageblock2", width = "300px", height = "250px"),
                   plotOutput("t1imageblock3", width = "300px", height = "250px")
            ),
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock4", width = "300px", height = "250px"),
                   plotOutput("t1imageblock5", width = "300px", height = "250px"),
                   plotOutput("t1imageblock6", width = "300px", height = "250px")
            ),
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock7", width = "300px", height = "250px"),
                   plotOutput("t1imageblock8", width = "300px", height = "250px"),
                   plotOutput("t1imageblock9", width = "300px", height = "250px")
            ),
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock10", width = "300px", height = "250px"),
                   plotOutput("t1imageblock11", width = "300px", height = "250px"),
                   plotOutput("t1imageblock12", width = "300px", height = "250px")
            ),
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock13", width = "300px", height = "250px"),
                   plotOutput("t1imageblock14", width = "300px", height = "250px"),
                   plotOutput("t1imageblock15", width = "300px", height = "250px")
            ),
            column(2,offset = 0, style='padding:0px;',
                   
                   plotOutput("t1imageblock16", width = "300px", height = "250px"),
                   plotOutput("t1imageblock17", width = "300px", height = "250px"),
                   plotOutput("t1imageblock18", width = "300px", height = "250px")
            )
        )
})

output$imagegrid2 <- renderUI({
    tagList(
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock1", width = "300px", height = "250px"),
               plotOutput("t2imageblock2", width = "300px", height = "250px"),
               plotOutput("t2imageblock3", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock4", width = "300px", height = "250px"),
               plotOutput("t2imageblock5", width = "300px", height = "250px"),
               plotOutput("t2imageblock6", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock7", width = "300px", height = "250px"),
               plotOutput("t2imageblock8", width = "300px", height = "250px"),
               plotOutput("t2imageblock9", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock10", width = "300px", height = "250px"),
               plotOutput("t2imageblock11", width = "300px", height = "250px"),
               plotOutput("t2imageblock12", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock13", width = "300px", height = "250px"),
               plotOutput("t2imageblock14", width = "300px", height = "250px"),
               plotOutput("t2imageblock15", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t2imageblock16", width = "300px", height = "250px"),
               plotOutput("t2imageblock17", width = "300px", height = "250px"),
               plotOutput("t2imageblock18", width = "300px", height = "250px")
        )
    )
})

output$imagegrid3 <- renderUI({
    tagList(
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock1", width = "300px", height = "250px"),
               plotOutput("t3imageblock2", width = "300px", height = "250px"),
               plotOutput("t3imageblock3", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock4", width = "300px", height = "250px"),
               plotOutput("t3imageblock5", width = "300px", height = "250px"),
               plotOutput("t3imageblock6", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock7", width = "300px", height = "250px"),
               plotOutput("t3imageblock8", width = "300px", height = "250px"),
               plotOutput("t3imageblock9", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock10", width = "300px", height = "250px"),
               plotOutput("t3imageblock11", width = "300px", height = "250px"),
               plotOutput("t3imageblock12", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock13", width = "300px", height = "250px"),
               plotOutput("t3imageblock14", width = "300px", height = "250px"),
               plotOutput("t3imageblock15", width = "300px", height = "250px")
        ),
        column(2,offset = 0, style='padding:0px;',

               plotOutput("t3imageblock16", width = "300px", height = "250px"),
               plotOutput("t3imageblock17", width = "300px", height = "250px"),
               plotOutput("t3imageblock18", width = "300px", height = "250px")
        )
    )
})
