# metaQC
___
Metabolism Quality Control (metaQC) uses the Shiny[14] module in the R language to realize the visualization operation of the analysis process, and inserts the extraction and analysis program of raw data into the visualization operation process. 


## Development environment
___
* R version 4.1.1 (2021-08-10)
* Rtools 4.0

## Prerequisites
___
### Install required packages

```R

install.packages('shiny')
install.packages('shinythemes')
install.packages('fs')
install.packages('shinyFiles')
install.packages('ggplot2')
install.packages('plotly')
install.packages("BiocManager")
BiocManager::install('xcms')
install.packages('RColorBrewer')
install.packages('pheatmap')
install.packages('shinydashboard')
install.packages('flexdashboard')
BiocManager::install("IPO")
install.packages('shinycssloaders')
install.packages('shinyBS')
install.packages('shinyWidgets')
install.packages('shinyjs')
install.packages('mvoutlier')
install.packages('mice')
install.packages('impute')
install.packages('cowplot')
install.packages('VIM')
install.packages('msgps')
BiocManager::install("ComplexHeatmap")
install.packages("dplyr")
BiocManager::install("multtest")
install.packages("readr")
#install.packages("ggrepel")
```

### Load required packages
```R

suppressMessages(library(shiny))
library(shinythemes)
library(fs)
library(shinyFiles)
library(ggplot2)
library(plotly)
suppressMessages(library(xcms))
library(RColorBrewer)
library(pheatmap)
library(shinydashboard)
#library(flexdashboard)
suppressMessages(library(IPO))
library(shinycssloaders)
#library(shinyBS)
#library(shinyWidgets)
library(shinyjs)
library(mvoutlier)
library(mice)
library(impute)
library(cowplot)
library("ComplexHeatmap")
```

## Installation
___

### 1. Install R and Rstudio
### 2. Indtsll software:
* method 1 (Windows)  
Double-click [MetaQC.Rproj] to open the software directly.  
* method 2 (Linux)  
sudo su -c "R -e \"install.packages('shiny',repos='https://cran.rstudio.com/')"  "

	-Ubuntu    
--sudo apt-get install gdebi-core  
--wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.17.973-amd64.deb  
--sudo gdebi shiny-server-1.5.17.973-amd64.deb  
-RedHat/CentOS   
--wget https://download3.rstudio.org/centos7/x86_64/shiny-server-1.5.17.973-x86_64.rpm  
--sudo yum install --nogpgcheck shiny-server-1.5.17.973-x86_64.rpm  

	-Configure the file  [/etc/shiny-server/shiny-server.conf]  
	```
	location / {
	run_as shiny; ##user name
	}
	
	location /metaQC{
		app_dir /home/shiny/metaQC;
	}
	```

	-Open [IP/metaQC].


## Examples
___
### 1  Select test data in [data/raw_data/test]
### 2 run metaQC software and refer to the document [../Document.pdf]
## Built With
___
* [R](https://www.r-project.org/)
* [RStudio](https://www.rstudio.com/)

