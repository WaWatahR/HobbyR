#CalculateDealer clusters
DealerCluster = function(Dealers, Fault, k=3){
    
    #DistMatrix = DealerFaultDistanceMatrix(Dealers, Fault)
    cluster = kmeans(Fault[,2:3],k)
    centers = cbind(ID = 1:k, data.frame(cluster$centers))
    
    DealerClusterDistance = DistanceMatrix(Dealers, centers)
    
    DealerCenters = Dealers[apply(DealerClusterDistance[,2:nrow(Dealers)], 1, which.min),]
    
    FaultCenterDistance = DistanceMatrix(DealerCenters, Fault)
    
    # TotalDistances = data.frame(Dealers = names(DistMatrix)[2:(nrow(Dealers)+1)], Distances = apply(DistMatrix,2,sum)[2:(nrow(Dealers)+1)])
    # TotalDistances = TotalDistances[order(TotalDistances$Distances),]
    return(list(DealerCenters,FaultCenterDistance))
    
}