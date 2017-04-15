# Market Basket REST Inteface
data("Groceries")
trans <<- Groceries



#' @get /Recommendation
Recommend = function(lhs  = '', rhs = '', data = trans){
    
    if(lhs != '' & rhs != ''){
        rules = apriori(data, parameter = list(sup = 0.001, conf = 0.5, target="rules"), control = list(verbose=F))
        rules = arules::sort(rules, by="confidence", decreasing=TRUE)
        df=as(rules, "data.frame")
        df$recommendation  = gsub("}", "", gsub(" \\{", '', unlist(lapply(strsplit(as.character(df$rules), '=>'), tail,1))))
        df[1:5,]
    } else if (lhs != '' & rhs == ''){
        rules = apriori(data, parameter=list(supp=0.001,conf = 0.08),
                        appearance = list(default="rhs",lhs= lhs),
                        control = list(verbose=F))
        rules = arules::sort(rules, by="confidence", decreasing=TRUE)
        df=as(rules, "data.frame")
        df$recommendation  = gsub("}", "", gsub(" \\{", '', unlist(lapply(strsplit(as.character(df$rules), '=>'), tail,1))))
        df[1:5,]
    } else if(lhs == '' & rhs != ''){
        rules<-apriori(data, parameter=list(supp=0.001,conf = 0.15,minlen=2),
                        appearance = list(default="lhs",rhs = rhs),
                        control = list(verbose=F))
        rules = arules::sort(rules, by="confidence", decreasing=TRUE)
        df=as(rules, "data.frame")
        df$recommendation  = gsub("}", "", gsub(" \\{", '', unlist(lapply(strsplit(as.character(df$rules), '=>'), tail,1))))
        df[1:5,]
    } else {
        rules = apriori(data, parameter = list(sup = 0.001, conf = 0.5, target="rules"), control = list(verbose=F))
        rules = arules::sort(rules, by="confidence", decreasing=TRUE)
        df=as(rules, "data.frame")
        df$recommendation  = gsub("}", "", gsub(" \\{", '', unlist(lapply(strsplit(as.character(df$rules), '=>'), tail,1))))
        df[1:5,]
    }
}
