SkinDetection = function(im, blur=2){
    
    if(class(im)!="cimg"){
        warning('im is not of class cimg')
    } else {
        sizex = dim(im)[1]
        sizey = dim(im)[2]
        img = as.data.frame(im)
        
        im = isoblur(im, blur)
        img$weight = pmax(OsmanSkinDetection(im)$value > 0,
                        KovacSkinDetection(im)$value > 0,
                        SwiftSkinDetection(im)$value > 0)
        img$value = img$weight * img$value
        skin = as.cimg(img[c('x','y','cc','value')], x = sizex, y = sizey)
        return(skin)
    }
}
SkinDetection(im) %>% plot