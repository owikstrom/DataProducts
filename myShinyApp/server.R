#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(readxl)
library(leaflet)
library(geosphere)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    siteList <- read_excel('data/whc-sites-2019.xls')
    siteList <- siteList %>% select('name_en','short_description_en', 'date_inscribed','longitude','latitude')
    
    # myCoord <- reactiveValues()
    myCoord$longitude <- 21.18
    myCoord$latitude <- 64.25
    limit <-10
    
    output$map <- renderLeaflet({
       
    leaflet() %>% 
            addTiles() # %>%
            # addMarkers(lat = siteList$latitude, 
            #            lng =siteList$longitude, 
            #            popup = siteList$short_description_en)
    })
    
    output$coordinates <- renderText({
        paste("Longitude:",input$map_click$lng, " Latitude:",input$map_click$lat)
    })

    output$summary <- renderPrint({
        paste("Longitude:",input$map_click$lng, " Latitude:",input$map_click$lat)
    })
    
    output$view <- renderTable({
        head(siteList[,1:2],3)
    })
    
    observeEvent(input$submit_click, { 
        cat(file=stderr(), 'clicked')
                siteList$dist <- distCosine(cbind(siteList$longitude,siteList$latitude), c(input$map_click$lng,input$map_click$lat))

    })
    
    # observeEvent(input$map_click, { 
    #    # cat(file=stderr(), 'clicked')
    # })

})
