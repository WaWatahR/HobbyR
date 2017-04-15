t = Sys.time()
CalcNearestNeighbor = function(input, train, weights, start_col){
    n = ncol(input)
    train1 = train[,start_col:n]
    input1 = input[1,start_col:n]
    nn = unlist(lapply(1:nrow(train), function(i) abs(sum(train1[i,] - input1))))
    return(nn)
}
test = CalcNearestNeighbor(temp, final, 1, 3)
Sys.time()-t