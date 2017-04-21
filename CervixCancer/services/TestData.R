test = list()
test[[1]] = data.frame()
test[[2]] = data.frame()

for(i in 1:3){
    result = RedDetection("D:/additional/Type_", Class=i, xdim, ydim)
    test[[1]] = rbind(test[[1]],result[[1]])
    test[[2]] = rbind(test[[2]],result[[2]])
}

test_img = cbind(Class = as.factor(apply(test[[2]], 1, which.max)), test[[1]])
