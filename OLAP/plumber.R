library(plumber)

#* @get /salesgraph
#* @png
makePlot <- function(title){
    par(mar = rep(2, 4)) # margins
    dates <- seq(as.Date("2015-10-01"),
                 as.Date("2015-10-31"), by=1)
    sold <- 1:31
    
    plot(dates, sold, type="b", main=title)
}

#* @get /test
test <- function(req, res){
    ip <- req$REMOTE_ADDR
    c(ip = ip, res$setHeader("Last-Modified",
                  Sys.time()))
}
