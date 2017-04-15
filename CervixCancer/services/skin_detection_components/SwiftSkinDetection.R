SwiftSkinDetection = function(im){
    # if image convert to dataframe
    if(class(im)!="cimg"){
        warning('im is not of class cimg')
        break
    } else {
        sizex = dim(im)[1]
        sizey = dim(im)[2]
        im = as.data.frame(im)
        
        R = im[im$cc==1,]
        G = im[im$cc==2,]
        B = im[im$cc==3,]
        
        if(class(im)=='data.frame'){
            im$weight = 1
            cond1 = B$value > R$value
            cond2 = G$value < B$value
            cond3 = G$value > R$value
            cond4 = B$value < R$value/4
            cond5 = B$value > 200/255
            im$weight[cond1 | cond2 | cond3 | cond4 | cond5] = 0
            im$value = im$value * im$weight
        }
        skin = im
        #skin = as.cimg(im[c('x','y','cc','value')], x = sizex, y = sizey)
        return(skin)
    }
}