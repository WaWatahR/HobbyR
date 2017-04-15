FantasyTeamStaging = function(dbstg){

    url = "https://fantasy.premierleague.com/drf/leagues-classic-standings/313?phase=1&le-page=1&ls-page=1"
    PlayerList = data.frame(fromJSON(url)$standings$results)
    Next50 = PlayerList
    i=2
    while(nrow(Next50)>0){
        cat(i, sep='\n')
        url = paste0("https://fantasy.premierleague.com/drf/leagues-classic-standings/313?phase=1&le-page=1&ls-page=", i)
        Next50 = data.frame(fromJSON(url)$standings$results)
        PlayerList = rbind(PlayerList, Next50)
        i=i+1
    }
    SaveData(dbstg, PlayerList, 'S_FantasyTeams')
}

