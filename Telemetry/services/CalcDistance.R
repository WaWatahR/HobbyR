CalcDistance = function(lat1, lon1, lat2, lon2, miles = T){
    #sqrt((lat1-lat2)^2+(long1-long2)^2)
    # lat1 = lat1 * pi/180
    # lon1 = lon2 * pi/180
    # lat2 = lat2 * pi/180
    # lon2 = lon2 * pi/180
        
    if(miles){
        R=3959
    } else { R= 6371}

    dlon = (lon2 - lon1) * pi/180
    dlat = (lat2 - lat1) * pi/180
    
    lat1 = lat1 * pi/180
    lat2 = lat2 * pi/180
    
    a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
    c = 2 * atan2( sqrt(a), sqrt(1-a) )
    return(R * c)
    
    #distm (c(lon1, lat1), cbind(lon2, lat2), fun = distHaversine)
}

#CalcDistance(38.898556, -77.037852, 38.897147, -77.043934, miles = T)
