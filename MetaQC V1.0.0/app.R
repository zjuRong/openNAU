#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

suppressMessages(library(shiny))
library(shinythemes)
library(fs)
library(stats)
library(shinyFiles)
library(ggplot2)
library(plotly)
suppressMessages(library(xcms))
library(RColorBrewer)
library(pheatmap)
library(shinydashboard)
# library(flexdashboard)
suppressMessages(library(IPO))
library(shinycssloaders)
# library(shinyBS)
# library(shinyWidgets)
library(shinyjs)
library(mvoutlier)
library(mice)
library(impute)
library(cowplot)
library("ComplexHeatmap")
library(msgps)
library(mice)
library(VIM)
library(stats)
library(dplyr)
library(readr)
# library(ggrepel)
source("app_ui.R")
source("app_server.R")

# Run the application
run_app <- function() {
  shinyApp(ui = ui, server = server)
}
run_app()
