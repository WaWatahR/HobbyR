#Get Dealers from customer master
Dealers = ExtractDealers(dbcon)
Fault = ExtractFault(dbcon)

ClusterResults = DealerCluster(Dealers, Fault, k=6)

p = MapPlot(ClusterResults[[1]])
ggplotly(p)

Points = Fault[sample(1:nrow(Fault), 100, replace=F),]

p = MapPointsOverlay(p, Points, "red")
ggplotly(p)