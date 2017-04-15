PlayerFixtureHistory = function(id){
    url = 'https://fantasy.premierleague.com/drf/element-summary/'
    fetch_url = paste0(url, id)
    return(fromJSON(fetch_url))
}

PlayerCount = as.integer(sqlQuery(dbcon, "SELECT MAX([PlayerID]) AS PlayerCount FROM [FantasyFootball].[dbo].[D_Players]"))
history = data.frame()
for(i in 1:PlayerCount){
    cat(percent(i/PlayerCount), sep='\n')
    x = GetFantasyPlayerData(i) 
    history = rbind(history, x$history)
}

sqlDrop(dbcon, "PlayerHistory")
sqlSave(dbcon, history, tablename = "PlayerHistory", rownames = F)