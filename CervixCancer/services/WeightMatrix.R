WeightMatrix = function(xdim, ydim){
    wmatrix = matrix(0.3, xdim, ydim)
    #top_left_anchor = seq(1, xdim*ydim, by = (xdim+1))
    #top_right_anchor = seq(xdim, xdim*(xdim-1)+1, (xdim-1))
    #bottom_right_anchor = seq(xdim*ydim, 1, by =-(xdim+1))
    #bottom_left_anchor = seq(xdim*(xdim-1)+1, xdim, by = -(xdim-1))
    
    step = round(xdim / 8,0)
    wmatrix[step:(ydim-step+1), step:(xdim-step+1)] = 0.5
    wmatrix[(2*step):(ydim-(2*step)+1), (2*step):(xdim-(2*step)+1)] = 1
    wmatrix[(3*step):(ydim-(3*step)+1), (3*step):(xdim-(3*step)+1)] = 3
    
    return(wmatrix)
}