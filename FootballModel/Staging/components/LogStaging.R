LogStaging = function(dbpull, dbpush){
    ToLoad = sqlQuery(dbpull, readLines("./scripts/LeagueLogDelta.sql"))
    
    Log = data.frame()
    for(i in 1:nrow(ToLoad)){
        cat(i, sep=" ")
        Log = rbind(Log, cbind(Season = ToLoad$SeasonURLCode[i],
                               GameWeek = ToLoad$GameWeekID[i],
                               GetHTMLLogTable(ToLoad$SeasonURLCode[i], ToLoad$GameWeekID[i], htmlsession)))
    }
    SaveData(dbpush, Log, "S_FactLeagueLog", Insert = F)
    sqlQuery(dbpush, "EXEC dbo.LoadLeagueLog")
    return(TRUE)
}
