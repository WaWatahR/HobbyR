# Read all sales transactions

ReadTransactions = function(dbcon){
    cat("Reading Transactions")
    query = "SELECT DISTINCT TOP 10000
        	SalesOrderNumber,
            UPPER(PartNumber) AS PartNumber
            FROM [SDH].[F_GVWPartSalesOrder] so
            INNER JOIN SDH.CD_Part p ON p.PartSID=so.PartSID
            WHERE OrderCompany<>2 AND OrderTypeSID=17"
    
    # Create connection to database
    dbcon = odbcDriverConnect('driver={SQL Server};server=GVWAC51;database=SDHAnalytical', case="nochange")
    
    return(sqlQuery(dbcon, query, stringsAsFactors=F))
}