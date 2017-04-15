#Read the bible
library(ggplot2)
library(rvest)
library(stringr)
library(visNetwork)
library(tm)
library(stringi)
library(wordcloud)

#setting the same seed each time ensures consistent look across clouds
set.seed(42)

#Import New testement results from previous web scraping
bible=read.csv("C:/Users/wallworth/Documents/personal/bible/NewTestement.csv", as.is=T, stringsAsFactors = F)

#prep the text source
vs = VectorSource(bible$VerseText)

#create a corpus
corp = Corpus(vs)

toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
toBlank <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x))})

#remove numbers, punctutation and stopwords
corp = tm_map(corp, removeNumbers)
corp = tm_map(corp, removeWords, stopwords("english"))
corp = tm_map(corp, removePunctuation)
corp = tm_map(corp, stripWhitespace)

corp = tm_map(corp, toBlank, "'ve")
corp = tm_map(corp, toBlank, "'re")
corp = tm_map(corp, toBlank, "'s")

corp = tm_map(corp, toBlank, "-")


corp = tm_map(corp, toBlank, "")
corp = tm_map(corp, toSpace, """)
corp = tm_map(corp, toBlank, "'")

corp = tm_map(corp, toBlank, "'")

#create a frequency matrix of each term
dtm = DocumentTermMatrix(corp)

#covert frequency matrix into a normal data frame
freq = colSums(as.matrix(dtm))

head(freq)
#get to top occuring words
ord = order(freq,decreasing=TRUE)
freq[ord[1:10]]

#limit words to be between 4 and 20 characters long
dtm2 = DocumentTermMatrix(corp, control=list(wordLengths=c(4, 20)))
freq2 =  colSums(as.matrix(dtm2))
ord2 = order(freq2,decreasing=TRUE)
freq2[ord2[1:10]]

#find associations accorss documents. each verse should be a document
findAssocs(dtm,"faith",0.1)

#plot histogram
wf=data.frame(term=names(freq2),occurrences=freq2)
wf=subset(wf, freq2>quantile(freq2, 0.99))
p <- ggplot(wf[order(wf$occurrences, decreasing = T),], aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p


#limit words by specifying min frequency
wordcloud(names(freq2),freq2, quantile(freq2, 0.7))
wordcloud(names(freq2),freq2,min.freq=quantile(freq2, 0.7),colors=brewer.pal(6,"Dark2"))

#trying to read the book of matthew in as verses
test=read_html("http://www.biblestudytools.com/matthew/1.html")



mat=data.frame()

for(j in 1:28){    
 i=1
 mverses=T
 verse=c()
 test=read_html(paste0("http://www.biblestudytools.com/matthew/", j ,".html"))
 
 while(mverses){
     temp=read_verse(i)
     if(temp=='NA'){
         mverses=F
     } else { 
        verse[i] = temp
     }
     i=i+1
     #cat(i, sep="\n")
 }
 mat=rbind(mat, data.frame(Book='MAT', Chapter=j, Verse=1:length(verse), VerseText=verse))
}


#prep the text source
vs = VectorSource(mat$VerseText)

#create a corpus
corp = Corpus(vs)

#remove numbers, punctutation and stopwords
corp = tm_map(corp, removeNumbers)
corp = tm_map(corp, removeWords, stopwords("english"))
corp = tm_map(corp, removePunctuation)
corp = tm_map(corp, stripWhitespace)
corp = tm_map(corp, toSpace, "’")
corp = tm_map(corp, toSpace, "‘")
corp = tm_map(corp, toSpace, "-")
corp = tm_map(corp, toSpace, "“")
corp = tm_map(corp, toSpace, "”")
