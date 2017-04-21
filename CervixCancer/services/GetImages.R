GetImages = function(filepath, xdim, ydim, img_count = 0, isTestData=F){
    if(!isTestData){
        
        images = list()
        classes = data.frame()
        
        for(i in 1:3){
            result = RedDetection(filepath, Class=i, xdim, ydim, img_count)
            images = append(images,result[[1]])
            classes = rbind(classes,result[[2]])
        }
        
        input_img = list(images, classes)#cbind(Class = as.factor(apply(classes, 1, which.max)), input[[1]])
        return(input_img)
    } else {
        result = RedDetection(filepath, Class=0, xdim, ydim)
    }
}

