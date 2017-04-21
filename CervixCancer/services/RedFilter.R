RedFilter = function(d){
    d$RGB = d$value*255
    ch2 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==2])[2:3])
    ch3 = mean(summary(d$RGB[(d$RGB[d$cc==1]>=160) & d$cc==3])[2:3])
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==1] = 1
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==2] = 0
    d$value[(d$RGB[d$cc==1] >= 160 & d$RGB[d$cc==2] <= ch2 & d$RGB[d$cc==3] <= ch3) & d$cc==3] = 0
    return(d)
}
