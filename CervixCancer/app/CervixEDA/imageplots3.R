count=0
functions = ''
for(i in 1:img_rows){
    for(j in 1:img_cols){
        count = count + 1
        func = paste(
            paste0("output$t3imageblock", count, " = renderPlot({ tryCatch({"),
            paste0("plot(im3[[(", img_cols*img_rows, "*(input$pager3$page_current-1))+", count, "]], xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)},"),
            paste0("error= function(e){ NULL }) }, res=10)"),
            sep=" "
        )
        functions = paste(functions, func, sep= '\n')
    }
}
eval(parse(text=functions))
