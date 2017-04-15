DreamTeam = function(weekid){
    url = paste0("https://fantasy.premierleague.com/drf/dream-team/", weekid)
    return(fromJSON(url))
}

x = DreamTeam(1)
DreamTeamFixtures = data.frame(x$fixtures)
DreamTeamPlayers =  data.frame(x$team)
