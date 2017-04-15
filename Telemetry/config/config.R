library(RODBC)
library(doParallel)
library(foreach)
library(geosphere)
# library(maps)
# library(mapdata)
# library(maptools)
library(rworldmap)
library(ggplot2)
library(ggmap)
library(plotly)

Sys.setenv(plotly_username = "wawatah")

dbcon = odbcDriverConnect('driver={SQL Server};server=gvwdevdb01;database=SDHOperational', case="nochange")

cl = makeCluster(4)
registerDoParallel(cl)

states <- map_data("state")
