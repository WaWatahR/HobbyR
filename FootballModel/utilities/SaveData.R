SaveData = function(dbcon, data, TableName, Insert=T, BatchSize = 1000){
    
    len = nrow(data)
    
    for(i in 1:ncol(data)){
        if(class(data[,i])=='character'){
            data[,i] = paste0("'", gsub("'", "''", data[,i]), "'")
        }
        if(class(data[,i])=='logical'){
            data[,i] = as.integer(data[,i])
        }
        if(class(data[,i])=='factor'){
            if(sum(is.na(suppressWarnings(as.numeric(as.character(data[,i])))))>0){
                data[,i] = paste0("'", gsub("'", "''", as.character(data[,i])), "'")
            } else {
                as.numeric(data[,i])
            }
        }
    }
    #Remove na's
    #Sdata[is.na(data)]=0
    
    if(!Insert){
        sqlQuery(dbcon, paste('TRUNCATE TABLE', TableName))
    }
    
    if(nrow(data)==1){
        query = paste("INSERT INTO", TableName, "(",
                      paste0('[', names(data), ']', collapse = ','),
                      ")",
                      paste(" SELECT", gsub('NA', 'NULL', data[(BatchSize*(i-1)+1):min(i*BatchSize,len),]), collapse = ' '), sep="\n")
        sqlQuery(dbcon, query)  
    } else {
        for(i in 1:ceiling(len/BatchSize)){
            query = paste("INSERT INTO", TableName, "(",
                          paste0('[', names(data), ']', collapse = ','),
                          ")", 
                          paste(" SELECT", gsub('NA', 'NULL', do.call(paste, c(data[(BatchSize*(i-1)+1):min(i*BatchSize,len),], sep=','))), "UNION ALL", collapse = ' '), sep="\n")
            sqlQuery(dbcon, substring(query, 1, nchar(query)-9))  
        }
    }
}
# SaveData(dbcon, data,'Top50UserTeams', Insert=F)


