ImportImage = function(imagepath, xdim, ydim, dataframe=T){
    im = load.image(imagepath) %>% resize(xdim, ydim)
    if(dataframe) return(as.data.frame(im))
    return(im)
}