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

    # Sidebar with a slider input for number of bins
    sidebarLayout(position= 'right',
        sidebarPanel(
            textOutput("coordinates"),
            submitButton("submit",text = "location"),
            sliderInput("sitecount",
                        "Number of sites:",
                        min = 1,
                        max = 10,
                        value = 5),
            tableOutput("view")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map"),
            verbatimTextOutput("summary")
        )
    )
))
