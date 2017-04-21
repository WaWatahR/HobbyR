GetTestImages = function(filepath, xdim, ydim,img_count = 0){
    sxdim = sydim = 28
    image_names = dir(filepath, pattern=".jpg")
    
    if(img_count==0) {img_count = length(image_names[[Class]])}
    images = do.call("rbind",foreach(w = 1:img_count, .packages = c('imager', 'stringr', 'reshape2')) %dopar% {
        
        im = ImportImage(paste0(filepath, image_names[w]), xdim, ydim)
        d = RedFilter(im)
        newd = RedRegionSelect(d, sxdim, sydim)
        t(as.data.frame(suppressWarnings(as.cimg(newd[c('x','y','cc','value')])))$value)
    })
    
    result = cbind(image_names, images)
    return(result)
}