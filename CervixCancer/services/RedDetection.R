par(mfrow=c(4,4))
sxdim = sydim = 28
q=3
for(w in 1:16){
    im = load.image(paste0(filepath, q, "/", image_names[[q]][w])) %>% resize(xdim, ydim)
    #plot(im)
    
    #d = as.data.frame(im)
    #d$value[!(d$RGB[d$cc==1]>=140 & d$RGB[d$cc==2]<=160 & d$RGB[d$cc==3]<=160)]=0
    d = as.data.frame(SkinDetection(im))
    
 
    d$RGB = d$value*255
    ch2 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==2])[2:3])
    ch3 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==3])[2:3])
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==1] = 1
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==2] = 0
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==3] = 0
    
    # threshold = summary(d$value[d$cc==1 & d$value[d$cc==2]<=ch2 & d$value[d$cc==3]<=ch3])[4]
    # d$value[threshold>= d$value[d$cc==1] & d$value[d$cc==2]<=ch2 & d$value[d$cc==3]<=ch3 & d$cc==1] = 1
    # d$value[threshold>= d$value[d$cc==1] & d$value[d$cc==2]<=ch2 & d$value[d$cc==3]<=ch3 & d$cc==2] = 0
    # d$value[threshold>= d$value[d$cc==1] & d$value[d$cc==2]<=ch2 & d$value[d$cc==3]<=ch3 & d$cc==3] = 0
    
    # nimg <- as.cimg(d[c('x','y','cc','value')],  x = xdim, y = ydim)
    # plot(nimg)
    
    values= data.frame()
    for(i in 1:(xdim-sxdim)){
        for(j in 1:(ydim-sydim)){
            values[i,j] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1)
            #plot(im, main = values[i,j])
            #rect(i, j,(i+sxdim), (j+sydim), border="white", lwd=2.5)
            #Sys.sleep(0.5)
                #summary(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1])[4]
# sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1])
        }
    }
    #xstart = row(values)[values==max(values)][1]
    #ystart = as.integer(which.max(values[xstart,]))[1]
    
    ystart = max(col(values)[values==max(values)])
    xstart = which.max(values[,ystart])
    
    plot(im)
    rect(xstart, ystart,(xstart+sxdim), (ystart+sydim), border="white", lwd=2.5)
}