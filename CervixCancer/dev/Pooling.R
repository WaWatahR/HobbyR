Pooling = function(convolutions, method = 'median'){
    pdim = sqrt(length(convolutions))
    pool = matrix(0, pdim, pdim)
    iter = 1
    for(j in 1:pdim){
        for(i in 1:pdim){
            if(method=='median'){
                pool[i,j] = median(convolutions[[iter]]$value)
                iter = iter + 1 
            }
        }
    }
}