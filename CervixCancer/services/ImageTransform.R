TransformImages = function(ImageList){
    
    timages = data.frame()
    #tclasses = data.frame()
    for(i in 1:length(ImageList[[1]])){
        im = ImageList[[1]][[i]]
        im90 = imrotate(im, 90)
        im180 = imrotate(im, 180)
        im270 = imrotate(im, 270)
        drim = t(as.data.frame(deriche(im, 3,2, axis='Y'))$value)
        drim90 = t(as.data.frame(deriche(im90, 3,2, axis='Y'))$value)
        drim180 = t(as.data.frame(deriche(im180, 3,2, axis='Y'))$value)
        drim270 = t(as.data.frame(deriche(im270, 3,2, axis='Y'))$value)
        blim = t(as.data.frame(blur_anisotropic(im,ampl=1e3,sharp=0.6))$value)
        blim90 = t(as.data.frame(blur_anisotropic(im90,ampl=1e3,sharp=0.6))$value)
        blim180 = t(as.data.frame(blur_anisotropic(im180,ampl=1e3,sharp=0.6))$value)
        blim270 = t(as.data.frame(blur_anisotropic(im270,ampl=1e3,sharp=0.6))$value)
        
        timages = rbind(timages,
                    cbind(rbind(t(as.data.frame(im)$value), 
                                t(as.data.frame(im90)$value), 
                                t(as.data.frame(im180)$value),
                                t(as.data.frame(im270)$value), drim, drim90, drim180, drim270, blim, blim90, blim180, blim270),
                                Class = apply(ImageList[[2]][i,],1,which.max)))
    }
    return(timages)
}