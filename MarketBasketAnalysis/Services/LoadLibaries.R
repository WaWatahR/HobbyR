LoadLibrary = function(libraryName = '') {
    
    cat(paste('Loading library', libraryName, '\n'))
    
    if (!libraryName %in% rownames(installed.packages()))
        
    {
        cat('Library needs to be installed...\n')
        
        install.packages(libraryName, quiet = TRUE)
        
        suppressPackageStartupMessages(library(as.character(libraryName), character.only = TRUE, warn.conflicts = FALSE, quietly=T))
        
        cat('Library installed and loaded.\n')
        
    } else {
        suppressPackageStartupMessages(library(as.character(libraryName), character.only = TRUE))
    }
}

LoadLibrary('RODBC')
LoadLibrary('arules')
LoadLibrary(mclust)
LoadLibrary(arulesViz)
#dbcon = odbcDriverConnect('driver={SQL Server};server=GVWAC51;database=SDHAnalytical', case="nochange")