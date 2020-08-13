library(shinydashboard)
library(shiny)
library(shinycssloaders)
library(latex2exp)
library(plotly)
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
    menuItem("Exploring Collider Bias", icon = icon("th"),
             menuSubItem("Estimation", tabName="second", icon=icon("bar-chart-o")),
             menuSubItem("Under The Hood", tabName= "third", icon=icon("calculator"))),
    menuItem("Further Resources", tabName="fourth", icon=icon("book"))
    )
),

dashboardBody(
  tabItems(
    tabItem(
      tabName="first",
      withMathJax(),
            
            fluidRow(column(6,
                   h3("Theoretical Motivation for Considering Collider Bias", align="center"),br(),
                   box(width=12,
                       h4(em("Collider Bias and COVID-19"), align="center"),
                       tags$img(src = "COVID Colliders Vert.png", style="display: block; margin-left: auto; margin-right: auto;"),br(),br(),
                       em("Arrows indicate effects of exposure \\((A)\\) and outcome \\((Y)\\) on selection into sample. Dashed lines indicate
                          an induced correlation by conditioning on the sample."
                   )),
                   box(width=12,h4("Development"), 
                       "This app highlights some of the functionality of the",
                       a(href="github.com/explodecomputer/AscRtain", "R Package"), tags$code("AscRtain"), "developed by",
                       a(href="http://www.bristol.ac.uk/social-community-medicine/people/gibran-hemani/index.html", "Gibran Hemani"),
                       "and", a(href="http://www.research.lancs.ac.uk/portal/en/people/tom-palmer(79cb1052-8447-4d1b-8633-bf2a77b0a1e2).html", "Tom Palmer."),
                       br(), br(),
                       "This", a(href="github.com/Zimbabwelsh/AscRtainShiny", "RShiny app"), "was created by",
                        a(href="http://www.bristol.ac.uk/geography/people/gareth-j-griffith/index.html", "Gareth Griffith"), "as a pedagogical supplement
                        to the MedRxiv preprint", a(href="https://www.medrxiv.org/content/10.1101/2020.05.04.20090506v1.full.pdf",
                        "'Collider bias undermines our understanding of COVID-19 disease risk
                        and severity.'"), "written with colleagues at the MRC-IEU, 2020.")
                   ),
            column(6,br(),
                   box(width=12,"Consider the scenario in which we want to test if a given exposure \\((A)\\) influences an outcome \\((Y)\\).
                Consider also that these two variables both independently cause a third variable \\((S)\\). Conditioning on \\(S\\)
                will induce a relationship betweeen \\(A\\) and \\(Y\\). This is known as", strong("Ascertainment Bias"), "or", strong("Collider Bias."),  
                "Whilst it is largely acknowledged that sampling bias may affect representativeness of study findings, it is less
                well understood that conditioning on a collider may substantially bias the estimated association between an exposure and outcome.",
                br(), br(), 
                em("Why is this particularly problematic in the analysis of COVID-19 data?"),
                br(),
                "Because COVID-19 study participants are likely to be strongly non-random and if we consider \\(S\\) to be", strong("selection into
                a COVID-sample"), "then we condition on it by solely considering study participants. More worryingly, it is likely that exposure and
                outcome both predict entry into the COVID-19 samples, meaning we are conditioning on a collider and will produce biased estimates.",
                br(), br(),
                "Take two major sources of COVID-19 data:", strong("COVID-19 cases"), "and", strong("voluntary self-report:"),
                br(),br(),
                "We know", em("COVID testing"), "is non-random in the population. Factors associated with this non-randomness
                such as having pre-existing conditions, or being a key worker may plausibly predict both whether you receive a test", em("and"),
                "your risk of COVID-19. Similarly for", em("self-reporting"), "individual health-anxiety may plausibly predict both whether you
                opt into data collection", em("and"), "your risk of COVID-19.",
                br(),br(),
                "If we estimate population associations based on these ascertained values our results and causal conclusions may also be biased.",
                br(),  br(),
                "Functionally this presents a problem as we cannot know the true effect of \\(A\\) and \\(Y\\) on sample participation.
                However, given known population frequencies for exposure and outcome, we can estimate possible selection 
                effects which would give rise to observed outcomes under a true null. Depending on the range of values returned
                this allows us to make more informed inference about bias in our estimated associations.")
                )
            )
    ),

    tabItem(tabName="second",
            withMathJax(),
            fluidRow(h2("Estimating over a plausible parameter space", align="center"),br(),
              column(3,
                     "This page demonstrates some of the functional utility of the", tags$code ("AscRtain"),
                     a(href="github.com/explodecomputer/AscRtain", "R Package."), "The", tags$code("parameter_space()"), 
                     "function simulates values over the possible parameter space for selection
                     into a study which could give rise to an observed OR between exposure and
                     outcome. This plots the possible selection effects on exposure (\\(\\beta_A\\))
                     and outcome (\\(\\beta_Y\\)) which could give rise to a user-defined observed
                     odds ratio (OR) under a true known OR of 1.",
                     br(),br(),
                     em("Population parameters"), "are defined as follows:", 
                     br(),br(),
                     "\\(P(S=1)\\) denotes the proportion of the population that is in the sample.", 
                     br(),
                     "\\(P(A=1)\\) denotes the proportion of the population for whom the exposure A is true.",
                     br(),
                     "\\(P(Y=1)\\) denotes the proportion of the population for whom the outcome Y is true.", 
                     br(),
                     "\\(P(A \\cap Y)\\) denotes the proportion of the population for whom A and Y are both true.",
                     br(),br(),
                     em("Selection effects"), "are defined as follows:",
                    br(),br(),
                    "\\(\\beta_0\\) denotes the baseline probability of being selected into the sample.",
                    br(),
                    "\\(\\beta_A\\) is the differential effect on probability of being selected into the sample given A=1 is true.", 
                    br(),
                    "\\(\\beta_0\\) is the differential effect on probability of being selected into the sample given Y=1 is true.", 
                    br(),
                    "\\(\\beta_{AY}\\) is the differential effect on probability of being selected into the sample given", em("both"), "A=1 and Y=1 are true."
                     
              ),
              column(3, h5("Observed Relationship"),
                     sliderInput(inputId="num1", label = "Observed OR",
                                 value=2, min=0, max=10, step=0.01),
                     br(),
                     sliderInput(inputId="num10", label = "Unique Parameter Combinations (millions)", 
                                 value=5, min=1, max=10)
              ),
              column(3, h5("Population Parameters"),
                     sliderInput("num2", "\\(P(S=1)\\)",
                                 value = 0.0275, min=0.0001, max=1),
                     sliderInput(inputId="num3", label = "\\(P(A=1)\\)",
                                 value = 0.15, min= 0.0001, max=1),
                     sliderInput(inputId = "num4",label = "\\(P(Y=1)\\)",
                                 value = 0.1, min= 0.0001, max=1),
                     sliderInput(inputId = "num5", label = "\\(P(A \\cap Y)\\)",
                                 value = 0, min = 0, max=1)
              ),
              column(3, h5("Selection Effects"),
                     sliderInput(inputId = "num6", "\\(\\beta_0\\) Range",
                                 value=c(0,0.1), min=0, max=1),
                     selectInput("selection_class", "Fixed \\(\\beta_*\\):", 
                                 c("Exposure", "Outcome", "Interaction", "None")),
                     conditionalPanel(condition = "input.selection_class == 'Exposure'",
                                      sliderInput(inputId = "num7", label = "\\(\\beta_A\\) Value",
                                                  value= 0.1, min=-0.5, max=0.5),
                                      sliderInput(inputId = "num8", label = "\\(\\beta_Y\\) Range", 
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num9", label = "\\(\\beta_{AY}\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5, step=0.01)),
                     conditionalPanel(condition = "input.selection_class == 'Outcome'",
                                      sliderInput(inputId = "num7", label = "\\(\\beta_A\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num8", label = "\\(\\beta_Y\\) Value", 
                                                  value= 0.1, min=-0.5, max=0.5),
                                      sliderInput(inputId = "num9", label = "\\(\\beta_{AY}\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5, step=0.01)),
                     conditionalPanel(condition = "input.selection_class == 'Interaction'",
                                      sliderInput(inputId = "num7", label = "\\(\\beta_A\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num8", label = "\\(\\beta_Y\\) Range", 
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num9", label = "\\(\\beta_{AY}\\) Value",
                                                  value= 0.1, min=-0.5, max=0.5)),
                     conditionalPanel(condition = "input.selection_class == 'None'",
                                      sliderInput(inputId = "num7", label = "\\(\\beta_A\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num8", label = "\\(\\beta_Y\\) Range", 
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5),
                                      sliderInput(inputId = "num9", label = "\\(\\beta_{AY}\\) Range",
                                                  value=c(-0.2,0.2), min=-0.5, max=0.5, step=0.01)),
                     ),
              mainPanel(
                (column(12,
                        em("Note: this plot will only render if the observed OR implies difference (OR!=1)"),
                        conditionalPanel("input.num1 != 1",
                                         withSpinner(plotlyOutput("scatter", width="750px", height="600px"))),
                        br(),
                        "Estimated Parameter Combinations",
                        verbatimTextOutput("params"),
                        "Parameter Combinations plausibly giving rise to \\(P(S=1)\\)",
                        verbatimTextOutput("pS"),
                        "Parameter Combinations plausibly producing observed OR",
                        verbatimTextOutput("or")
                        )
                 )
                )
              )
            
            ),
    
    tabItem(tabName = "third",
            withMathJax(),
            h2("How does it work?"),br(),
            fluidRow(column(12,
                            h4("Under the Hood"), 
                            includeMarkdown("under_the_hood.md")
                            )
                     )
            ),
    
    tabItem(tabName = "fourth",
            h2("Useful Resources"),br(),
            fluidRow(column(5,
                   box(width=12,
                   h4("Key References"),
                   br(),
                   p("Griffith, Gareth J., Tim T. Morris, Matt Tudball, Annie Herbert, Giulia Mancano, Lindsey Pike, Gemma C. Sharp,
                     Tom M. Palmer, George Davey Smith, Kate Tilling, Luisa Zuccolo, Neil M. Davies, and Gibran Hemani. 2020.", 
                     a(href="https://www.medrxiv.org/content/10.1101/2020.05.04.20090506v1.full.pdf", "Collider Bias undermines our
                       understanding of COVID-19 disease risk and severity."), "MedRxiv Preprint"),
                   br(),
                   p("Munafo, Marcus R., Kate Tilling, Amy E. Taylor, David M. Evans, and George Davey Smith. 2018.", 
                     a(href="https://doi.org/10.1093/ije/dyx206", "Collider Scope: When Selection Bias Can Substantially Influence Observed Associations."),
                     "International Journal of Epidemiology 47 (1): 226-35."),
                   br(),
                   p("Miguel Angel Luque-Fernandez, Michael Schomaker, Daniel Redondo-Sanchez, Maria Jose Sanchez Perez, Anand Vaidya,
                     Mireille E Schnitzer. 2019.", a(href="https://academic.oup.com/ije/article/48/2/640/5248195", "Educational Note:
                                                     Paradoxical collider effect in the analysis of non-communicable disease epidemiological data:
                                                     a reproducible illustration and web application."),
                   "International Journal of Epidemiology, 48(2): 640-653."),
                   br(),
                   p("Smith LH, and VanderWeele TJ. 2019.", a(href="https://doi:10.1097/EDE.0000000000001032", "Bounding bias due to selection."),
                     "Epidemiology. 30(4): 509-516."), 
                   br(), 
                   p("Elwert, Felix, and Christopher Winship. 2014.", a(href="https://doi.org/10.1146/annurev-soc-071913-043455",
                                                                        "Endogenous Selection Bias: The Problem of Conditioning on a Collider Variable."),
                     "Annual Review of Sociology 40 (July): 31-53."),
                   br(),
                   p("Cole, Stephen R., Robert W. Platt, Enrique F. Schisterman, Haitao Chu, Daniel Westreich, David Richardson, and Charles Poole. 2010.",
                     a(href="https://doi.org/10.1093/ije/dyp334","Illustrating Bias due to Conditioning on a Collider."), "International Journal of Epidemiology 39 (2): 417-20."),
                   br(),
                   p("Groenwold, Rolf H. H., Tom M. Palmer, Kate Tilling. 2020.", a(href="https://osf.io/vrcuf", "Conditioning on a mediator to adjust
                                                                                    for unmeasured confounding"),  "OSF Preprint")
            )),
            column(5,
                   box(width=12,
                   h4("Pedagogical Resources"),
                   "The following apps give an informative introduction to collider bias in observational data, and allow the
                   user to explore possible relationships.",
                   br(), br(),
                   "Sensitivity Analysis for Selection Bias",a(href="https://selection-bias.herokuapp.com", "website."), "Smith LH, and Vanderweele TJ. 2019.",
                   br(),
                   "CollideR", a(href="https://watzilei.com/shiny/collider/", "app."), "Luque-Fernandez et al. 2019.",
                   br(),
                   "Bias", a(href="https://remlapmot.shinyapps.io/bias-app/", "app."), "Groenwold, Palmer, and Tilling. 2019.",
                   br(),br(),
                   "These R Packages allow a user to specify a DAG and simulate data from it, which can inform the size of bias for a specified model.",
                   br(),
                   tags$code("lavaan"), a(href="http://lavaan.ugent.be", "R Package"),"Rosseel. 2012.",
                   br(),
                   tags$code("dagitty"), a(href="http://www.dagitty.net", "R Package"),"Textor et al. 2016.",
                   br(),
                   tags$code("simMixedDAG"), a(href="https://github.com/IyarLin/simMixedDAG", "R Package"))
                   )
                   ))
            ))
    )



server <- function(input, output) {
  withMathJax()
  output$scatter <- renderPlotly({
    if(input$selection_class == "Exposure"){
      gran <- get_granularity((input$num10)*1000000, input$num6, c(input$num7, input$num7), input$num8, input$num9)
      x <- VBB$new()
      x$parameter_space(
        target_or=input$num1, 
        pS=input$num2, 
        pA=input$num3,
        pY=input$num4,
        pAY=input$num5,
        b0_range=input$num6, 
        ba_range=c(input$num7,input$num7), 
        by_range=input$num8, 
        bay_range=input$num9, 
        granularity=gran
      )
      output$params <- renderText(x$details$parameter_combinations)
      output$pS <- renderText(x$details$within_ps_told)
      output$or <-  renderText(x$details$beyond_or)
      z <- ggplot2::ggplot(x$param, ggplot2::aes(x=by, y=bay, label=ba)) +
              ggplot2::geom_point(ggplot2::aes(colour=b0), size=0.5) +
              ggplot2::xlab("$\\beta_Y$") + ggplot2::ylab("$\\beta_{AY}$") +
              ggplot2::ggtitle(paste("$\\beta_A$=", input$num7)) +
              ggplot2::geom_hline(yintercept=0, size=0.2) +
              ggplot2::geom_vline(xintercept=0, size=0.2)
    ggplotly(z)
    
    } else if(input$selection_class == "Outcome"){
      gran <- get_granularity((input$num10)*1000000, input$num6, input$num7, c(input$num8, input$num8), input$num9)
      x <- VBB$new()
      x$parameter_space(
        target_or=input$num1, 
        pS=input$num2, 
        pA=input$num3,
        pY=input$num4,
        pAY=input$num5,
        b0_range=input$num6, 
        ba_range=input$num7, 
        by_range=c(input$num8,input$num8), 
        bay_range=input$num9, 
        granularity=gran
      )
      z <- ggplot2::ggplot(x$param, ggplot2::aes(x=ba, y=bay, label=by)) +
        ggplot2::geom_point(ggplot2::aes(colour=b0), size=0.5) +
        ggplot2::xlab("$\\beta_A$") + ggplot2::ylab("$\\beta_{AY}$") +
        ggplot2::ggtitle(paste("$\\beta_Y$ =", input$num8)) +
        ggplot2::geom_hline(yintercept=0, size=0.2) +
        ggplot2::geom_vline(xintercept=0, size=0.2)
      ggplotly(z)
      
    } else if (input$selection_class == "Interaction"){
      gran <- get_granularity((input$num10)*1000000, input$num6, input$num7, input$num8, c(input$num9,input$num9))
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
        bay_range=c(input$num9,input$num9), 
        granularity=gran
      )
      z <- ggplot2::ggplot(x$param, ggplot2::aes(x=ba, y=by, label=bay)) +
        ggplot2::geom_point(ggplot2::aes(colour=b0), size=0.5) +
        ggplot2::xlab("$\\beta_A$") + ggplot2::ylab("$\\beta_Y$") +
        ggplot2::ggtitle(paste("$\\beta_{AY}$ =", input$num9)) +
        ggplot2::geom_hline(yintercept=0, size=0.2) +
        ggplot2::geom_vline(xintercept=0, size=0.2)
      ggplotly(z)
    } else {
      gran <- get_granularity((input$num10)*1000000, input$num6, input$num7, input$num8, input$num9)
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
      z <- plot_ly(
      x$param, x=ba, y=by, z=bay,
      color = b0) %>% 
      add_markers() %>% 
        layout(
          scene = list(xaxis=list(title = '$\\beta_A$'),
                       yaxis=list(title = '$\\beta_Y$'),
                       zaxis=list(title = '$\\beta_{AY}'))
        )
      ggplotly(z)
      
      
  #    <- ggplot2::ggplot(x$param, ggplot2::aes(x=ba, y=by, label=bay)) +
  #      ggplot2::geom_point(ggplot2::aes(colour=b0), size=0.5) + 
  #      ggplot2::xlab("$\\beta_A$") + ggplot2::ylab("$\\beta_Y$") + 
  #      ggplot2::labs(colour= "beta_0") +
  #      geom_hline(yintercept=0,  size=0.2) +
  #      geom_vline(xintercept = 0,  size=0.2)
  #    
  #    ggplotly(z)
    }
  
 

})
}
shinyApp(ui = ui, server = server)
