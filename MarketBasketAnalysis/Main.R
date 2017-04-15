#Main Script
source("./Services/LoadLibaries.R")
options(digits=2)
# transactions = ReadTransactions(dbcon)

data("Groceries")
trans_id = c(1,1,1,2,2,3,3,3,3,4,4,5,5,5,5)
products = c(sample(c('A','B','C','D'), 3, replace = F),
            sample(c('A','B','C','D'), 2, replace = F),
            sample(c('A','B','C','D'), 4, replace = F),
            sample(c('A','B','C','D'), 2, replace = F),
            sample(c('A','B','C','D'), 4, replace = F))

orders = data.frame(trans_id, products)
t = split(as.character(orders$products), orders$trans_id)

t= Groceries
# convert the data into a “Transaction” object optimized for running the arules algorithm
txn = as(t, "transactions")

# Plot item frequencies
itemFrequencyPlot(txn, topN = 25)

# Build Model
rules = apriori(txn, parameter = list(sup = 0.001, conf = 0.5, target="rules"))

# Inspect Rules
inspect(rules)

# sort out the rules
rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:5])
# Summary
summary(rules)

# What are customers likely to buy before buying whole milk
rules1<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.08), 
               appearance = list(default="lhs",rhs="whole milk"),
               control = list(verbose=F))
rules1<-sort(rules1, decreasing=TRUE,by="confidence")
inspect(rules1[1:5])

# What are customers likely to buy if they purchase whole milk?
rules2<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.15,minlen=2), 
                appearance = list(default="rhs",lhs=c("rice","sugar")),
                control = list(verbose=F))
rules2<-sort(rules2, decreasing=TRUE,by="confidence")
inspect(rules2[1:5])

# Plots
plot(rules, measure=c("support","lift"), shading="confidence")
plot(rules, shading="order", control=list(main ="Two-key plot"))

# Subset rules 
subrules = rules[quality(rules)$confidence > 0.9]

# Interactive graph for investigation
sel = plot(rules, measure=c("support","lift"), shading="confidence", interactive=TRUE);

sel = plot(rules, method="grouped", interactive=TRUE)

plot(rules2, method="graph")
plot(rules2, method="paracoord")
