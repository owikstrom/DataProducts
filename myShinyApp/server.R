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
    
    siteList <- read_excel('data/whc-sites-2019.xls') %>% 
                                   select('name_en','short_description_en', 
                                          'date_inscribed','longitude','latitude')
    
    values <- reactiveValues(dist = 0, selected=rep(1000, count(siteList)), lat=40.3, lng=-3.7)
    values$dist <- distCosine(cbind(siteList$longitude,siteList$latitude), c(-3.7,40.3))/1000

   output$map <- renderLeaflet({
    subdf <- siteList %>% 
        bind_cols(dist=values$dist) %>% 
        filter(dist <= input$maxdistance) 

       
    leaflet() %>% 
            addTiles() %>%
            addMarkers(lat = subdf$latitude, 
                    lng =subdf$longitude, 
                    popup = subdf$name_en)
    })
    
    output$coordinates <- renderText({
        paste("Longitude:",values$lng, " Latitude:",values$lat)
    })

    output$view <- renderTable({
        if(!is_null(input$map_marker_click)){    
            site <- input$map_marker_click  
            # cat(file=stderr(), 'hello', str(siteList))
            bind_cols(siteList,dist=values$dist) %>% filter(site$lat == latitude & site$lng == longitude) %>% select(name_en,short_description_en,dist)
        }
    })
    
    observeEvent(input$loc, { 
        values$dist <- distCosine(cbind(siteList$longitude,siteList$latitude), c(values$lng,values$lat))/1000
        # values$selected <- values$dist <=input$maxdistance
        # cat(file=stderr(), str(dim(values$selected)))

    })
    
    observeEvent(input$map_click, { 
        values$lng <- input$map_click$lng
        values$lat <- input$map_click$lat
    })
    
    observeEvent(input$map_marker_click, { 
        selection <- input$map_marker_click
        
        # cat(file=stderr(), 'hello', str(selection))
    })
})
