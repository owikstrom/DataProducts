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
    
    myCoord <- data.frame(longitude=c(21.18),latitude =c(64.25))
    limit <-10
    
    output$map <- renderLeaflet({

        
        my_map <- leaflet() %>% 
             addTiles() %>%
             addMarkers(lat = siteList$latitude, lng =siteList$longitude, popup = siteList$short_description_en)
        my_map
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
    
    observeEvent(input$map_click, { 
        myCoord$longitude <- input$map_click$lng
        myCoord$latitude <- input$map_click$lat
        siteList$dist <- distCosine(c(myCoord$longitude,myCoord$latitude), myCoord)/1000
        cat(file=stderr(), myCoord)
    })
    
    observeEvent(input$map_marker_click, { 
        p <- input$map_marker_click  
        print(p)
    })
    
})
