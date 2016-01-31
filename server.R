library(googleVis)
library(lubridate)
library(dplyr)

# global object
raw.data <- read.csv('data/QASReport.csv',stringsAsFactors=FALSE)

shinyServer( function( input, output ){
    # Data creation
    data <- reactive({
        myEnv <- input$testEnv
        startDate <- input$dateRange[1]
        endDate <-  input$dateRange[2]

        # data filteration/processing
        myData <- raw.data[ raw.data$Environment==myEnv,]
        myData$Detected.on.Date <- as.Date(myData$Detected.on.Date, format = "%d/%m/%Y")
        myData <- myData[myData$Detected.on.Date >= startDate & myData$Detected.on.Date <= endDate, ]

        myData[ myData$Root.Cause =='',]$Root.Cause <- 'New Defect'

        myData <- myData %>%
            group_by(Environment, Root.Cause) %>%
            select(Defect.ID, Root.Cause, Environment) %>%
            summarise( Defect.Count =length( Defect.ID) )
        ## Create parent variable
        total=data.frame( Defect.Count=sum(myData$Defect.Count), Environment=NA, Root.Cause=myEnv)
        myData <- rbind(myData,total)
        myData$Defect.Log = log(myData$Defect.Count)
        return(myData)
    })

    output$gTreeMap <- renderGvis({
        myData <- data()
        gTreeMap <- gvisTreeMap(  myData,
                                  idvar="Root.Cause", parentvar = "Environment",
                                  sizevar = "Defect.Count", colorvar = "Defect.Log",
                                  options=list(minColor='#EDF8FB',
                                               midColor='#66C2A4',
                                               maxColor='#006D2C',
                                               headerHeight=20,
                                               showScale=TRUE,
                                               useWeightedAverageForAggregation =TRUE))
        return(gTreeMap)
    })
}
)
