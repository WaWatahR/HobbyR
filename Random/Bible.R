#Read the bible
library(ggplot2)
library(rvest)
library(stringr)
library(visNetwork)
library(tm)

baseurl="https://ebible.org/web/"

htmlbible=read_html(baseurl)
booklinks=html_attr(html_nodes(htmlbible, '.oo'), "href")
oldtest=html_text(html_nodes(htmlbible, '.oo'))
newtest=html_text(html_nodes(htmlbible, '.nn'))
booknames=c(oldtest,newtest)

mat=read_html(paste(baseurl, "MAT01.htm", sep=""))
searchTerm='father of'
baseText=paste(html_text(html_nodes(mat,'.p')), collapse=' ', sep='')

#find the starting index of search for all matches
searchTermIndex=c(1,gregexpr(searchTerm, baseText)[[1]])
father=son=c()

for(i in 1:length(searchTermIndex)){
    #substring the basetext to between the indices
    testText=substring(baseText, searchTermIndex[i], searchTermIndex[i+1])
    if(i==length(searchTermIndex)) testText=substring(baseText, searchTermIndex[i], nchar(baseText))
    
    
    #Get the name before father of
    if(i!=length(searchTermIndex)) father[i] = tail(unlist(str_extract_all(testText,"[[:upper:]]+[[a-z]]+\\b")),1)
    if(i>1) son[i-1] = head(unlist(str_extract_all(testText,"[[:upper:]]+[[a-z]]+\\b")),1)
    
}


nodes=data.frame(id=unique(c(father,son)), label=unique(c(father,son)))
edges=data.frame(from=father, to=son, weight=1)

nodes=rbind(nodes,data.frame(id='Zerah', label='Zerah'))
edges=rbind(edges, data.frame(from='Judah', to="Zerah", weight=1))
    
visNetwork(nodes, edges) %>% visOptions(manipulation = TRUE)  %>% visLegend()

#Read in the book of matthew
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
baseurl='C:/Users/wallworth/Documents/personal/bible/eng-web_html/'
text=''
for(i in 1:28){
 if(i<10) htmlpage =  read_html(paste(baseurl, paste0("MAT0", i, ".htm"), sep=""))
 if(i>=10) htmlpage =  read_html(paste(baseurl, paste0("MAT", i, ".htm"), sep=""))
 newtext = paste(html_text(html_nodes(htmlpage,'.p')), collapse=' ', sep='')
 text= paste(text, newtext)
}

 #prep the text source
 vs = VectorSource(text)
 
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
 findAssocs(dtm2,"said",0.1)
 
 #plot histogram
 wf=data.frame(term=names(freq2),occurrences=freq2)
 p <- ggplot(subset(wf, freq2>50), aes(term, occurrences))
 p <- p + geom_bar(stat="identity")
 p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
 p
 
 library(wordcloud)
 #setting the same seed each time ensures consistent look across clouds
 set.seed(42)
 #limit words by specifying min frequency
 wordcloud(names(freq2),freq2, min.freq=30)
 wordcloud(names(freq2),freq2,min.freq=30,colors=brewer.pal(6,"Dark2"))
 
 #trying to read the book of matthew in as verses
 test=read_html("http://www.biblestudytools.com/matthew/1.html")
 
read_verse = function(i){
    result=tryCatch(
        {
            verse[i] = gsub("\n", "", gsub("  ", "", html_text(html_nodes(test,paste0('.verse-', i)))))        
        },
        error = function(e){
            return('NA')
        })
    return(result)
}
 
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
