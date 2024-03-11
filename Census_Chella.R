library(shiny)
counties <- readRDS("C:/Users/chellakumars/Desktop/R Shiny/counties.rds")
#head(counties)
#install.packages(c("maps", "mapproj"))
#percent_map(counties$white, "darkgreen", "% White")
library(maps)
library(mapproj)
ui<-fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
  sidebarPanel(
    p("Create demographic maps with information from the 2010 US Census."),
    selectInput(inputId ="si",
                label="Choose a variable to display",
                choices =list("Percent White",
                              "Percent Black",
                              "Percent Hispanic",
                              "Percent Asian"),selected="Percent White"),
    sliderInput(inputId = "r",label="Range of Interest",min=0,max=100,value=c(0,100))
    ),
  mainPanel(
      textOutput("value"),
      textOutput("value1"),
    plotOutput("plot")
              )
    )
  )


# server<-function(input,output){
#   
#  output$value<-renderText(paste("You have Selected",{input$si}))
#   
#  output$value1<-renderText(paste("You have chosen a range that goes from",{input$r[1]},"to",{input$r[2]}))
#   
#   output$plot<-renderPlot({
#     
#     data<-switch(input$si,
#                 "Percent White"= counties$white,
#                 "Percent Black"= counties$black,
#                 "Percent Hispanic"= counties$hispanic,
#                 "Percent Asian"= counties$asian)
#     
#     color<-switch(input$si,
#                   "Percent White"='darkgreen',
#                   "Percent Black"='black',
#                   "Percent Hispanic"='darkorange',
#                   "Percent Asian"='brown')
#     
#     legend<-switch(input$si,
#                    "Percent White"="%White",
#                    "Percent Black"="%black",
#                    "Percent Hispanic"="%Hispanic",
#                    "Percent Asian"="%Asian")
#     
#     percent_map(data, color, legend, input$r[1], input$r[2])
#     
#     })
# }

# A more concise version of the server function:

server<-function(input,output){
  
  output$value<-renderText(paste("You have Selected",{input$si}))
  
  output$value1<-renderText(paste("You have chosen a range that goes from",{input$r[1]},"to",{input$r[2]}))
  
  output$plot<-renderPlot({
    
    data<-switch(input$si,
                 "Percent White"= list(counties$white,'darkgreen',"%White"),
                 "Percent Black"= list(counties$black,'black',"%black"),
                 "Percent Hispanic"= list(counties$hispanic,'darkorange',"%Hispanic"),
                 "Percent Asian"= list(counties$asian,'brown',"%Asian"))
    
    data$min<-input$r[1]
    data$max<-input$r[2]
    
    do.call(percent_map,data)
    
  })
}


shinyApp(ui=ui,server=server)
