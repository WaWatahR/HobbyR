ImageMetadata = function(filepath){
    image_names = list()
    for(i in 1:3){
        image_names[[i]] = dir(paste0(filepath,i), pattern=".jpg")
    }
    return(image_names)
}