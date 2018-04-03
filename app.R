#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinyjs)

# Define UI for application that draws a histogram
ui <- fluidPage(
    useShinyjs(),
    tags$head(
        #tags$script(src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"),
        tags$link(rel = "stylesheet", type = "text/css", href = "css/ladder.css"),
        tags$link(rel="stylesheet", type="text/css", href = "https://cdn.jsdelivr.net/npm/animate.css@3.5.2/animate.min.css")
        ),
    uiOutput("infobox"),
    tableOutput("infotable"),
    verbatimTextOutput("debug")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   data <- reactiveFileReader(500, session, "../rebbl_streamer_tools/data/infobox.rds", readRDS)
   action <- reactiveFileReader(500, session, "../rebbl_streamer_tools/data/action.rds", readRDS)
   
   output$infobox <- renderUI({
       validate(need(data(), message = F))
       
       if(data()$type == "ladder") return(NULL)
       
   })
 
    output$infotable <- renderTable({
        validate(need(data(), message = F))
        
        if(data()$type != "table") return(NULL)
        
        data()$content
    },
    spacing = "s")
    
    output$debug <- renderText(c(as.character(data()), action()))
    
    observeEvent(action(),{
        if(action() == "show") {
            addClass("infotable", class = "animated slideInLeft")
            addClass("infobox", class = "animated slideInLeft")
            
            removeClass("infotable", class = "slideOutLeft")
            removeClass("infobox", class = "slideOutLeft")
        }
        
        if(action() == "hide") {
            removeClass("infotable", class = "slideInLeft")
            removeClass("infobox", class = "slideInLeft")
            
            addClass("infotable", class = "animated slideOutLeft")
            addClass("infobox", class = "animated slideOutLeft")
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

