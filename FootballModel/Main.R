library(ggmap)
options(stringsAsFactors = FALSE)

#Initialize libraries and connections
source("./init/Config.R")

#Stage all data
source("./Staging/StageWorkFlow.R")

#Load Dimensions
source("./Dimensions/PlayerDimension.R")


#Excel workflow
final = PrepareExcelData()
