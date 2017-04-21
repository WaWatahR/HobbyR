#Get training data
train = GetImages("D:/train/Type_", xdim, ydim, 20)

#Get additional data
additional = GetImages("D:/additional/Type_", xdim, ydim, 20)

#Combine the two
final = list(append(train[[1]], additional[[1]]), rbind(train[[2]], additional[[2]]))

#Get final dataset with all transformations
final = TransformImages(final)

train.y = as.factor(final$Class)
train.array = data.matrix(final[,1:(ncol(final)-1)])

#train the model
model = randomForest(Class ~ . , data=final)

#Get test data
test = GetImages("D:/test", xdim, ydim, isTestData=T)

summary(predict(model, test, type='response'))
