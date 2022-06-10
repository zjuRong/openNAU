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
library(sva)
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
  #  rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_web/",dir)
} else {
  rdir <- paste0("/var/www/html/metabolism/data/raw_ftp/", dir)
  #  rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_ftp/",dir)
}

setwd(rdir)
unzip("upload.zip", exdir = "upload")
file <- list.files("upload")
size <- round(file.size(paste0("upload/", file)) / (1024 * 1024), 3)
dfs <- cbind(file, size)
colnames(dfs) <- c("File name", "Size (M)")
write.csv(dfs, "dfs_1.csv", row.names = FALSE)
output_log <- paste0(dir, "_sva_1.log")
ft <- Sys.time()

file.create(output_log)
time <- paste0("Create Time: ", ft)
cat(time, file = output_log, sep = "\n", append = TRUE)
cat("progress:10", file = output_log, sep = "\n", append = TRUE)

sm <- grep("sample_mass", file, fixed = TRUE)
sample_mass <- paste0("upload/", file[sm])
sample_mass_data <- read.csv(sample_mass, header = TRUE)
sample_mass_data <- sample_mass_data[, -2]
#### divide neibiao
mp <- grep("mass_inf", file, fixed = TRUE)
mass_inf <- paste0("upload/", file[mp])
mass_inf <- read.csv(file = mass_inf)
rc <- which(as.numeric(mass_inf[, "RC"]) == 1)
pid <- as.character(mass_inf[rc, 1])
mass_inf_mean <- mass_inf[-rc, ]
write.csv(mass_inf_mean, "mass_inf_mean_1.csv", row.names = FALSE)
cat("Mass information file: mass_inf_mean.csv", file = output_log, sep = "\n", append = TRUE)
cat("progress:30", file = output_log, sep = "\n", append = TRUE)
data_peaks <- sample_mass_data[, -1]
sampleID <- as.character(sample_mass_data[, 1])
peaks <- colnames(data_peaks)
nc <- which(peaks == pid)
rc_data <- as.numeric(data_peaks[, nc])
nc <<- nc
nor <- function(x) {
  x <- as.numeric(t(x))
  x <- x / x[nc]

  return(x)
}

res <- apply(data_peaks, 1, nor)
res <- res[-nc, ]
peaks <- peaks[-nc]
data_normalize <- t(res)
data_normalize <- cbind(sampleID, data_normalize)
colnames(data_normalize) <- c("sampleID", peaks)

sc <- grep("clinical", file)
if (length(sc) == 0) {
  gg <- sampleID
  n <- length(gg)
  group <- pici <- rep(NA, n)
  for (i in 1:n) {
    dd <- strsplit(gg[i], "_", fixed = TRUE)
    group[i] <- dd[1]
    pici[i] <- dd[2]
  }
  dat <- cbind(gg, group, pici)
  colnames(dat) <- c("sampleID", "group", "pici")
  group <- data.frame(data)
} else {
  clinic <- paste0("upload/", file[sc])
  group <- read.csv(file = clinic)
  group <- data.frame(group)
  group <- group[, 1:4]
  colnames(group) <- c("sampleID", "group", "pici", "order")
}
data_normalize1 <- data.frame(data_normalize)
data_normalize <- left_join(data_normalize1, group, by = "sampleID")
data_raw <- cbind(data_normalize[, c("sampleID", "order", "group", "pici")], data_peaks)
write.csv(data_raw, "data_raw.csv", row.names = FALSE)
data_normalize <- cbind(data_normalize[, c("sampleID", "order", "group", "pici")], data_normalize1[, -1])
write.csv(data_normalize, "sample_mass_RC_normalize.csv", row.names = FALSE)
cat("Mass intensity file by reference compound adjusting: sample_mass_RC_normalize.csv", file = output_log, sep = "\n", append = TRUE)
rc_data <- cbind(as.character(data_normalize[, "group"]), rc_data)
rc_data <- data.frame(rc_data)
colnames(rc_data) <- c("group", "intensity")
write.csv(rc_data, "rc_data_1.csv", row.names = FALSE)

### sva


dd <- as.matrix(data_normalize[, -c(1:4)])

dd <- apply(dd, 2, as.numeric)
rownames(dd) <- as.character(data_normalize[, 1])
colnames(dd) <- colnames(data_normalize)[-c(1:4)]
batch <- as.numeric(data_normalize[, "pici"])
clinical <- data_normalize[, c(1:4)]
# mod = model.matrix(~as.factor(group),data=clinical)
combat_edata <- ComBat(dat = t(dd), batch = batch, mod = NULL)
combat_edata <- t(combat_edata)

combat_edata <- cbind(clinical, combat_edata)
write.csv(combat_edata, "sample_mass_RC_sva_normalize.csv", row.names = FALSE)

data_RC_QC <- data_normalize[, -c(1:4)]
data_RC_QC <- apply(data_RC_QC, 2, as.numeric)
mean_RC <- apply(data_RC_QC, 1, mean)
mean_RC <- mean_RC / mean(mean_RC)
mean_RC <- cbind(mean_RC, "raw-RC")
sd_RC <- apply(data_RC_QC, 1, sd)
sd_RC <- sd_RC / mean(sd_RC)
sd_RC <- cbind(sd_RC, "raw-RC")



ms_QC <- combat_edata[, -c(1:4)]
ms_QC <- apply(ms_QC, 2, as.numeric)
mean_zscore <- apply(ms_QC, 1, mean)
mean_zscore <- mean_zscore / mean(mean_zscore)
mean_zscore <- cbind(mean_zscore, "SVA")
sd_zscore <- apply(ms_QC, 1, sd)
sd_zscore <- sd_zscore / mean(sd_zscore)
sd_zscore <- cbind(sd_zscore, "SVA")



mean <- rbind(mean_RC, mean_zscore)

mean <- data.frame(mean)

id <- c(1:dim(mean_RC)[1])
mean <- cbind(rep(id, 2), mean)
colnames(mean) <- c("id", "intensity", "group")
write.csv(mean, "mean_1.csv", row.names = FALSE)


sd <- rbind(sd_RC, sd_zscore)
sd <- data.frame(sd)
id <- c(1:dim(sd_RC)[1])
sd <- cbind(rep(id, 2), sd)
colnames(sd) <- c("id", "intensity", "group")
write.csv(sd, "sd_1.csv", row.names = FALSE)

file.copy(from = "../../../R/normalize_1.Rmd", to = "normalize_1.Rmd", overwrite = TRUE)
# file.copy(from="/var/www/html/metabolism/R/normalize_1.Rmd", to="normalize_1.Rmd",overwrite=TRUE)
render("normalize_1.Rmd", html_document(toc = TRUE, toc_depth = 3), "normalize_1.html")
