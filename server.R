require(plyr) 
require(stringr)
library(tm)
library(RKEA)
library(SnowballC)

shinyServer(function(input, output) {
  
  
  bold<- function(corpus, words)
  {
    print("1");print(corpus);print("2"); print(words);
    data<- corpus
    for(i in 1:length(words))
    {
      data<- gsub(words[i], paste("<b>",paste(words[i],"</b>",""),""), data);
    }
    return(data)
  }
  
  wordtable <- reactive({   
    num<- unique(na.omit(as.numeric(unlist(strsplit(list.files(path = "./raw"), "[^0-9]+")))))
    docs<- Corpus( DirSource (list.dirs(path = "./raw")))
    #docs <- tm_map(tm_map(tm_map(docs, content_transformer(tolower)), removePunctuation), removeNumbers)   
    keys<- list.files(path = "./key")
    keys_num<- unique(na.omit(as.numeric(unlist(strsplit(keys, "[^0-9]+")))))
    
    IndMatch<- list()
    for(i in 1:length(keys_num))
    {
      IndMatch[[i]]= which(num == keys_num[i], arr.ind = TRUE)
    }
    IndMatch<- unlist(IndMatch);
    
    setwd("./key")
    keywords<- list()
    for(i in 1:length(keys_num))
    {
      keywords[[i]]<-  as.character(read.csv(keys[i], header = FALSE, sep = "," , stringsAsFactors=FALSE))
    }
    
    tmpdir <- tempfile()
    dir.create(tmpdir)
    model <- file.path(tmpdir, "crudeModel")
    createModel(docs[IndMatch], keywords, model)
    #print("I love you")
    ################# Later Added Part
    infile <- input$datafile
    a<- Corpus(VectorSource(read.csv(infile$datapath, header = FALSE, sep = "\n")), readerControl = list(language = "en"))
    #a<- Corpus(DataframeSource( as.data.frame(read.csv(infile$datapath, header = FALSE, sep = "\n"))), readerControl = list(language = "en"))
    #print(inspect(a))
    #a<- as.data.frame(read.csv(infile$datapath, header = FALSE, sep = "\n"))
    #a<- Corpus(DataframeSource(a), readerControl = list(language = "en"))
    
    dat<- extractKeywords(a, model);
    #annotatedData<- as.data.frame(matrix("hi", 2, stringsAsFactors = FALSE);
    #rawCorpus<- as.data.frame(read.csv(infile$datapath, header = FALSE, sep = "\n"));
                                  
      data<- as.data.frame(as.character(bold(inspect(a[1]), dat[[1]])), stringsAsFactors = FALSE); 
      data<- rbind(data, as.character(dat))
    
    #data<- annotatedData;
    
    colnames(data)[length(colnames(data))]<- "Highlighted Text";
    rownames(data)<- NULL;
    #print(data);
    data
  })
    
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      #print(1); 
      return(NULL)
      #as.data.frame("Please Upload the File")
    }
      #print(input$datafile);
    as.data.frame(read.csv(infile$datapath, header = FALSE, sep = "\n"))
    })

  output$table <- renderDataTable({
      corpus <- as.data.frame(filedata());
      if (is.null(corpus))return(NULL)
      
      #corpus<- as.corpus.frame(corpus)
      #print(corpus)
      colnames(corpus)[length(colnames(corpus))]<- "Text";
      rownames(corpus)<- NULL;
      if(ncol(corpus)==0 && nrow(corpus)==0) 
      {
       as.data.frame("Please upload the file")}
      else {corpus}
  }, 
  options = list(bFilter=0, bSort=1, bProcessing=0, bPaginate=1, bInfo=0,iDisplayLength = 10, bAutoWidth=0)
  )
  
  output$table_Words <- renderDataTable({
    data<- as.data.frame(wordtable());
    #data<- read.csv("transcribe.csv", header = FALSE, sep = "\n")
    data
  }, 
  options = list(bFilter=0, bSort=1, bProcessing=0, bPaginate=1, bInfo=0,iDisplayLength = 10, bAutoWidth=0)
  )
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('words', '.csv', sep='') },
    content = function(file) {
      write.csv(wordtable(), file, row.names = FALSE,col.names = FALSE)
    }
  )
  
})



