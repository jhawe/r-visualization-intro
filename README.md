# Data visualiuation in R - Introduction

A brief introduction to data visualization in R highlighting some base R functions (`hist` and `boxplot`), 
easy heatmap plotting using `pheatmap` and a high-level introduction to using `ggplot2` and `tidyverse`.

All code is gathered in [analysis.Rmd](analysis.Rmd) and the finished report available under [analysis.html](analysis.html).

The original data used in the markdown was preprocessed using the [data_preparation.R](data_preparation.R) script.

## Docker image

I provide docker image on dockerhub which contains an Rstudio installation based on the [rocker rstudio image](https://hub.docker.com/r/rocker/rstudio) together with the other packages needed for the main markdown to work.

- [link to the docker image on docker hub](https://hub.docker.com/repository/docker/jhawe/rstudio_custom)

> Note: the ggbiplot package is currently missing from the image and has to be installed via `devtools/github`
