library(shinydashboard)
library(shiny)
library(tidyverse)
library(shinycssloaders)
#rm(list=ls())

#remotes::install_github("daattali/shinycssloaders")
#remotes::install_github("explodecomputer/AscRtain")
library(AscRtain)


ui <- dashboardPage(
  dashboardHeader(title="Using AscRtain"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Theory", tabName="first", icon = icon("book-reader")),
      menuItem("Estimation", tabName="second", icon=icon("calculator")),
      menuItem("Documentation", tabName="third", icon=icon("file-code"))
      )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName="first", 
              h2("Underpinning Theory"),
              box("Consider the scenario in which we want to test if a given exposure influences an outcome. Consider also 
                  that these two variables both independently cause a third variable. Conditioning on the third variable
                  will induce a relationship betweeen the exposure and outcome. This is known as", strong("Ascertainment Bias"), "or", strong("Collider Bias."),  
                  "Whilst it is largely acknowledged that sampling bias may affect representativeness of study findings, it is less
                  well understood that conditioning on a collider may substantially bias the estimate of association between the exposure and outcome.",
                  br(),br(),
                  "If we consider this third variable to be", strong("selection into a study"), "then we implicitly condition 
                  on it by solely considering study participants.", 
                  br(), br(), 
                  "This is currently particularly problematic in the analysis of COVID-19 data. Let's consider two major current sources
                  of COVID-19 data. These are", strong("COVID-19 case status and self-reported voluntary data collection."),
                  "If we consider each of these in turn, there are relatively simple scenarios where we could imagine selection into these
                  datasets as conditional on exposures of interest within the data. We know that COVID testing is already non-random within the
                  population, pre-existing conditions, key worker employment and healthcare accessibility are all likely to predict entry into the sample.
                  Similarly for self-reporting, commonly collected by phone app, individuals with greater levels of health anxiety may be more likely to be in the sample. If we estimate
                  population associations based on these ascertained values under collider bias we are likely to bias our results.",
                  br(), br(), 
                  "Functionally this presents a problem as we are unable to know what the true effect of covariates on sample participation
                  are with certainty. However, given known population values for exposure and outcome, we can estimate possible selection 
                  effects which may give rise to observed outcomes under a true null. Depending on the range of values which are returned by 
                  consideration, this can allow us to make more informed inference about the possible bias in our estimated associations."),
              
              box(
                h4("Collider Bias in COVID-19"), 
                    tags$img(src = "COVID Colliders.png",
                       width = "700px", height = "300px")
                    ),
              
              box(h4("References"),
                  p("Groenwold et al. 2020, 'Conditioning on a mediator to adjust for unmeasured confounding',  OSF Preprint"),
                  a(href="https://osf.io/vrcuf", "https://osf.io/vrcuf"),
                  br(), br(),
                  p("AscRtain documentation on Github"),
                  a(href="github.com/explodecomputer/AscRtain", "github.com/explodecomputer/AscRtain"))),
      tabItem(tabName="second",
              fluidRow(
                column(2, p("This shiny app demonstrates some of the functional",
                                 "utility of the", strong("AscRtain"), " R Package. The function",
                                 "here explores the possible parameter space which",
                                 "could give rise to an observed OR between exposure",
                                 "and outcome. This plots the possible selection effects",
                                 "(entered as BA and BY) which could give rise to an",
                                 "observed OR under a true known OR of 1.")),
                column(3, h5("Observed Relationship"),
                       sliderInput(inputId="num1", label = "Observed OR",
                       value=2, min=0, max=10, step=0.01),
                       br(),
                       sliderInput(inputId="num10", label = "Granularity", 
                       value=100, min=10, max=200)
                       ),
                column(3, h5("Population Parameters"),
                       sliderInput(inputId="num2", label = "P(S=1)",
                                   value = 0.0275, min=0.0001, max=1),
                       sliderInput(inputId="num3", label = "P(A=1)",
                                   value = 0.15, min= 0.0001, max=1),
                       sliderInput(inputId = "num4",label = "P(Y=1)",
                                   value = 0.1, min= 0.0001, max=1),
                       sliderInput(inputId = "num5", label = "P(A=1 & Y=1)",
                                   value = 0, min = 0, max=1)
                       ),
                column(3, h5("Selection Effects"),
                       sliderInput(inputId = "num6", label = "b0_range",
                                   value=c(0,0.1), min=0, max=1),
                       sliderInput(inputId = "num7", label = "ba_range",
                                   value=c(-0.2,0.2), min=-0.5, max=0.5),
                       sliderInput(inputId = "num8", label = "by_range", 
                                   value=c(-0.2,0.2), min=-0.5, max=0.5),
                       sliderInput(inputId = "num9", label = "bay_range",
                                   value=c(0,0), min=0, max=1)
                       ),
              mainPanel(
                fluidRow(column(6, withSpinner(plotOutput("scatter", width="750px", height="600px"), type=4)))
              )),
      tabItem(tabName="third",
              h2("Documentation"),br(), br(),
              fluidRow(
                 box(column(4,p("AscRtain documentation on Github"),
                              a(href="github.com/explodecomputer/AscRtain", "github.com/explodecomputer/AscRtain"))),
                 box(column(4,p("AscRtain Shiny App source code"),
                              a(href="github.com/Zimbabwelsh/AscRtainShiny", "github.com/Zimbabwelsh/AscRtainShiny")))
              )
      )
    )
  )
  )
)




server <- function(input, output) {
  
 
  
  output$scatter <- renderPlot({
    
#    get_granularity <- function(target, b0_range, ba_range, by_range, bay_range)
#    {n <- sapply(c(b0_range, ba_range, by_range, bay_range), 
#                 function(x) length(x) > 1 %>% sum	target = gran^n
#                 
#                 granularity <- target^(1/n)
#                 return(granularity)
#    }
    
    x <- VBB$new()
    x$parameter_space(
           target_or=input$num1, 
           pS=input$num2, 
           pA=input$num3,
           pY=input$num4,
           pAY=input$num5,
           b0_range=input$num6, 
           ba_range=input$num7, 
           by_range=input$num8, 
           bay_range=input$num9, 
           granularity=input$num10
           #granularity=get_granularity
           
           #granularity=input$num10
           
           
           #
           
           #granularity = number of values in the range of b0, ba, by, bay
           # say given number of values to simulate over. if b0, ba, by populated
           # then there are 100*100*100 values to simulate, if bay range is populated
           # then increases by a factor of 100 - meaning that simulation can become
           # very slow.
           # create a line of code that calculates the most effective granularity 
           # that maximises estimates whilst maintaining computational ease.
           # 1,000,000 parameter estimates runs quickly, 100,000,000 does not.
           # Aim for computational efficiency of 5,000,000 parameter combinations
      )
    x$scatter()
    })
#  s <- sum(c(input$num7, input$num8, input$num9)!=0)
 # output$sum <- renderPrint({"s"})

}

shinyApp(ui = ui, server = server)