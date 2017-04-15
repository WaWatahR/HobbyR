MatchStaging = function(dbstg, GameWeekCount){
    
    Match = data.frame()
    for(i in 1:GameWeekCount){
        url = paste0("https://fantasy.premierleague.com/drf/fixtures/?event=", i)
        Fixtures = cbind(GameWeek= i, fromJSON(url)[c("kickoff_time_formatted", "kickoff_time", "team_a", "team_h", "code", "team_a_score", "team_h_score", "event")])
        Match  = rbind(Match,Fixtures)
    }   
    SaveData(dbstg, Match, 'S_FactLeagueMatches', Insert = F)
}