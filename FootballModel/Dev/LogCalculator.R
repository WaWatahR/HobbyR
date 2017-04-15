LogCalculator = function(final){
    
    for(s in max(Results$season):1){
        temp = Results[Results$season == s,]
        Teams = rep(unique(temp$HomeTeam),38)
        Season  = s
        GameWeek = rep(1:38, each=20)
        Played = GoalsScored = GoalsConceded = Points = Rank = 0
        
        Log  = data.frame(Season, GameWeek, Teams, Played, GoalsScored, GoalsConceded, Points, Rank)
        Log = arrange(Log, GameWeek, Teams)
        
        for(g in 1:38){
            wresults = temp[temp$GameWeekID == g,]
            
            wresults = data.frame(Team = c(wresults$HomeTeam, wresults$AwayTeam), 
                       Points = c(wresults$HomePoints, wresults$AwayPoints), 
                       GoalsScored = c(wresults$FullTimeHomeTeamGoals, wresults$FullTimeAwayTeamGoals), 
                       GoalsConceded = c(wresults$FullTimeAwayTeamGoals, wresults$FullTimeHomeTeamGoals), 
                       Played =1)
            
            wresults =  aggregate(. ~ Team, wresults, sum)
            
            #For teams that did play
            Log$Played[Log$GameWeek==g & Log$Teams %in% wresults$Team] = wresults$Played
            Log$Points[Log$GameWeek==g & Log$Teams %in% wresults$Team] = wresults$Points
            Log$GoalsScored[Log$GameWeek==g & Log$Teams %in% wresults$Team] = wresults$GoalsScored
            Log$GoalsConceded[Log$GameWeek==g & Log$Teams %in% wresults$Team] = wresults$GoalsConceded
            
            if(g > 1){ # need to add team to filter for weeks with different number of fixtures
                pLog = Log[Log$GameWeek==(g-1),]
                
                Log$Played[Log$GameWeek==g]     = Log$Played[Log$GameWeek==g] + pLog$Played
                Log$Points[Log$GameWeek==g]      = Log$Points[Log$GameWeek==g] + pLog$Points
                Log$GoalsScored[Log$GameWeek==g] = Log$GoalsScored[Log$GameWeek==g] + pLog$GoalsScored
                Log$GoalsConceded[Log$GameWeek==g] = Log$GoalsConceded[Log$GameWeek==g] + pLog$GoalsConceded
            }
            
            
            #code not working
            # Log$Rank[Log$GameWeek==g] = rank(Log[Log$GameWeek==g, c("Points", "GoalsScored", "GoalsConceded")], ties.method = 'min')
            # test2 = within(test, Rank <- rank(order(GoalsScored,Points), ties.method='min'))
            Log[Log$GameWeek==g,] = arrange(Log[Log$GameWeek==g,], desc(Points), desc(GoalsScored), GoalsConceded)
            Log$Rank[Log$GameWeek==g] = 1:20
        }
    }
}