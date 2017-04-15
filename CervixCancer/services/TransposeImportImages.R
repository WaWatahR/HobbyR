TransposeImportImages = function(filepath, xdim, ydim){
    
    #Get a list of all images in filepath
    image_names = dir(filepath, pattern=".jpg")
    image_class = rep(0,3)
    image_class[as.integer(str_sub(filepath,-1))] = 1
    
    #subset for test
    image_names = image_names[1:20]
    
    #Import in parralel
    images = do.call("rbind",foreach(i = 1:length(image_names), .packages = c('imager', 'stringr', 'reshape2')) %dopar% {
                im = load.image(paste0(filepath, "/", image_names[i])) %>% 
                            resize(xdim, ydim) %>%
                           grayscale
                #temp = cbind(t(d$value), Name = image_names[i], Class = image_class)
                temp = data.frame(t(as.data.frame(im)$value))
                temp
            })
    
    #Save a list of one hot encoding for classs
    class = do.call("rbind",foreach(i = 1:length(image_names), .packages = c('imager', 'stringr', 'reshape2')) %dopar% {
        image_class
    })
    
    return(list(images, class))
}