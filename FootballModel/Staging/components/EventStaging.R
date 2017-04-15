EventStaging = function(dbcon, Details = Details){
    
    #Extract the required dimensions
    Events = Details$events
    
    #Save the data to staging database
    SaveData(dbcon, Events, 'S_Events', Insert=F)
}