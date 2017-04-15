PlayerList = function(){
    url = "https://fantasy.premierleague.com/drf/bootstrap-static"
    return(fromJSON(url))
}
# sqlDrop(dbcon, "PlayerDetails")
# sqlDrop(dbcon, "TeamDetails")
# sqlDrop(dbcon, "ElementType")
# sqlDrop(dbcon, "FantasyEvents")
# 
# sqlSave(dbcon, PlayerDetails, rownames = F)
# sqlSave(dbcon, TeamDetails, rownames = F)
# sqlSave(dbcon, ElementType, rownames = F)
# sqlSave(dbcon, FantasyEvents, rownames = F)