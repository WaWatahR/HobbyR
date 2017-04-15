GetHTMLLogTable = function(Season, GameWeek, htmlsession){
    
    Log = data.frame()
    url =     gsub("`Season`", Season, gsub("`GameWeek`", GameWeek, "https://www.premierleague.com/tables?co=1&se=`Season`&mw=1-`GameWeek`&ha=-1"))
    htmlsession$navigate(url)
    tablepage = read_html(htmlsession$getPageSource()[[1]])
    tables = html_nodes(tablepage, ".tableBodyContainer")
    table = html_children(tables)[which(html_attr(html_children(tables), "data-compseason")==Season)]
    cat("Page Loading .")
    while(length(table)==0){
        cat(" .")
        tablepage = read_html(htmlsession$getPageSource()[[1]])
        tables = html_nodes(tablepage, ".tableBodyContainer")
        table = html_children(tables)[which(html_attr(html_children(tables), "data-compseason")==Season)]
    }
    cat('\n')
    names = html_attr(html_nodes(tables, "tr"), "data-filtered-table-row-name")[seq(1,39,2)]
    
    rowdetails = data.frame()
    for(i in seq(1,20,1)){
        rowdetails = rbind(rowdetails, data.frame(t(html_text(html_nodes(table[i], 'td')[4:11]))))
    }
    
    Log = rbind(Log, cbind(Team = names, Position= 1:20, rowdetails))
    names(Log) = c("Team", "Position", "Played", "Won", "Drawn", "Lost", "GoalsFor", "GoalsAgainst", "GoalDifference", "Points")
    return(Log)
}
