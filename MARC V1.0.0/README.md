# MARC
___
Metabolism Analysis and Resources Central (MARC) is based on a cloud server for data analysis and processing. This section is divided into the front end, back end, and cloud analysis strategy. The front end is based on the bootstrap framework (www.bootcss.com) for the front-end layout and communication with the back-end. The back-end uses PHP for database access, file operation, and data transmission with the front-end. The cloud analysis strategy uses a socket as the interface to realize the call of cloud analysis software, the acquisition of tasks and the corresponding data analysis, and the analysis results through the intermediate log file for mutual result authentication and process identification. 


## Development environment
___
* Apache/2.4.29 (Ubuntu)
* PHP 7.2.24-0ubuntu0.18.04.7 
* MySQL Server version: 5.7.33-0ubuntu0.18.04.1
* R version 3.6.3 (2020-02-29)



## Prerequisites
___
Install required packages

```R
### Normalization
install.packages("BiocManager")
BiocManager::install("sva")
install.packages("dplyr")
install.packages("rmarkdown")
install.packages("cowplot")
BiocManager::install("mixOmics")
install.packages("fpc")
install.packages("cluster")
install.packages("R.utils")
install.packages("gg.gap")
install.packages("bookdown")
install.packages("MetaboQC")
install.packages("knitr")


### process
BiocManager::install("ropls")
install.packages("venn")
install.packages("ggpolypath")
BiocManager::install("clusterProfiler")
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("ggrepel")
install.packages("ggnewscale")
```

## Installation
___
### 1. install LAMP environment
### 2. Configue the database. [Document](database_configure.pdf), [Database sql file](metabolism.sql).
### 3. Copy the software to WWW directory.
### 4. Due to the limitation of storage space, we stored refMet in Google web disk (https://drive.google.com/drive/folders/1RjU4RIzl9P-gA_AV8Iy--Qk4VvJmXPNO?usp=sharing). users should copy this data to [data/refMet/]
### 5. Open file [Path]/socket/server_parallel.php and change the detial parameter for database, IP, port, and R program directory：
```
$host='127.0.0.1'; //database IP/location
$database='metabolism';   //database name
$user='zju_meta';   //database user
$pass='973254023';   //user password for database
$ip="10.71.208.94";  // server IP
$port=8761; // listening port
$R_path="/var/www/html/metabolism/R/"; // R or others programs directory for analysis 
```
### 6. Run `nohup php [Path]/socket/server_parallel.php` and ensure that this process is always running on the server.
### 7. open the software[IP/MARC] or [www.xxxx.com/MARC]


