RedDetection = function(filepath, Class=1, xdim, ydim, img_count = 0){
    
    # par(mfrow=c(4,4))
    sxdim = sydim = xdim/2
    image_names = ImageMetadata(filepath)
    
    if(img_count==0) {img_count = length(image_names[[Class]])}
    if(img_count>0) img_count = min(length(image_names[[Class]]), img_count)
    # images = do.call("rbind",foreach(w = 1:img_count, 
    #                                  .packages = c('imager', 'stringr', 'reshape2'), 
    #                                  .export = c('ImportImage', "RedFilter", "RedRegionSelect", "WeightMatrix")) %dopar% {
    # 
    #     im = ImportImage(paste0(filepath, Class, "/", image_names[[Class]][w]), xdim, ydim)
    # 
    #     d = RedFilter(im)
    #     newd = RedRegionSelect(d, sxdim, sydim)
    #     t(as.data.frame(suppressWarnings(as.cimg(newd[c('x','y','cc','value')])))$value)
    # })
    
    images = foreach(w = 1:img_count, 
                     .packages = c('imager', 'stringr', 'reshape2'), 
                     .export = c('ImportImage', "RedFilter", "RedRegionSelect", "WeightMatrix")) %dopar% {
                         
                         im = ImportImage(paste0(filepath, Class, "/", image_names[[Class]][w]), xdim, ydim)
                         
                         d = RedFilter(im)
                         newd = RedRegionSelect(d, sxdim, sydim)
                         suppressWarnings(as.cimg(newd[c('x','y','cc','value')]))
                         #newd
                     }
    
    class = matrix(0,img_count,3)
    class[,Class] = 1 
    
    return(list(images, class))
}