RedRegionSelect = function(d, sxdim, sydim){
    xdim = max(d$x)
    ydim = max(d$y)
    wm = setNames(melt(WeightMatrix(xdim, ydim)), c('x', 'y', 'weight'))
    
    xdim = max(d$x)
    ydim = max(d$y)
    rc = 0
    cc = 0
    wvalues = values = data.frame()
    for(i in seq(1, (xdim-sxdim),2)){
        rc = rc+1
        cc=1
        
        for(j in seq(1, (ydim-sydim),2)){
            wvalues[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1 * wm$weight[wm$x %in% i:(i+sxdim-1) & wm$y %in% j:(j+sydim-1)])
            values[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1)
            cc=cc+1
        }
    }
    
    wystart = max(col(wvalues)[wvalues==max(wvalues)])
    wxstart = which.max(wvalues[,wystart])
    
    wystart = seq(1, (ydim-sydim),2)[wystart]
    wxstart = seq(1, (xdim-sxdim),2)[wxstart]
    
    ystart = max(col(values)[values==max(values)])
    xstart = which.max(values[,ystart])
    ystart = seq(1, (ydim-sydim),2)[ystart]
    xstart = seq(1, (xdim-sxdim),2)[xstart]
    
    cc = sum(d$value[(d$x >= wxstart & d$x <= (wxstart+sxdim)) & (d$y >= wystart & d$y <= (wystart+sydim)) & d$cc==1]==1)
    oc = sum(d$value[(d$x >= xstart & d$x <= (xstart+sxdim)) & (d$y >= ystart & d$y <= (ystart+sydim)) & d$cc==1]==1)
    
    #cat(paste('cc= ', cc, 'oc= ', oc, '\n'))
    
    if((2*cc) < oc){
        # plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
        # rect(xstart, ystart,(xstart+sxdim), (ystart+sydim), border="white", lwd=2.5)
    } else {
        # plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
        # rect(wxstart, wystart,(wxstart+sxdim), (wystart+sydim), border="white", lwd=2.5)
        xstart = wxstart
        ystart = wystart
    }
    d = as.data.frame(im)
    newd = d[d$x >= xstart & d$x <= (xstart+sxdim-1) & d$y >= ystart & d$y <= (ystart+sydim-1),]
    newd$x = newd$x - xstart + 1
    newd$y = newd$y - ystart + 1
    
    return(newd)
}