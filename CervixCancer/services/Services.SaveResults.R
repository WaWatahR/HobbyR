SaveResults=function(dbcon, dataframe, tablename, batchsize = 1000){

  len = nrow(dataframe)
  
  for(i in 1:ceiling(len/batchsize)){
    iquery=paste("INSERT INTO ", tablename, "([x],[y],[cc],[value],[name],[type])",
                 paste(" SELECT", do.call(paste,c(dataframe[(batchsize*(i-1)+1):min(i*batchsize,len),],sep=",")), "UNION ALL", collapse=" "), sep="\n")
    sqlQuery(dbcon, substring(iquery, 1, nchar(iquery)-9))  
  }
}

