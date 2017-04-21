library(shiny)
library(imager)
library(foreach)
library(doParallel)
library(reshape2)

source('pagerui.R')
cl = makeCluster(3)
registerDoParallel(cl)
img_rows = 3
img_cols = 6
xdim = ydim = 128
sxdim = sydim = 56

ImageList = ImageMetadata("D:/train/Type_")
Type1Images = ImageList[[1]][1:10]
Type2Images = ImageList[[2]][1:10]
Type3Images = ImageList[[3]][1:10]

# im1 = list()
# for(i in 1:22){
#     im1[[length(im1)+1]] = load.image(paste0("D:/train/Type_1/", ImageList[[1]][i])) %>% resize(xdim, ydim)
# }
# im2=im3=im1
# WeightMatrix = function(xdim, ydim){
#     wmatrix = matrix(0.5, xdim, ydim)
#     #top_left_anchor = seq(1, xdim*ydim, by = (xdim+1))
#     #top_right_anchor = seq(xdim, xdim*(xdim-1)+1, (xdim-1))
#     #bottom_right_anchor = seq(xdim*ydim, 1, by =-(xdim+1))
#     #bottom_left_anchor = seq(xdim*(xdim-1)+1, xdim, by = -(xdim-1))
#     
#     step = round(xdim / 8,0)
#     wmatrix[step:(ydim-step+1), step:(xdim-step+1)] = 1
#     wmatrix[(2*step):(ydim-(2*step)+1), (2*step):(xdim-(2*step)+1)] = 1.5
#     wmatrix[(3*step):(ydim-(3*step)+1), (3*step):(xdim-(3*step)+1)] = 2
#     
#     return(wmatrix)
# }
# weight_matrix = WeightMatrix(xdim, ydim)
# wm = setNames(melt(weight_matrix), c('x', 'y', 'weight'))

for(i in 1:3){
    images = foreach(w = 1:10, .packages = c('imager', 'stringr', 'reshape2')) %dopar% {
        load.image(paste0("D:/train/Type_", i, "/", ImageList[[i]][w])) %>% resize(xdim, ydim)
    }
    if(i==1) im1 = images
    if(i==2) im2 = images
    if(i==3) im3 = images
}

RedFilter = function(d){
    d$RGB = d$value*255
    ch2 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==2])[2:3])
    ch3 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==3])[2:3])
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==1] = 1
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==2] = 0
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==3] = 0
    return(d)
}

RedRegionSelect = function(d, sxdim, sydim, wmatrix){
    values= data.frame()
    for(i in 1:(xdim-sxdim)){
        for(j in 1:(ydim-sydim)){
            values[i,j] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1)
            #plot(im, main = values[i,j])
            #rect(i, j,(i+sxdim), (j+sydim), border="white", lwd=2.5)
            #Sys.sleep(0.5)
        }
    }
    
    ystart = max(col(values)[values==max(values)])
    xstart = which.max(values[,ystart])
    
    #plot(im)
    #rect(xstart, ystart,(xstart+sxdim), (ystart+sydim), border="white", lwd=2.5)
    newd = d[d$x >= xstart & d$x <= (xstart+sxdim-1) & d$y >= ystart & d$y <= (ystart+sydim-1),]
    newd$x = newd$x - xstart + 1
    newd$y = newd$y - ystart + 1
    
    return(newd)
}


