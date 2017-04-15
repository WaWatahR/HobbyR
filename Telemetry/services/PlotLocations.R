MapPlot = function(Points, Names){
    
    p = ggplot(data = states) + 
        geom_polygon(aes(x = long, y = lat, group = group), fill = 'grey', color = "white") +
        geom_point(data = Points, aes(x = Longitude, y = Latitude, text = paste("Name : ",  Region)), color = "blue", size = 1) +
        coord_fixed(1.3) +
        guides(fill=FALSE) + 
        theme(axis.ticks = element_line(linetype = "blank"), axis.title = element_text(colour = NA), axis.text = element_text(size = 0, colour = NA, hjust = 0, vjust = 0), panel.background = element_rect(fill = NA))
    ggplotly(p, tooltip = c("Latitude", "Longitude", "Region"))
    return(p)
}

