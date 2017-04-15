#Initialize tensorflow
ClassCount= 3L
xdim = 64L
ydim = 64L
Convstride = 5L
Poolstride = 2L
PixelCount = xdim * ydim
FilterCount = ceiling(PixelCount / (Convstride^2))

sess <- tf$InteractiveSession()
optimizer <- tf$train$GradientDescentOptimizer(0.5)
x <- tf$placeholder(tf$float32, shape(NULL, PixelCount))
y_ <- tf$placeholder(tf$float32, shape(NULL, ClassCount))
b <- tf$Variable(tf$zeros(shape(10L)))
sess$run(tf$global_variables_initializer())

weight_variable <- function(shape) {
    initial <- tf$truncated_normal(shape, stddev=0.1)
    tf$Variable(initial)
}

bias_variable <- function(shape) {
    initial <- tf$constant(0.1, shape=shape)
    tf$Variable(initial)
}

conv2d <- function(x, W) {
    tf$nn$conv2d(x, W, strides=c(1L, 1L, 1L, 1L), padding='SAME')
}

max_pool_2x2 <- function(x) {
    tf$nn$max_pool(x, ksize=c(1L, 2L, 2L, 1L), strides=c(1L, 2L, 2L, 1L), padding='SAME')
}