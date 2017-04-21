count=0
functions = ''
for(i in 1:img_rows){
    for(j in 1:img_cols){
        count = count + 1
        func = paste(
            paste0("output$t1imageblock", count, " = renderPlot({ tryCatch({"),
            paste0("plot(im1[[(", img_cols*img_rows, "*(input$pager$page_current-1))+", count, "]], xaxt='n', yaxt='n', ann=FALSE, frame.plot=F, mai=c(0.01,0.01,0.01,0.01), mar = c(1,1,1,1)+0.1)},"),
            paste0("error= function(e){ NULL }) }, res=10)"),
            sep=" "
        )
        functions = paste(functions, func, sep= '\n')
    }
}
eval(parse(text=functions))


