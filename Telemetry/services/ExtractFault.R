ExtractFault = function(dbcon){
    return(sqlQuery(dbcon, paste(readLines("./scripts/ExtractFaults.sql"), collapse = ' ')))
}