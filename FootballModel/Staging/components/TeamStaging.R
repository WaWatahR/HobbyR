TeamStaging = function(dbcon, Details = Details){
    
    #Extract the required dimensions
    Teams = Details$teams
    
    #Exclude the fixture columns
    Teams$current_event_fixture = Teams$next_event_fixture = NULL
    
    #Save the data to staging database
    SaveData(dbcon, 
             Teams[c("name", "code", "strength_overall_home", "strength_overall_away", "strength_attack_home", "strength_attack_away", "strength_defence_home", "strength_defence_away")], 
             'S_FactTeamForm', 
            Insert=F)
}