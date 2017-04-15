#TensorFlow
library(tensorflow)
datasets <- tf$contrib$learn$datasets
mnist <- datasets$mnist$read_data_sets("MNIST-data", one_hot = TRUE)

sess <- tf$InteractiveSession()
library(RCurl)
for (i in 1:100) {
    cat(i, sep='\n')
    batch <- mnist$train$next_batch(50L)
    if (i %% 100 == 0) {
        train_accuracy <- accuracy$eval(feed_dict = dict(x = batch[[1]], y_ = batch[[2]], keep_prob = 1.0))
        cat(sprintf("step %d, training accuracy %g\n", i, train_accuracy))
    }
    train_step$run(feed_dict = dict(x = batch[[1]], y_ = batch[[2]], keep_prob = 0.5))
}

train_accuracy <- accuracy$eval(feed_dict = dict(x = mnist$test$images, y_ = mnist$test$labels, keep_prob = 1.0))
cat(sprintf("test accuracy %g", train_accuracy))

 tf$argmax(y_, 1L)
