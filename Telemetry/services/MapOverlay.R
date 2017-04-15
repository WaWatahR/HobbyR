MapPointsOverlay = function(p, Points, color){
    p = p + geom_point(data = Points, aes(x = Longitude, y = Latitude), color = color, size = 1)
    return(ggplotly(p))
}