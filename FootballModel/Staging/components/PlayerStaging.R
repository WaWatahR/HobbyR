PlayerStaging = function(dbcon, Details = Details){
    
    #Extract the required dimensions
    Players = Details$elements
    Positions = Details$element_types
    Teams = Details$teams
    
    #Flatten out player and position
    Players = merge(Players, Positions, by.x = 'element_type', by.y = 'id')
    
    #Flatten out for team as well
    Players = merge(Players, Teams, by.x = 'team', by.y = 'id')
    
    #Exclude the fixture columns
    Players$current_event_fixture = Players$next_event_fixture = NULL
    
    #Save the data to staging database
    SaveData(dbcon, Players, 'S_Players', Insert=F)
}

