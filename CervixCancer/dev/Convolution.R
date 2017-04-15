Convolution = function(image, csize, stride=1, padding = 'SAME'){
    
    csize = 3
    stride = 1 
    output = list()
    index = 1
    par(mfrow=c(3,3))
    
    if(padding=='SAME'){
        for(j in 1:(5-csize+1)){
            for(i in 1:(5-csize+1)){
                output[[index]] = data.frame(cbind(x = rep(1:csize, csize),
                                        y = rep(1:csize, each = csize),
                                        value = image[image$x <= (csize+i-1) 
                                        & image$x >= i 
                                        & image$y >= j
                                        & image$y <= (csize+j-1),'value']))
                plot(as.cimg(output[[index]], dim=c(3,3)))
                index = index + 1
            }
        }
    }
}

# d1 = matrix(round(10 * runif(25),0),5,5)
# d2 = setNames(melt(d1), c('x', 'y', 'value'))
# plot(as.cimg(d2))

