KovacSkinDetection = function(im){
    
    # if image convert to dataframe
    if(class(im)!="cimg"){
        warning('im is not of class cimg')
    } else {
        sizex = dim(im)[1]
        sizey = dim(im)[2]
        im = as.data.frame(im)
    
        R = im[im$cc==1,]
        G = im[im$cc==2,]
        B = im[im$cc==3,]
            
        if(class(im)=='data.frame'){
            im$weight = 0 
            cond1 = R$value > 95/255 & G$value > 40/255 &B$value > 15/255
            cond2 = pmax(R$value, G$value ,B$value) - pmin(R$value, G$value ,B$value) > 15/255
            cond3 = abs(R$value - G$value) > 15/255
            cond4 = R$value > G$value & R$value > B$value
            im$weight[cond1 & cond2 & cond3 & cond4] = 1
            im$value = im$value * im$weight
        }
        skin = im
        #skin = as.cimg(im[c('x','y','cc','value')], x = sizex, y = sizey)
        return(skin)
    }
}
