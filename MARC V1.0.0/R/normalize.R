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
arg <- commandArgs(T)
if (length(arg) != 2) {
  cat("Argument: dataFile GroupInfo Out_Dir Group_column Y C\n")
  quit("no")
}
dir <- arg[1] #### upload data directory
status <- arg[2] ### Data from
# dir="79e03fdbbf1381f525139d2a0481e7e8"
# status=1
if (status == 1) {
  rdir <- paste0("/var/www/html/metabolism/data/raw_web/", dir)
  #  rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_web/",dir)
} else {
  rdir <- paste0("/var/www/html/metabolism/data/raw_ftp/", dir)
  # rdir=paste0("C:/software/phpstudy_pro/WWW/metabolism/data/raw_ftp/",dir)
}

setwd(rdir)
unzip("upload.zip", exdir = "upload")
file <- list.files("upload")
size <- round(file.size(paste0("upload/", file)) / (1024 * 1024), 3)
dfs <- cbind(file, size)
colnames(dfs) <- c("File name", "Size (M)")
write.csv(dfs, "dfs.csv", row.names = FALSE)
output_log <- paste0(dir, "_0.log")
### group find


ft <- Sys.time()

file.create(output_log)
time <- paste0("Create Time: ", ft)
cat(time, file = output_log, sep = "\n", append = TRUE)
cat("\n", file = output_log, sep = "\n", append = TRUE)
cat("**********Data files:", file = output_log, sep = "\n", append = TRUE)
cat(file, file = output_log, sep = "\n", append = TRUE)
cat("\n", file = output_log, sep = "\n", append = TRUE)
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
write.csv(mass_inf_mean, "mass_inf_mean_RC.csv", row.names = FALSE)
cat("Mass information file: mass_inf_mean_RC.csv", file = output_log, sep = "\n", append = TRUE)
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

sc <- grep("clinical", file, fixed = TRUE)
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
data_normalize <- cbind(data_normalize[, c("sampleID", "order", "group", "pici")], data_normalize1[, -1])
write.csv(data_normalize, "sample_mass_RC_normalize.csv", row.names = FALSE)
cat("Mass intensity file by reference compound adjusting: sample_mass_RC_normalize.csv", file = output_log, sep = "\n", append = TRUE)
cat("progress:50", file = output_log, sep = "\n", append = TRUE)
data_normalize_pca <- data_normalize[which(as.character(data_normalize[, "group"]) == "QC"), ]
write.csv(data_normalize_pca, "data_normalize_QC.csv", row.names = FALSE)
rc_data <- cbind(as.character(data_normalize[, "group"]), rc_data)
rc_data <- data.frame(rc_data)
colnames(rc_data) <- c("group", "intensity")
write.csv(rc_data, "rc_data.csv", row.names = FALSE)

data_raw_pca <- data_raw[which(as.character(data_raw[, "group"]) == "QC"), ]
write.csv(data_raw_pca, "data_raw_pca_QC.csv", row.names = FALSE)
data_loess <- data_normalize

###### QC by quantity control data
nname <- colnames(data_normalize)
sa <- which(nname == "sampleID")
sg <- which(nname == "group")
sp <- which(nname == "pici")
so <- which(nname == "order")
rr <- as.numeric(c(sa, so, sg, sp))

group <- data_normalize[, "group"]
pici <- data_normalize[, "pici"]
dat <- unique(pici)
m <- length(dat)
res <- c()
for (i in 1:m) {
  ss <- which(pici == dat[i])
  QC <- as.character(data_normalize[ss, "group"])
  QC_data <- data_normalize[ss, ]
  qc_data <- QC_data[which(QC == "QC"), -rr]
  ms_data <- QC_data[which(QC != "QC"), -rr]
  peaks <- colnames(qc_data)
  n <- length(peaks)
  ms_data_nor <- c()
  for (j in 1:n) {
    qc_nei <- as.numeric(qc_data[, j])
    ms_da <- as.numeric(ms_data[, j])
    qc_mean <- mean(qc_nei)
    qc_s <- sd(qc_nei)

    ms_data_no <- (ms_da - qc_mean) / qc_s

    ms_data_nor <- cbind(ms_data_nor, ms_data_no)
  }
  res <- rbind(res, ms_data_nor)
}

colnames(res) <- peaks
ms <- cbind(data_normalize[which(group != "QC"), rr], res)
write.csv(ms, "sample_mass_RC_QC_normalize_zscore.csv", row.names = FALSE)
cat("Mass intensity file by Quanity controlsamples adjusting based on Z-score: sample_mass_RC_QC_normalize_zscore.csv", file = output_log, sep = "\n", append = TRUE)
cat("progress:70", file = output_log, sep = "\n", append = TRUE)
res <- c()
for (i in 1:m) {
  ss <- which(pici == dat[i])
  QC <- as.character(data_normalize[ss, "group"])
  QC_data <- data_normalize[ss, ]
  qc_data <- QC_data[which(QC == "QC"), -rr]
  peaks <- colnames(qc_data)
  n <- length(peaks)
  ms_data_nor <- c()
  for (j in 1:n) {
    qc_nei <- as.numeric(qc_data[, j])
    ms_da <- as.numeric(qc_data[, j])
    qc_mean <- mean(qc_nei)
    qc_s <- sd(qc_nei)

    ms_data_no <- (ms_da - qc_mean) / qc_s

    ms_data_nor <- cbind(ms_data_nor, ms_data_no)
  }
  res <- rbind(res, ms_data_nor)
}
colnames(res) <- peaks
ms_QC <- cbind(data_normalize[which(group == "QC"), rr], res)
write.csv(ms_QC, "ms_QC.csv", row.names = FALSE)

#### LOESS

dat_loess <- data_loess

colnames(data_loess)[1:4] <- c("sampleID", "Order", "QC", "Day")
data_loess[, "QC"] <- as.numeric(as.character(data_loess[, "QC"]) == "QC")
data_loess <- data.frame(data_loess)
data_loess_v <- apply(data_loess[, -1], 2, as.numeric)
data_loess_v <- data.frame(data_loess_v)
data_loess <- cbind(data_loess[, "sampleID"], data_loess_v)
colnames(data_loess)[1:4] <- c("Sample", "Order", "QC", "Day")
data_loess_normalize <- QCcorrectionLOESS(data_loess)
data_loess_normalize <- cbind(dat_loess[, 1:4], data_loess_normalize[, -c(1:4)])
data_loess_normalize_sa <- data_loess_normalize[which(as.character(data_loess_normalize[, "group"]) != "QC"), ]

write.csv(data_loess_normalize_sa, "sample_mass_RC_QC_normalize_loess.csv", row.names = FALSE)
cat("Mass intensity file by Quanity controlsamples adjusting based on LOESS: sample_mass_RC_QC_normalize_loess.csv", file = output_log, sep = "\n", append = TRUE)
data_loess_normalize_pca <- data_loess_normalize[which(as.character(data_loess_normalize[, "group"]) == "QC"), ]
write.csv(data_loess_normalize_pca, "data_loess_normalize_QC.csv", row.names = FALSE)
cat("progress:75", file = output_log, sep = "\n", append = TRUE)
####### sPoly3
data_spoly_normalize <- QCcorrectionSinglePoly3(data_loess)
data_spoly_normalize <- cbind(dat_loess[, 1:4], data_spoly_normalize[, -c(1:4)])
data_spoly_normalize_sa <- data_spoly_normalize[which(as.character(data_spoly_normalize[, "group"]) != "QC"), ]

write.csv(data_spoly_normalize_sa, "sample_mass_RC_QC_normalize_spoly3.csv", row.names = FALSE)
cat("Mass intensity file by Quanity controlsamples adjusting based on Single-poly3: sample_mass_RC_QC_normalize_spoly3.csv", file = output_log, sep = "\n", append = TRUE)
data_spoly_normalize_pca <- data_spoly_normalize[which(as.character(data_spoly_normalize[, "group"]) == "QC"), ]
write.csv(data_spoly_normalize_pca, "data_spoly_normalize_QC.csv", row.names = FALSE)
####### sPoly4
data_spoly4_normalize <- QCcorrectionSinglePoly4(data_loess)
data_spoly4_normalize <- cbind(dat_loess[, 1:4], data_spoly4_normalize[, -c(1:4)])
data_spoly4_normalize_sa <- data_spoly4_normalize[which(as.character(data_spoly4_normalize[, "group"]) != "QC"), ]
write.csv(data_spoly4_normalize_sa, "sample_mass_RC_QC_normalize_spoly4.csv", row.names = FALSE)
cat("Mass intensity file by Quanity controlsamples adjusting based on Single-Poly4: sample_mass_RC_QC_normalize_spoly4.csv", file = output_log, sep = "\n", append = TRUE)
data_spoly4_normalize_pca <- data_spoly4_normalize[which(as.character(data_spoly4_normalize[, "group"]) == "QC"), ]

write.csv(data_spoly4_normalize_pca, "data_spoly4_normalize_QC.csv", row.names = FALSE)
cat("progress:85", file = output_log, sep = "\n", append = TRUE)
######### comparation
data_RC_QC <- data_raw_pca[, -c(1:4)]
data_RC_QC <- apply(data_RC_QC, 2, as.numeric)
mean_RC <- apply(data_RC_QC, 1, mean)
mean_RC <- mean_RC / mean(mean_RC)
mean_RC <- cbind(mean_RC, "raw-RC")
sd_RC <- apply(data_RC_QC, 1, sd)
sd_RC <- sd_RC / mean(sd_RC)
sd_RC <- cbind(sd_RC, "raw-RC")

ms_QC <- ms_QC[, -c(1:4)]
ms_QC <- apply(ms_QC, 2, as.numeric)
mean_zscore <- apply(ms_QC, 1, mean)
mean_zscore <- mean_zscore / mean(abs(mean_zscore))
mean_zscore <- cbind(mean_zscore, "Z-score")
sd_zscore <- apply(ms_QC, 1, sd)
sd_zscore <- sd_zscore / mean(abs(sd_zscore))
sd_zscore <- cbind(sd_zscore, "Z-score")

data_loess_normalize_pca <- data_loess_normalize_pca[, -c(1:4)]
data_loess_normalize_pca <- apply(data_loess_normalize_pca, 2, as.numeric)
mean_loess <- apply(data_loess_normalize_pca, 1, mean)
mean_loess <- mean_loess / mean(mean_loess)
mean_loess <- cbind(mean_loess, "LOESS")
sd_loess <- apply(data_loess_normalize_pca, 1, sd)
sd_loess <- sd_loess / mean(sd_loess)
sd_loess <- cbind(sd_loess, "LOESS")

data_spoly_normalize_pca <- data_spoly_normalize_pca[, -c(1:4)]
data_spoly_normalize_pca <- apply(data_spoly_normalize_pca, 2, as.numeric)
mean_spoly <- apply(data_spoly_normalize_pca, 1, mean)
mean_spoly <- mean_spoly / mean(mean_spoly)
mean_spoly <- cbind(mean_spoly, "Single-Poly3")
sd_spoly <- apply(data_spoly_normalize_pca, 1, sd)
sd_spoly <- sd_spoly / mean(sd_spoly)
sd_spoly <- cbind(sd_spoly, "Single-Poly3")

data_spoly4_normalize_pca <- data_spoly4_normalize_pca[, -c(1:4)]
data_spoly4_normalize_pca <- apply(data_spoly4_normalize_pca, 2, as.numeric)
mean_mpoly <- apply(data_spoly4_normalize_pca, 1, mean)
mean_mpoly <- mean_mpoly / mean(mean_mpoly)
mean_mpoly <- cbind(mean_mpoly, "Single-Poly4")
sd_mpoly <- apply(data_spoly4_normalize_pca, 1, sd)
sd_mpoly <- sd_mpoly / mean(sd_mpoly)
sd_mpoly <- cbind(sd_mpoly, "Single-Poly4")

mean <- rbind(mean_RC, mean_zscore)
mean <- rbind(mean, mean_loess)
mean <- rbind(mean, mean_spoly)
mean <- rbind(mean, mean_mpoly)
mean <- data.frame(mean)

id <- c(1:dim(mean_RC)[1])
mean <- cbind(rep(id, 5), mean)
colnames(mean) <- c("id", "intensity", "group")
write.csv(mean, "mean.csv", row.names = FALSE)


sd <- rbind(sd_RC, sd_zscore)
sd <- rbind(sd, sd_loess)
sd <- rbind(sd, sd_spoly)
sd <- rbind(sd, sd_mpoly)
sd <- data.frame(sd)
id <- c(1:dim(sd_RC)[1])
sd <- cbind(rep(id, 5), sd)
colnames(sd) <- c("id", "intensity", "group")
write.csv(sd, "sd.csv", row.names = FALSE)

cat("progress:95", file = output_log, sep = "\n", append = TRUE)
# file.copy(from="/var/www/html/metabolism/R/normalize.Rmd", to="normalize.Rmd",overwrite=TRUE)
file.copy(from = "../../../R/normalize.Rmd", to = "normalize.Rmd", overwrite = TRUE)

render("normalize.Rmd", html_document(toc = TRUE, toc_depth = 3), "normalize.html")
