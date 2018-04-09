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
        tags$link(rel="stylesheet", type="text/css", href = "https://cdn.jsdelivr.net/npm/animate.css@3.5.2/animate.min.css"),
        tags$style("
@import url('https://fonts.googleapis.com/css?family=Alegreya+SC:800|Open+Sans:600');
                   ")
    ),
    uiOutput("infobox"),
    uiOutput("splash"),
    tableOutput("infotable")
    #verbatimTextOutput("debug")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    data <- reactiveFileReader(5000, session, "../rebbl_streamer_tools/data/infobox.rds", readRDS)
    action <- reactiveFileReader(5000, session, "../rebbl_streamer_tools/data/action.rds", readRDS)
    
    output$infobox <- renderUI({
        validate(need(data(), message = F))
        
        if(data()$type == "ladder") return(NULL)
        
    })
    
    output$infotable <- renderTable({
        validate(need(data(), message = F))
        
        if(data()$type != "table") return(NULL)
        
        data()$content
    },
    spacing = "xs")
    
    output$splash <- renderUI({
        validate(need(data(), message = F))
        
        if(data()$type != "splash") return(NULL)
        
        #runjs("$('body').addClass('splash_body')")
        data()$content
    })
    
    output$debug <- renderText(c(as.character(data()), action()))
    
    observeEvent(action(),{
        if(action() == "show") {
            delay(1000, {
                addClass("infotable", class = "animated fadeInLeft")
                addClass("infobox", class = "animated fadeInLeft")
                addClass("splash", class = "animated fadeIn")

                removeClass("infotable", class = "fadeOutLeft")
                removeClass("infobox", class = "fadeOutLeft")
                removeClass("splash", class = "fadeOut")
            })
            
        if(data()$type == "splash") {
            delay(10000, {runjs("$('.identifier').addClass('gone')")})
        }
        }
        
        if(action() == "hide") {
            delay(300, {
                removeClass("infotable", class = "fadeInLeft")
                removeClass("infobox", class = "fadeInLeft")
                removeClass("splash", class = "fadeIn")
                
                addClass("infotable", class = "animated fadeOutLeft")
                addClass("infobox", class = "animated fadeOutLeft")
                addClass("splash", class = "animated fadeOut")
                
                
                #runjs("$('body').removeClass('splash_body')")
            })
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

