#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)



# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    navbarPage("World Heritage App",
               tabPanel("Main"),
               tabPanel("Help")
    ),

    # Sidebar 
    sidebarLayout(position= 'right',
        sidebarPanel(
            textOutput("coordinates"),
            actionButton("loc",label = "Submit location"),
            sliderInput("maxdistance",
                        "Max distance:",
                        min = 1,
                        max = 1000,
                        value = 100),
            tableOutput("view")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map") 
            # verbatimTextOutput("summary")
        )
    )
))
