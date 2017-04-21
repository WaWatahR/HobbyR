data <- mx.symbol.Variable("data")
devices<-mx.cpu()
# first conv
conv1 <- mx.symbol.Convolution(data=data, kernel=c(5,5), num_filter=20)
tanh1 <- mx.symbol.Activation(data=conv1, act_type="relu")
pool1 <- mx.symbol.Pooling(data=tanh1, pool_type="max", kernel=c(2,2), stride=c(2,2))
drop1 <- mx.symbol.Dropout(data=pool1,p=0.5)
# second conv
conv2 <- mx.symbol.Convolution(data=drop1, kernel=c(5,5), num_filter=50)
tanh2 <- mx.symbol.Activation(data=conv2, act_type="relu")
pool2 <- mx.symbol.Pooling(data=tanh2, pool_type="max", kernel=c(2,2), stride=c(2,2))
drop2 <- mx.symbol.Dropout(data=pool2,p=0.5)
# first fullc
flatten <- mx.symbol.Flatten(data=drop2)
fc1 <- mx.symbol.FullyConnected(data=flatten, num_hidden=500)
tanh4 <- mx.symbol.Activation(data=fc1, act_type="relu")
drop4 <- mx.symbol.Dropout(data=tanh4,p=0.5)
# second fullc
fc2 <- mx.symbol.FullyConnected(data=drop4, num_hidden=10)
# loss
lenet <- mx.symbol.SoftmaxOutput(data=fc2)
train.array <- train.x
dim(test) <- c(64, 64, 3, ncol(test))
# test.array <- test
# dim(test.array) <- c(28, 28, 1, ncol(test))
mx.set.seed(0)
tic <- proc.time()
start = Sys.time()
model <- mx.model.FeedForward.create(lenet, X=test, y=train.y,
                                         ctx=mx.cpu(), num.round=20, array.batch.size=100,
                                         learning.rate=0.05, momentum=0.9, wd=0.00001,
                                         eval.metric=mx.metric.accuracy,
                                         epoch.end.callback=mx.callback.log.train.metric(100))
finish = Sys.time()