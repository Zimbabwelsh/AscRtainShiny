# AscRtain.shiny

This pedagogical shiny app is a wrapper for functions in the https://github.com/explodecomputer/AscRtain package.

It builds on work by Groenwold, Palmer and Tilling (2019) "Conditioning on a mediator" https://osf.io/vrcuf/, and forms part of the  Nature Communications paper "[Collider Bias undermines our understanding of COVID-19 disease risk and severity]( https://www.nature.com/articles/s41467-020-19478-2)" (2020), authored by MRC-IEU colleagues. 

## To run

Install dependencies

```{r}
remotes::install_github("explodecomputer/AscRtain")
install.packages(c("dplyr","shiny", "shinydashboard", "shinycssloaders", "plotly", "latex2exp", "ggplot2"))
```

Run from github:

```r
shiny::runGitHub("Zimbabwelsh/AscRtainShiny", subdir="app")
```


## To deploy

Runs on the [rocker/shiny-verse](https://github.com/rocker-org/shiny) image.

```{r}
docker-compose up -d --no-deps --build
```

