UserTeamPeaks = function(id, week){
    url = paste0("https://fantasy.premierleague.com/drf/entry/", id , "/event/", week ,"/picks")
    return(fromJSON(url))
}

history = data.frame()
for(j in 2:10){
    for(i in 1:29){
        cat(i, sep='\n')
        picks = cbind(user = data$entry[j], weekid = i, UserTeamPeaks(data$entry[j], i)$picks)
        history = rbind(history, picks)
    }
}
SaveData(dbcon, history, "UserPicks")

history = data.frame()
for(j in 1:10){
    for(i in 1:29){
        cat(i, sep='\n')
        entry = cbind(user = data$entry[j], weekid = i, data.frame(t(unlist(UserTeamPeaks(data$entry[j],i)$entry_history))))
        history = rbind(history, entry)
    }
}
SaveData(dbcon, history, 'UserPicksResults')
#sqlSave(dbcon, cbind(user = data$entry[j], weekid = i, data.frame(t(unlist(UserTeamPeaks(data$entry[j],i)$entry_history)))), 'UserPicksResults')

x= UserTeamPeaks(data$id[1],20)
x = data.frame(t(unlist(UserTeamPeaks(data$id[1],20)$entry_history)))



url = "https://fantasy.premierleague.com/drf/event/29/live"
url = 'https://fantasy.premierleague.com/drf/entry/91223'
url = 'https://fantasy.premierleague.com/drf/leagues-classic-standings/'


url = 'https://fantasy.premierleague.com/drf/leagues-classic-standings/313'
url = 'https://fantasy.premierleague.com/drf/my-team/4000986/'
x = fromJSON(url)
