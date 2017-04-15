input = list()
input[[1]] = data.frame()
input[[2]] = data.frame()

for(i in 1:3){
    result = TransposeImportImages(paste0(filepath,i), xdim, ydim)
    input[[1]] = rbind(input[[1]],result[[1]])
    input[[2]] = rbind(input[[2]],result[[2]])
}

final = data.frame()
for(j in 1:3){
    for(i in 1:length(image_names[[j]])){
        cat(i, sep="\n")
        im = load.image(paste0(filepath, j, "/", image_names[[j]][i])) %>% resize(sizex, sizey)
        plot(im) %>% grid
        SkinDetection(im) %>% plot
        isoblur(im, 2) %>% SkinDetection %>% plot
            
        im1 = grayscale(im)
        d = as.data.frame(im)
        d1 = as.data.frame(im1)
        d1$cc = 4
        temp = cbind(Name = image_names[[j]][i], Type=j, data.frame(t(rbind(d, d1)$value)))
        final = rbind(final, temp)
    }
   # sqlSave(dbcon,  final, 'CervixImageData' , rownames=F, append=T)
   # SaveResults(dbcon, final, "CervixImageData", batchsize = 10000)
}
format(object.size(final), "MB")

dedit = d
ddedit[dedit$value < 0.1,]=1
dimg <- as.cimg(dedit)
rasterImage(dimg, 0,0,32,24)


test3 = as.data.frame(t(test))