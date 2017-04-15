DistanceMatrix = function(Dealers, Fault){
    
    results = Fault$ID
    for(i in 1:nrow(Dealers)) {
        distances = CalcDistance(Dealers$Latitude[i], Dealers$Longitude[i], Fault$Latitude, Fault$Longitude)
        results = cbind(results, data.frame(distances))
    }
    names(results) = c("FaultID", Dealers$CustomerID)
    return(results)
}