#313 needs to be incremented each gameweek 
Top50Teams = function(){
    url = 'https://fantasy.premierleague.com/drf/leagues-classic-standings/313'
    return(data.frame(fromJSON(url)$standings$results))
}

x = Top50Teams()
