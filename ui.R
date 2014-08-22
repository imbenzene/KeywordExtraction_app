shinyUI(pageWithSidebar(
  
  headerPanel("Keyword Extraction Analysis"),  
  sidebarPanel(width=3,
     fileInput('datafile', 'Upload the csv/txt file',
                accept='csv'),
#      textInput(inputId='words', label='Enter important words/phrases separated by comma (,)',
#                value = ""),
#      tags$head(tags$style(type="text/css", "#words {height: 200px}")),
     downloadButton('downloadData', 'Download')
  ),
  
  mainPanel(
    tabsetPanel(

      tabPanel('Text Corpus',
               dataTableOutput(outputId="table"),
               tags$style(type="text/css", '#myTable tfoot {display:none;}')),
      tabPanel('Words/Phrases',
               dataTableOutput(outputId="table_Words"),
               tags$style(type="text/css", '#myTable tfoot {display:none;}')),      
      tabPanel('Help', HTML(' <h2><b>How to use this Application?</b></h2>

<p><br />
                            </p>
                            
                            <p><b>Step 1</b></p>
                            
                            <p>Upload the transcript with extension (csv/txt). It will be displayed on the right handside.</p>
                            
                            <p><br />
                            </p>
                            
                            
                            <p><b>Step 2</b></p>
                            
                            <p>Click on the Tab- "Words/Phrases" on the right handside.</p>
                            
                            <p><br />
                            </p>
                            
                            <p><b>Step 3</b></p>
                            
                            <p>Download the file using the download button on the LHS.</p>
                            
                            <p><br />
                            </p>
                            
                            <p>(Please provide feedback on my mail-ID &lt;<a href="mailto:ft98@cornell.edu">ft98@cornell.edu</a>&gt; )</p>
                            '))
        
        )
  )
))