####SVA

library(ggplot2)
library(dplyr)
library("R.utils")
library(cluster)
library(fpc)
library(mixOmics)
library(cowplot)
library(MetaboQC)
library(knitr)
library(rmarkdown)
library("ropls")
library(gridExtra)
library(dplyr)
library(bookdown)
arg <- commandArgs(T)
if (length(arg) != 2) {
  cat("Argument: dataFile GroupInfo Out_Dir Group_column Y C\n")
  quit("no")
}
dir <- arg[1] #### upload data directory
status <- arg[2] ### Data from
# dir="ad7b0e601674099efe6b349449a2f565"
# status=1

if (status == 1) {
  rdir <- paste0("/var/www/html/metabolism/data/raw_web/", dir)
  # rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_web/",dir)
} else {
  rdir <- paste0("/var/www/html/metabolism/data/raw_ftp/", dir)
  #  rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_ftp/",dir)
}

setwd(rdir)
# unzip("upload.zip",exdir="upload")
output_log <- paste0(dir, "_2.log")
ft <- Sys.time()

file.create(output_log)
time <- paste0("Create Time: ", ft)
cat(time, file = output_log, sep = "\n", append = TRUE)
cat("progress:10", file = output_log, sep = "\n", append = TRUE)
if (!file.exists("sample_mass_RC_sva_normalize.csv")) {
  stop(" No 'sample_mass_RC_sva_normalize.csv' file in this directory !")
}
data <- read.csv("sample_mass_RC_sva_normalize.csv")
ggroup <- as.character(data[, "group"])
ss=which(ggroup=="QC")
if(length(ss)>0){
data=data[-ss,]
}

group <- unique(as.character(data[, "group"]))
data_peaks <- data[, -c(1:4)]
peaks <- colnames(data_peaks)
m <- length(group) - 1
for (i in 1:m) {
  t <- i + 1
  for (j in t:length(group))
  {
    group1 <- group[i]
    group2 <- group[j]
    dg1 <- which(ggroup == group1)
    dg2 <- which(ggroup == group2)
    n <- length(peaks)
    res <- c()
    for (s in 1:n) {
      FC <- mean(as.numeric(data_peaks[dg1, s])) / mean(as.numeric(data_peaks[dg2, s]))
      P <- wilcox.test(as.numeric(data_peaks[dg1, s]), as.numeric(data_peaks[dg2, s]))$p.value
      re <- c(peaks[s], FC, P)
      res <- rbind(res, re)
    }
    ord <- order(as.numeric(res[, 3]), decreasing = FALSE)
    res_ord <- res[ord, ]
    fdr <- rep(1, dim(res_ord)[1])
    for (p in 1:dim(res_ord)[1]) fdr[p] <- as.numeric(res_ord[p, 3]) * dim(res_ord)[1] / p
    res_fdr <- cbind(res_ord, fdr)
    colnames(res_fdr) <- c("ID", "FC", "P", "FDR")
    ff <- paste0(group1, " vs ", group2, "++wilcox_all_2.csv")
    write.csv(res_fdr, ff, row.names = FALSE)
    thres1 <- which(as.numeric(res_fdr[, "FDR"]) < 0.05)
    thres2 <- which(abs(as.numeric(res_fdr[, "FC"])) > 2 | abs(as.numeric(res_fdr[, "FC"])) < 0.5)
    thres <- setdiff(thres1, thres2)
    res_fdr_mean <- res_fdr[thres, ]
    ff <- paste0(group1, " vs ", group2, "++wilcox_mean_2.csv")
    write.csv(res_fdr_mean, ff, row.names = FALSE)
  }
}
cat("progress:40", file = output_log, sep = "\n", append = TRUE)
## OPLS-DA

m <- length(group) - 1
sd=ed=1
for (i in 1:m) {
  t <- i + 1
  for (j in t:length(group))
  {
    sd=sd+1
    group1 <- group[i]
    group2 <- group[j]
    dg1 <- which(ggroup == group1)
    dg2 <- which(ggroup == group2)
    opls <- try(opls(data_peaks[c(dg1, dg2), ], ggroup[c(dg1, dg2)], predI = 1, orthoI = 2, fig.pdfC = FALSE))
    if (class(opls) == "try-error") {
	ed=ed+1
    } else {
      VIP <- getVipVn(opls)
	  vip_data=cbind(names(VIP),VIP)
	  vip_data=data.frame(vip_data)
	  colnames(vip_data)=c("Peak","VIP value")
      data <- attributes(opls)
      x <- data$scoreMN
      y <- data$orthoScoreMN[, 1]
      dd <- cbind(x, y)
      dd <- cbind(dd, ggroup[c(dg1, dg2)])
      colnames(dd) <- c("x", "y", "group")
      ff <- paste0(group1, " vs ", group2, "++oplsda_data_2.csv")
      write.csv(dd, ff, row.names = FALSE)
      summary <- data$summaryDF[, 1:4]
      ff <- paste0(group1, " vs ", group2, "++oplsda_summary_2.csv")
      write.csv(summary, ff, row.names = FALSE)
      ff <- paste0(group1, " vs ", group2, "++VIP_all_2.csv")
      write.csv(vip_data, ff,row.names=F)
      VIP <- vip_data[which(VIP > 1),]
      ff <- paste0(group1, " vs ", group2, "++VIP_mean_2.csv")
      write.csv(VIP, ff,row.names=F)
    }
  }
}
if(ed==sd){
   stop(" OPLS-DA can not been peformed!")

}

cat("progress:60", file = output_log, sep = "\n", append = TRUE)
##### Venn diagram
mass_inf <- read.csv("upload/mass_inf.csv")
mass_inf <- data.frame(mass_inf)
colnames(mass_inf)[1] <- "name"
file <- list.files()

dd <- grep("VIP_mean_2.csv", file, fixed = TRUE)
if (length(dd) == 0) {
} else {
  file_popls <- file[dd]
  res <- c()
  for (f in file_popls)
  {
    data <- read.csv(file = f)
    nn <- unlist(strsplit(f, "++", fixed = TRUE))
    ggr <- nn[1]
    wilcox <- read.csv(paste0(ggr, "++wilcox_mean_2.csv"))
    wilcox <- as.character(wilcox[, 1])
    oplsda <- as.character(data[, 1])
    int_mean <- intersect(wilcox, oplsda)
    if (length(int_mean) > 0) {
      re <- cbind(int_mean, ggr)
      res <- rbind(res, re)
    }
  }
  res <- data.frame(res)
  colnames(res) <- c("name", "Group")
  peak_res <- left_join(res, mass_inf, by = "name")
  write.csv(peak_res, "DMC_wilcox_opls_mean_2.csv", row.names = FALSE)
}
cat("progress:75", file = output_log, sep = "\n", append = TRUE)
### peaks transform to compound
refmet <- read.csv("../../refMet/refMet_all_compound.csv")


file <- list.files()

dd <- grep("DMC_wilcox_opls_mean_2.csv", file, fixed = TRUE)
if (length(dd) > 0) {
  peak_mean <- read.csv("DMC_wilcox_opls_mean_2.csv", header = TRUE)
  peak_res <- peak_mean[, c("name", "Group", "mzmed", "polar")]
  m <- dim(peak_res)[1]
  peak_res$mzmin <- peak_res$mzmax <- rep(0, m)
  res <- c()
  for (i in 1:m) {
    if (as.character(peak_res[i, "polar"]) == "Positive") {
      peak_res[i, "mzmed"] <- as.numeric(peak_res[i, "mzmed"]) - 1.0078 # 1.00783
      peak_res[i, "mzmin"] <- as.numeric(peak_res[i, "mzmed"]) * (1 - 10 / 1000000)
      peak_res[i, "mzmax"] <- as.numeric(peak_res[i, "mzmed"]) * (1 + 10 / 1000000)
    }
    if (as.character(peak_res[i, "polar"]) == "Negative") {
      peak_res[i, "mzmed"] <- as.numeric(peak_res[i, "mzmed"]) + 1.0078 # 1.00783
      peak_res[i, "mzmin"] <- as.numeric(peak_res[i, "mzmed"]) * (1 - 10 / 1000000)
      peak_res[i, "mzmax"] <- as.numeric(peak_res[i, "mzmed"]) * (1 + 10 / 1000000)
    }
    data_mm <- refmet %>%
      filter(mass < peak_res[i, "mzmax"] & mass > peak_res[i, "mzmin"])
    if (dim(data_mm)[1] > 0) {
      data_m <- cbind(peak_res[i, ], data_mm)
      res <- rbind(res, data_m)
    }
  }
  write.csv(res, "DMC_wilcox_opls_mean_identify_2.csv", row.names = FALSE)
}
cat("progress:80", file = output_log, sep = "\n", append = TRUE)
############## gene
protein <- read.csv("../../refMet/hmdb_compound_protein.csv")
colnames(protein)[1] <- "extend1.ID"
dd <- which(is.na(res[, "extend1.ID"]))
data <- res[-dd, ]
data_res <- left_join(data, protein, by = "extend1.ID")

write.csv(data_res, "DMC_wilcox_opls_mean_identify_target_2.csv", row.names = FALSE)

############## enzyme
enzyme <- read.csv("../../refMet/enyme_compound_hmdb.csv")
colnames(enzyme)[1] <- "extend1.ID"
dd <- which(is.na(res[, "extend1.ID"]))
data <- res[-dd, ]
data_res <- left_join(data, enzyme, by = "extend1.ID")

write.csv(data_res, "DMC_wilcox_opls_mean_identify_enzyme_2.csv", row.names = FALSE)

cat("progress:90", file = output_log, sep = "\n", append = TRUE)


file.copy(from = "../../../R/process_2.Rmd", to = "process_2.Rmd", overwrite = TRUE)
render("process_2.Rmd", html_document(toc = TRUE, toc_depth = 3), "process_2.html")
