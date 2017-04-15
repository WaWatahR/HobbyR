PrepareExcelData = function(){
    datasets = c(#"http://www.football-data.co.uk/mmz4281/1617/E0.csv", #current season
        "http://www.football-data.co.uk/mmz4281/1516/E0.csv", #2015/2016
        "http://www.football-data.co.uk/mmz4281/1415/E0.csv", #2014/2015
        "http://www.football-data.co.uk/mmz4281/1314/E0.csv",
        "http://www.football-data.co.uk/mmz4281/1213/E0.csv") 
    
    final = data.frame()
    for(i in length(datasets):1){
        results = GetExcelData(datasets[i])
        results$season = i #strsplit(datasets[i], '/')[[1]][5]
        final = rbind(final, results)
    }
    final$MatchDate = as.Date(final$MatchDate, format = '%d/%m/%y')
    final = final[!is.na(final$MatchDate),]
    final$MatchDate = as.character(final$MatchDate)
    # fixturelist = FixtureList()
    # 
    # final = cbind(final, fixturelist)
    # 
    # final$HomeTeam = as.character(final$HomeTeam)
    # final$AwayTeam = as.character(final$AwayTeam)
    # 
    # final$HomePoints = 0
    # final$AwayPoints = 0 
    # 
    # final$HomePoints[final$FullTimeHomeTeamGoals > final$FullTimeAwayTeamGoals] = 3
    # final$AwayPoints[final$FullTimeHomeTeamGoals < final$FullTimeAwayTeamGoals] = 3
    # final$HomePoints[final$FullTimeHomeTeamGoals == final$FullTimeAwayTeamGoals] = 1
    # final$AwayPoints[final$FullTimeHomeTeamGoals == final$FullTimeAwayTeamGoals] = 1
    # 
    
    return(final)
}
final=PrepareExcelData()