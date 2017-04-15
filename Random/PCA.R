# PCA
library(pca)
data("crimtab") #load data
head(crimtab)[1] #show sample data
dim(crimtab) #check dimensions
str(crimtab) #show structure of the data
sum(crimtab) 
colnames(crimtab)
colnames(crimtab)=1:22
apply(crimtab,2,var) #check the variance accross the variables
pca =prcomp(crimtab) #applying principal component analysis on crimtab data
par(mar = rep(2, 4)) #plot to show variable importance
plot(pca) 
'below code changes the directions of the biplot, if we donot include
the below two lines the plot will be mirror image to the below one.'
pca$rotation=-pca$rotation
pca$x=-pca$x
biplot (pca , scale =0) #plot pca components using biplot in r
