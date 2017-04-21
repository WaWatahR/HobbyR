library(imager)
library(RODBC)
library(stringr)
library(reshape2)
library(foreach)
library(doParallel)
library(tensorflow)
library(mxnet)

#dbcon = odbcDriverConnect('driver={SQL Server};server=localhost;database=ImageDatabase', case="nochange")
filepath = "D:/train/Type_"
xdim = ydim = 128
cl = makeCluster(3)
registerDoParallel(cl)


#Load Required Files
source("./services/ImageMetadata.R")
source("./services/WeightMatrix.R")
source("./services/GetImages.R")
source("./services/ImportImage.R")
source("./services/RedFilter.R")
source("./services/RedRegionSelect.R")
source("./services/RedDetection.R")
source("./services/GetTestImages.R")



#source("./services/SkinDetection.R")
#Initialize tensorflow
#source("./config/tensorflow_init.R")

# par(bg = rgb(77,77,77, maxColorValue = 255))
# plot(LT, 
#      type = 'l', 
#      col=rgb(96,189,104, maxColorValue = 255), 
#      lwd =2, col.lab="white", 
#      col.axis="white", 
#      tck=0,
#      main = 'Lead Time Adjusted', col.main="White",
#      xlab = 'Original Lead Time (Months)',
#      ylab = 'Adjust Lead Time')
# box(col='white')

