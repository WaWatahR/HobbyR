StageWorkFlow = function(dbstg, dblive){
    
    #Add all components
    source('./Staging/components/Team_Player_Events_Position_Detail.R')
    source('./Staging/components/EventStaging.R')
    source('./Staging/components/PlayerStaging.R')
    source('./Staging/components/PositionStaging.R')
    source('./Staging/components/TeamStaging.R')
    source('./Staging/components/LogStaging.R')
    source('./Staging/components/CurrentGameWeek.R')
    
    #Import all the data
    Details = PlayerList()
    
    #Call functions sequentially
    StageLog(dbstg, dblive)
    CurrentGameWeek(dbcon)
    EventStaging(dbcon, Details)
    PlayerStaging(dbcon, Details)
    PositionStaging(dbcon, Details)
    TeamStaging(dbcon, Details)
    
}

StageWorkFlow(dbstg)