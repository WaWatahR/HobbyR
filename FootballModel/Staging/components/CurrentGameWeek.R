CurrentGameWeek = function(dbcon){
    url = 'https://fantasy.premierleague.com/drf/bootstrap-dynamic'
    
    WeekID = fromJSON(url)$`current-event`
    
    WeekID = as.data.frame(WeekID)
    
    #Save the data to staging database
    SaveData(dbcon, WeekID, "CurrentWeek", Insert=F)

    return()
}