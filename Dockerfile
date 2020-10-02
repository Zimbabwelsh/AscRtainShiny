FROM rocker/shiny-verse:3.5.0

# Based on https://github.com/rocker-org/shiny

MAINTAINER Gibran Hemani "g.hemani@bristol.ac.uk"

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinycssloaders', 'latex2exp', 'plotly'), repos='https://cran.rstudio.com/')"

ARG CACHE_DATE
RUN sudo su - -c "R -e \"remotes::install_github('explodecomputer/AscRtain')\""

CMD ["/usr/bin/shiny-server.sh"]

