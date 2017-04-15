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

baseurl="http://www.biblestudytools.com/"

#code run once 

#htmlbible=read_html(baseurl)
#booklinks=html_attr(html_nodes(htmlbible, '.oo'), "href")
#oldtest=html_text(html_nodes(htmlbible, '.oo'))
#newtest=html_text(html_nodes(htmlbible, '.nn'))
#booknames=c(oldtest,newtest)

#urlname=gsub(" ", "-" ,tolower(newtest))
#chapts=c()
#for(i in 1:length(urlname)){
#    chapts[i]=max(as.numeric(stri_extract_all_regex(html_text(html_nodes(read_html(paste0(baseurl, urlname[i], "/")), '.btn-block')),"[0-9]+")), na.rm=T)
#}
#chapts[23]=5
write.csv(data.frame(newtest, urlname, chapts),"C:/Users/wallworth/Documents/personal/bible/gospels.csv")

gospels=data.frame(newtest, urlname, chapts)

#define functions
read_verse = function(i,passage){
    
    result=tryCatch(
        {
            verse[i] = gsub("\n", "", gsub("  ", "", html_text(html_nodes(passage,paste0('.verse-', i)))))        
        },
        error = function(e){
            return('NA')
        })
    return(result)
}

toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})

#each book in the new testament
#to optimize read the whole book in then extract verses
GetChapter=function(chapter,book){
    passage=read_html(paste0(baseurl, book, "/", chapter, ".html"))
    versecount= max(as.numeric(stri_extract_all_regex(html_text(html_nodes(passage, 'strong')),"[0-9]+")), na.rm=T)
    verse=unlist(lapply(1:versecount, FUN=read_verse, passage=passage))
    
    chapter=data.frame(Book=book, Chapter=chapter, Verse=1:length(verse), VerseText=verse)
    return(chapter)
}

biblebkup=bible
bible=data.frame()
#g=9
for(g in 1:50){
    cat(g, sep="\n")
    
    book=as.character(gospels$urlname[g])
    chapters = lapply(1:gospels$chapts[g], FUN=GetChapter, book=book)
    
    bible=rbind(bible, do.call("rbind", chapters))
}
write.csv(bible, paste0('Bible', Sys.Date(), ".csv"))

genesis=lapply(1:50, GetChapter,'genesis')

bible=read.csv("C:/Users/wallworth/Documents/personal/bible/NewTestement.csv", as.is=T, stringsAsFactors = F)
 #prep the text source
 vs = VectorSource(bible$VerseText)
 
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
 corp = tm_map(corp, toSpace, "—")
 corp = tm_map(corp, toSpace, "“")
 corp = tm_map(corp, toSpace, "”")
 
 #create a frequency matrix of each term
 dtm = DocumentTermMatrix(corp)
 
 #covert frequency matrix into a normal data frame
 freq = colSums(as.matrix(dtm))
 
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
