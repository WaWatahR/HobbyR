OsmanSkinDetection = function(im){
    # if image convert to dataframe
    if(class(im)!="cimg"){
        warning('im is not of class cimg')
        break
    } else {
        sizex = dim(im)[1]
        sizey = dim(im)[2]
        im = as.data.frame(im)
        
        R = im[im$cc==1,'value']
        G = im[im$cc==2,'value']
        B = im[im$cc==3,'value']
        
        if(class(im)=='data.frame'){
            im$weight = 0
            cond1  = (R-G)/(R+G) > 0 & (R-G)/(R+G) <= 0.5 
            cond2 = B/(R+G)<=0.5
            im$weight[cond1 & cond2] = 1
            im$value = im$value * im$weight
        }
        skin = im
        #skin = as.cimg(im[c('x','y','cc','value')], x = sizex, y = sizey)
        return(skin)
    }
}