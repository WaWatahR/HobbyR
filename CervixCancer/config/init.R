library(imager)
library(RODBC)
library(stringr)
library(reshape2)
library(foreach)
library(doParallel)
library(tensorflow)

#dbcon = odbcDriverConnect('driver={SQL Server};server=localhost;database=ImageDatabase', case="nochange")
filepath = "D:/train/Type_"

cl = makeCluster(4)
registerDoParallel(cl)

#Initialize tensorflow
source("./config/tensorflow_init.R")