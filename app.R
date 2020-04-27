library(shinydashboard)
library(shiny)
library(shinycssloaders)
library(dplyr)
library(AscRtain)

get_granularity <- function(target, b0_range, ba_range, by_range, bay_range)
{
  n <- sapply(list(b0_range, ba_range, by_range, bay_range), function(x) x[1] != x[2]) %>% sum
  granularity <- target^(1/n)
  return(round(granularity))
}


ui <- dashboardPage(
  dashboardHeader(title="Using AscRtain"),
  

dashboardSidebar(
  sidebarMenu(
    menuItem("Theory", tabName="first", icon = icon("book-reader")),
    menuItem("Estimation", tabName="second", icon=icon("calculator"))
  )
),

dashboardBody(
  
  tabItems(
    tabItem(
      tabName="first", 
            column(5,(verticalLayout(
                   h2("Theoretical Motivation for Considering Collider Bias"),br(),
                   box(width=12,"Consider the scenario in which we want to test if a given exposure influences an outcome. Consider also
                that these two variables both independently cause a third variable. Conditioning on the third variable
                will induce a relationship betweeen the exposure and outcome. This is known as", strong("Ascertainment Bias"), "or", strong("Collider Bias."),  
                "Whilst it is largely acknowledged that sampling bias may affect representativeness of study findings, it is less
                well understood that conditioning on a collider may substantially bias the estimate of association between the exposure and outcome.",
                br(),br(),
                "Crucially for COVID-19 examples: if we consider this third variable to be", strong("selection into a study"), "then we are conditioning on it 
                by solely considering study participants.", 
                br(), br(), 
                em("Why is this currently particularly problematic in the analysis of COVID-19 data?"),
                br(), br(),
                "Let's consider two major current sources of COVID-19 data:", strong("COVID-19 case status"), "and", strong("self-reported voluntary data collection."),
                "If we consider each of these in turn, there are relatively simple scenarios where we could imagine selection into these
                datasets as conditional on exposures of interest within the data. We know that COVID testing is already non-random within the
                population, pre-existing conditions, key worker employment and healthcare accessibility are all likely to predict entry into the sample.
                Similarly for self-reporting, commonly collected by phone app, individuals with greater levels of health anxiety may be more likely to be in the sample. If we estimate
                population associations based on these ascertained values under collider bias then our results and causal conclusions may also be biased.",
                br(), br(), 
                "Functionally this presents a problem as we cannot know what the true effect of covariates on sample participation.
                However, given known population values for exposure and outcome, we can estimate possible selection 
                effects which would give rise to observed outcomes under a true null. Depending on the range of values which are returned by 
                consideration, this can allow us to make more informed inference about the possible bias in our estimated associations."),
                br(), 
            box(width=12,h4("Development"), 
                "This", a(href="github.com/Zimbabwelsh/AscRtainShiny", "RShiny app"), "was created by", a(href="http://www.bristol.ac.uk/geography/people/gareth-j-griffith/index.html", "Gareth Griffith"), "as a pedagogical supplement
                to the BioRxiv preprint", a(href="github.com/explodecomputer/AscRtain", "'Preprint title'"), "by Hemani et al. 2020.",
                br(), br(),
                "The app highlights some of the functionality of the",
                a(href="github.com/explodecomputer/AscRtain", "R Package"), tags$code("AscRtain"), "developed by", a(href="http://www.bristol.ac.uk/social-community-medicine/people/gibran-hemani/index.html", "Gibran Hemani"),
                "and", a(href="http://www.research.lancs.ac.uk/portal/en/people/tom-palmer(79cb1052-8447-4d1b-8633-bf2a77b0a1e2).html", "Tom Palmer.")
                )
            )
            )
    ),
            column(6,verticalLayout(br(),
                   box(width=12,
                     h5( "Collider Bias and COVID-19", align="center"),
                     tags$img(src = "COVID Colliders.png",
                              width = "740px", height = "280px"),
                     "Arrows indicate effects of A (exposure) and Y (outcome) on selection into sample. Dashed lines indicate an induced correlation by conditioning on the sample."
                     ),
                   box(width=12,h4("Key References"),
                       p("Munafo, Marcus R., Kate Tilling, Amy E. Taylor, David M. Evans, and George Davey Smith. 2018.", a(href="https://doi.org/10.1093/ije/dyx206", "Collider Scope: When Selection Bias Can Substantially Influence Observed Associations."), "International Journal of Epidemiology 47 (1): 226-35."),
                       br(),
                       p("Miguel Angel Luque-Fernandez, Michael Schomaker, Daniel Redondo-Sanchez, Maria Jose Sanchez Perez, Anand Vaidya, Mireille E Schnitzer. 2019.", a(href="https://academic.oup.com/ije/article/48/2/640/5248195", "Educational Note: Paradoxical collider effect in the analysis of non-communicable disease epidemiological data: a reproducible illustration and web application"),
                       "International Journal of Epidemiology, 48(2): 640-653.", "Associated Educational CollideR", a(href="https://watzilei.com/shiny/collider/", "app.")),
                       br(),
                       p("Smith LH, and VanderWeele TJ. 2019.", a(href="https://doi:10.1097/EDE.0000000000001032", "Bounding bias due to selection."), "Epidemiology. 30(4): 509-516.", 
                       br(), 
                         "Associated Sensitivity Analysis for Selection Bias",a(href="https://selection-bias.herokuapp.com", "website.")),
                       br(),
                       p("Elwert, Felix, and Christopher Winship. 2014.", a(href="https://doi.org/10.1146/annurev-soc-071913-043455","Endogenous Selection Bias: The Problem of Conditioning on a Collider Variable."), "Annual Review of Sociology 40 (July): 31-53."),
                       br(),
                       p("Cole, Stephen R., Robert W. Platt, Enrique F. Schisterman, Haitao Chu, Daniel Westreich, David Richardson, and Charles Poole. 2010.", a(href="https://doi.org/10.1093/ije/dyp334","Illustrating Bias due to Conditioning on a Collider."), "International Journal of Epidemiology 39 (2): 417-20."),
                       br(),
                       p("Groenwold, Rolf H. H., Tom M. Palmer, Kate Tilling. 2020.", a(href="https://osf.io/vrcuf", "Conditioning on a mediator to adjust for unmeasured confounding"),  "OSF Preprint")
                   )
            ))
    ),

    tabItem(tabName="second",
            fluidRow(h2("Estimating over a plausible parameter space", align="center"),br(),
              column(3, p("This calculation demonstrates some of the functional",
                          "utility of the", strong("AscRtain"), " R Package. The", strong("parameter_space()"),
                          "function simulates values over the possible parameter space for selection into a study which",
                          "could give rise to an observed OR between exposure",
                          "and outcome. This plots the possible selection effects",
                          "(entered as BA and BY) which could give rise to an",
                          "observed odds ratio (OR) under a true known OR of 1."),
                     br(),
                     p("The", em("population parameters"), "here are defined as follows:", br(),
                       strong("P(S=1)"), "denotes the proportion of the population that is in the sample.", br(), 
                       strong("P(A=1)"), "denotes the proportion of the population for whom the exposure A is true.", br(),
                       strong("P(Y=1)"), "denotes the proportion of the population for whom the outcome Y is true.", br(), 
                       strong("P(A=1 & Y=1)"), "denotes the proportion of the population for whom A and Y are both true.", br(), br(),
                       "The", em("selection effects"),  "are defined as follows:", br(),
                       strong("b0"), "is the baseline probability of being selected into the sample.", br(), 
                       strong("ba"),"is the effect on selection into the sample given A=1 is true.", br(),
                       strong("by"),"is the effect on selection into the sample given Y=1 is true.", br(),
                       strong("bay"),"is the effect on selection into the sample given A=1 and Y=1 are both true."
                     )),
              
              column(3, h5("Observed Relationship"),
                     sliderInput(inputId="num1", label = "Observed OR",
                                 value=2, min=0, max=10, step=0.01),
                     br(),
                     sliderInput(inputId="num10", label = "Unique Parameter Combinations (millions)", 
                                 value=5, min=1, max=10)
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
                fluidRow(column(12, align="center", withSpinner(plotOutput("scatter", width="750px", height="600px"), type=4)))
              )
              )
            )
    )
)
)


server <- function(input, output) {
  
  output$scatter <- renderPlot({
    
    gran <- get_granularity((input$num10)*1000000, input$num6, input$num7, input$num8, input$num9)
    print(gran)
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
           granularity=gran
      )
    x$scatter()
    })

}

shinyApp(ui = ui, server = server)
