library(X4R)
library(data.table)
library(RDCOMClient)
library(Hmisc)
library(plyr)

#create connection to SSAS datacube
con <- COMCreate("ADODB.Connection")

con[["ConnectionString"]] <- paste(
    "Provider=MSOLAP",
    "Data Source=localhost",
    "Catalog=HelloCube",
    "Persist Security Info=True",
    sep = ";")
con$Open()

# define the MDX query here:
query = "SELECT { [Measures].[12 Month Order Quantity] } ON COLUMNS,  {[CD Part].[Part SID]} ON ROWS FROM [SDHAnalytical]"

rs <- COMCreate("ADODB.RecordSet")

# submit the MDX query to the cube
rs$Open(query, con)

rs$MoveFirst()    # move to the first row of the record set
nc <- rs$Fields()$Count()     # define number of columns

# get the data into a data array:
dd <- vector("list", length=nc)
dd <- rs$GetRows()  # get the raw data from the results