PositionStaging = function(dbcon, Details = Details){
    
    #Extract the required dimensions
    Positions = Details$element_types
    
    #Save the data to staging database
    SaveData(dbcon, Positions, 'S_Positions', Insert=F)
}