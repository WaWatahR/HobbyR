variable_summaries <- function(var, name) {
    with(tf$name_scope("summaries"), {
        mean <- tf$reduce_mean(var)
        tf$summary$scalar(paste0("mean/", name), mean)
        with(tf$name_scope("stddev"), {
            stddev <- tf$sqrt(tf$reduce_mean(tf$square(var - mean)))
        })
        tf$summary$scalar(paste0("stddev/", name), stddev)
        tf$summary$scalar(paste0("max/", name), tf$reduce_max(var))
        tf$summary$scalar(paste0("min/", name), tf$reduce_min(var))
        tf$summary$histogram(name, var)
    })
}

# Reusable code for making a simple neural net layer.
#
# It does a matrix multiply, bias add, and then uses relu to nonlinearize.
# It also sets up name scoping so that the resultant graph is easy to read,
# and adds a number of summary ops.
#
nn_layer <- function(input_tensor, input_dim, output_dim,
                     layer_name, act=tf$nn$relu) {
    with(tf$name_scope(layer_name), {
        # This Variable will hold the state of the weights for the layer
        with(tf$name_scope("weights"), {
            weights <- weight_variable(shape(input_dim, output_dim))
            variable_summaries(weights, paste0(layer_name, "/weights"))
        })
        with(tf$name_scope("biases"), {
            biases <- bias_variable(shape(output_dim))
            variable_summaries(biases, paste0(layer_name, "/biases"))
        })
        with (tf$name_scope("Wx_plus_b"), {
            preactivate <- tf$matmul(input_tensor, weights) + biases
            tf$summary$histogram(paste0(layer_name, "/pre_activations"), preactivate)
        })
        activations <- act(preactivate, name = "activation")
        tf$summary$histogram(paste0(layer_name, "/activations"), activations)
    })
    activations
}

hidden1 <- nn_layer(x, 784L, 500L, "layer1")

with(tf$name_scope("dropout"), {
    keep_prob <- tf$placeholder(tf$float32)
    tf$summary$scalar("dropout_keep_probability", keep_prob)
    dropped <- tf$nn$dropout(hidden1, keep_prob)
})

y <- nn_layer(dropped, 500L, 10L, "layer2", act = tf$nn$softmax)

with(tf$name_scope("cross_entropy"), {
    diff <- y_ * tf$log(y)
    with(tf$name_scope("total"), {
        cross_entropy <- -tf$reduce_mean(diff)
    })
    tf$summary$scalar("cross entropy", cross_entropy)
})

with(tf$name_scope("train"), {
    optimizer <- tf$train$AdamOptimizer(1e-4)
    train_step <- optimizer$minimize(cross_entropy)
})

with(tf$name_scope("accuracy"), {
    with(tf$name_scope("correct_prediction"), {
        correct_prediction <- tf$equal(tf$arg_max(y, 1L), tf$arg_max(y_, 1L))
    })
    with(tf$name_scope("accuracy"), {
        accuracy <- tf$reduce_mean(tf$cast(correct_prediction, tf$float32))
    })
    tf$summary$scalar("accuracy", accuracy)
})

# Merge all the summaries and write them out to /tmp/mnist_logs (by default)
merged <- tf$summary$merge_all()
train_writer <- tf$summary$FileWriter(file.path("C:/R/CervixCancer/tensorboard/", "train"),
                                      sess$graph)
test_writer <- tf$summary$FileWriter(file.path("C:/R/CervixCancer/tensorboard/", "test"))
sess$run(tf$global_variables_initializer())

feed_dict <- function(train) {
    if (train || FLAGS$fake_data) {
        batch <- mnist$train$next_batch(100L, fake_data = FLAGS$fake_data)
        xs <- batch[[1]]
        ys <- batch[[2]]
        k <- FLAGS$dropout
    } else {
        xs <- mnist$test$images
        ys <- mnist$test$labels
        k <- 1.0
    }
    dict(x = xs,
         y_ = ys,
         keep_prob = k)
}

for (i in 1:FLAGS$max_steps) {
    if (i %% 10 == 0) { # Record summaries and test-set accuracy
        result <- sess$run(list(merged, accuracy), feed_dict = feed_dict(FALSE))
        summary <- result[[1]]
        acc <- result[[2]]
        cat(sprintf("Accuracy at step %s: %s", i, acc))
        test_writer$add_summary(summary, i) 
    } else { # Record train set summaries, and train
        result <- sess$run(list(merged, train_step), feed_dict = feed_dict(TRUE))
        summary <- result[[1]]
        train_writer$add_summary(summary, i)
    }
}