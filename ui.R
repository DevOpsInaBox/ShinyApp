library(googleVis)
library(lubridate)
library(dplyr)

# global object
raw.data <- read.csv('data/QASReport.csv',stringsAsFactors=FALSE)

shinyUI(
    fluidPage(
        headerPanel("QA Root Cause Analysis"),

        sidebarLayout(
            sidebarPanel(
                h5("We have a good system in place to collect defects. It is always easy to create various types of reports. However, present this data visually using heatmaps give us preliminary analysis before drill into other reports."),
                h5("Sample data preloaded. To ease the understanding, I limited the date range selection to ensure you always get some output"),
                selectInput("testEnv",label="Select Test ENvironment", selected = 'Test/SIT', choices = c('Test/SIT','Development')),
                dateRangeInput('dateRange',
                               label = paste('Select Testing Date: range is limited,',
                                             'dd/mm/yy'),
                               start = '2015-09-21',
                               min = '2015-09-21', max = '2016-01-22',
                               separator = " - ", format = "dd/mm/yy",
                               startview = 'year', language = 'en', weekstart = 1
                ),  submitButton(text="Analysis")
            ),
            mainPanel(
                h3("Analysis Result"),
                h5("Each boxes represent number of defects logged. It gives you a high level idea where shall we spend our time next."),
                tabsetPanel(
                    tabPanel("Tree Map", htmlOutput("gTreeMap"))
                )
            )
        )
    )
)
