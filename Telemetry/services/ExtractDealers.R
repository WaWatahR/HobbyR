ExtractDealers = function(dbcon){
    sqlQuery(dbcon, paste(readLines("./scripts/ExtractDealers.sql"), collapse = ' '))
}