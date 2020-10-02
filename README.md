# AscRtain.shiny

This shiny app is a wrapper for functions in the https://github.com/explodecomputer/AscRtain. It is built on the work by Groenwold, Palmer and Tilling (2019) "Conditioning on a mediator" https://osf.io/vrcuf/.

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

