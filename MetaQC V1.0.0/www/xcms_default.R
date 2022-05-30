########################################################################################
# file data source directory
# ddir data results directory
# polarity ion polarity
xcms_peaks <- function(file, ddir, polarity) {
  xcmsSet <- xcmsSet(
    files = file,
    polarity = polarity,
    fwhm = 10
  )
  xcms <- retcor(xcmsSet,
    method = "obiwarp",
    plottype = "deviation"
  )
  xcms <- group(xcms)

  xset <- fillPeaks(xcms)
  name <- paste0(ddir, "/", polarity, "_output_xcms")
  sclass <- unique(as.character(xset@phenoData[, 1]))
  diffreport(xset, class1 = sclass[1], class2 = sclass[2], classeic = sclass, name, 200, metlin = 0.15)
}
#####################################################################
# file data source directory
# ddir data results directory
# polarity ion polarity

camera_peaks <- function(file, ddir, polarity) {
  xcmsSet <- xcmsSet(
    files = file,
    polarity = polarity,
    fwhm = 10
  )
  xcms <- retcor(xcmsSet,
    method = "obiwarp",
    plottype = "deviation"
  )
  xcms <- group(xcms)

  xset <- fillPeaks(xcms)


  name <- paste0(ddir, "/", polarity, "_output_camera.csv")
  polarity <- tolower(polarity)
  diffreport <- annotateDiffreport(xset, polarity = polarity)
  write.csv(diffreport, file = name)
}

# file data source directory
# ddir data results directory


IPO_optimize <- function(file, ddir, dfile, method = "centWave") {
  datafiles <- file
  if (method == "matchedFilter") {
    peakpickingParameters <- getDefaultXcmsSetStartingParams("matchedFilter")
    # setting levels for step to 0.2 and 0.3 (hence 0.25 is the center point)
    peakpickingParameters$step <- c(0.4, 0.5)
    peakpickingParameters$fwhm <- c(20, 30)
    peakpickingParameters$steps <- 2
  } else {
    # setting only one value for steps therefore this parameter is not optimized
    peakpickingParameters <- getDefaultXcmsSetStartingParams("centWave")
    peakpickingParameters$ppm <- 10
    peakpickingParameters$snthresh <- c(5, 15)
  }

  time.xcmsSet <- system.time({ # measuring time
    resultPeakpicking <-
      optimizeXcmsSet(
        files = datafiles,
        params = peakpickingParameters,
        nSlaves = 1,
        subdir = NULL,
        plot = TRUE
      )
  })
  #>

  resultPeakpicking$best_settings$result
  #>    ExpId   #peaks   #NonRP      #RP      PPS
  #>    0.000 3228.000 2264.000  569.000  143.004
  optimizedXcmsSetObject <- resultPeakpicking$best_settings$xset


  retcorGroupParameters <- getDefaultRetGroupStartingParams()
  retcorGroupParameters$profStep <- 1
  retcorGroupParameters$gapExtend <- 2.7
  time.RetGroup <- system.time({ # measuring time
    resultRetcorGroup <-
      optimizeRetGroup(
        xset = optimizedXcmsSetObject,
        params = retcorGroupParameters,
        nSlaves = 1,
        subdir = NULL,
        plot = TRUE
      )
  })


  name <- paste0(ddir, "/IPO_optimize.R")
  writeRScript(resultPeakpicking$best_settings$parameters, resultRetcorGroup$best_settings)
  capture.output(writeRScript(resultPeakpicking$best_settings$parameters, resultRetcorGroup$best_settings), file = name, type = "message")
  dd <- readLines(name)
  dd[2] <- paste0("file=list.files('", dfile, "',full.names = TRUE, recursive = TRUE)")
  ddt <- c(dd[1:4], "files=file,", dd[5:length(dd)])
  capture.output(cat(dd, sep = "\n"), file = name, type = "output")
}
#######################################################################################
# ddir data results directory
# data data source directory
# polarity ion polarity

IPO_peaks <- function(ddir, polarity) {
  rcode <- paste0(ddir, "/IPO_optimize.R")
  source(rcode)
  name <- paste0(ddir, "/IPO_output_camera.csv")
  polarity <- tolower(polarity)
  diffreport <- annotateDiffreport(xset, polarity = polarity)
  write.csv(diffreport, file = name)
}

##########################################################
clean_sample <- function(x) {
  x <- as.numeric(t(x))
  n <- length(x)
  m <- length(which(x == 0))
  p <- m / n
  if (p <= 0.5) {
    return(1)
  } else {
    return(0)
  }
}
clean_peaks <- function(x) {
  x <- as.numeric(t(x))
  n <- length(x)
  m <- length(which(x == 0))
  p <- m / n
  if (p <= 0.2) {
    return(1)
  } else {
    return(0)
  }
}


################## quantile
IQR_check <- function(x) {
  qu <- quantile(x, na.rm = TRUE)
  IQR <- qu[4] - qu[2]
  Imax <- qu[4] + 1.5 * IQR
  Imin <- qu[2] - 1.5 * IQR
  res <- which(x > Imax | x < Imin)
  return(res)
}

### sample>10, Gaussian distribution
SD_check <- function(x) {
  sd <- sd(x, na.rm = TRUE)
  mean <- mean(x, na.rm = TRUE)
  Smax <- mean + 3 * sd
  Smin <- mean - 3 * sd
  res <- which(x < Smin | x > Smax)
  return(res)
}




####################################################################################
# ddir data results directory
# data_dir data sources
## type=1 xcms,type=0 CAMERA
## clinic clinical data for groups
sample_check <- function(ddir, data_dir, type, polar, clinic) {
  clinic <- read.csv(file = clinic)
  clinic <- clinic[, 1:2]
  colnames(clinic) <- c("Sample", "Label")
  name <- list.files(ddir)
  if (type == 1) {
    nn <- grep("output_xcms.tsv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.table(name)
    ###### peaks informations
    dd <- data[, c("name", "mzmed", "mzmin", "mzmax", "rtmed", "rtmin", "rtmax")]

    dd[, "rtmed"] <- dd[, "rtmed"] / 60
    dd[, "rtmin"] <- dd[, "rtmin"] / 60
    dd[, "rtmax"] <- dd[, "rtmax"] / 60
    dd <- cbind(dd, polar)
    file_path <- paste0(ddir, "/mass_inf.csv")
    write.csv(dd, file_path, row.names = FALSE)
    ###### intensity
    column <- colnames(data)
    mm <- which(column == "metlin")
    ss <- which(column == "npeaks")
    group <- data[, c((ss + 1):(mm - 1))]
    nn <- as.numeric(apply(group, 2, max))
    sgroup <- rep(colnames(group), nn)
    sample_data <- data[, c((mm + 1):length(column))]
    name <- data[, "name"]
    sample_data <- cbind(name, sample_data)
    col <- as.character(sample_data[, 1])
    sample_data <- t(sample_data)
    colnames(sample_data) <- col
    sample_data <- sample_data[-1, ]
    sample_data <- cbind(sgroup, sample_data)
    sample_data <- cbind(rownames(sample_data), sample_data)
    sample_data <- data.frame(sample_data)
    colnames(sample_data)[1:2] <- c("Sample", "group")
    samp <- sample_data[, 1:2]
    samp <- left_join(samp, clinic, by = "Sample")
    samp <- samp[, -2]
    sample_data <- cbind(samp, sample_data[, -c(1:2)])
    file_path1 <- paste0(ddir, "/sample_mass.csv")
    write.csv(sample_data, file_path1, row.names = FALSE)
    ###### sample check
    sample_dat <- sample_data[, -c(1, 2)]
    check <- apply(sample_dat, 1, clean_sample)
    sample_data_mean <- sample_data[which(check == 1), ]
    file_path_clean <- paste0(ddir, "/sample_mass_clean_samples_mean.csv")
    write.csv(sample_data_mean, file_path_clean, row.names = FALSE)
    ####
    sample_data_clean <- sample_data[which(check == 0), ]
    file_path_clear <- paste0(ddir, "/sample_mass_clean_drop.csv")
    write.csv(sample_data_clean, file_path_clear, row.names = FALSE)
  }

  if (type == 0) {
    nn <- grep("output_camera.csv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.csv(name)
    ###### peaks informations
    dd <- data[, c("name", "mzmed", "mzmin", "mzmax", "rtmed", "rtmin", "rtmax", "adduct")]

    dd[, "rtmed"] <- dd[, "rtmed"] / 60
    dd[, "rtmin"] <- dd[, "rtmin"] / 60
    dd[, "rtmax"] <- dd[, "rtmax"] / 60

    file_path <- paste0(ddir, "/mass_inf.csv")
    write.csv(dd, file_path, row.names = FALSE)
    ###### intensity
    column <- colnames(data)
    sgroup <- list.dirs(data_dir, recursive = FALSE, full.names = FALSE)
    ng <- length(sgroup)
    group <- data[, sgroup]
    nn <- as.numeric(apply(group, 2, max))
    ss <- which(column == "npeaks")
    sgroup <- rep(colnames(group), nn)
    sample_data <- data[, c((ss + ng + 1):(length(column) - 3))]
    name <- data[, "name"]
    sample_data <- cbind(name, sample_data)
    col <- as.character(sample_data[, 1])
    sample_data <- t(sample_data)
    colnames(sample_data) <- col
    sample_data <- sample_data[-1, ]
    sample_data <- cbind(sgroup, sample_data)
    sample_data <- cbind(rownames(sample_data), sample_data)
    sample_data <- data.frame(sample_data)
    colnames(sample_data)[1:2] <- c("Sample", "group")
    samp <- sample_data[, 1:2]
    samp <- left_join(samp, clinic, by = "Sample")
    samp <- samp[, -2]
    sample_data <- cbind(samp, sample_data[, -c(1:2)])
    file_path1 <- paste0(ddir, "/sample_mass.csv")
    write.csv(sample_data, file_path1, row.names = FALSE)
    ###### sample check
    sample_dat <- sample_data[, -c(1, 2)]
    check <- apply(sample_dat, 1, clean_sample)
    sample_data_mean <- sample_data[which(check == 1), ]
    file_path_clean <- paste0(ddir, "/sample_mass_clean_samples_mean.csv")
    write.csv(sample_data_mean, file_path_clean, row.names = FALSE)
    ####
    sample_data_clean <- sample_data[which(check == 0), ]
    file_path_clear <- paste0(ddir, "/sample_mass_clean_drop.csv")
    write.csv(sample_data_clean, file_path_clear, row.names = FALSE)
  }
  list(mass_inf = file_path, sample_mass = file_path1, mean_res = file_path_clean, drop_res = file_path_clear)
}

##############

data_count <- function(x) {
  x <- as.numeric(as.vector(x))
  n <- length(which(x != 0))
  m <- n / length(x)
  m <- round(m, 3)
  return(m)
}


###################
# ddir data results directory
# data_dir data sources
## type=1 xcms,type=0 CAMERA
peaks_check <- function(ddir) {
  file_path_clean <- paste0(ddir, "/sample_mass_clean_samples_mean.csv")
  sample_data <- read.csv(file = file_path_clean)
  ###### peaks check
  sample_dat <- sample_data[, -c(1, 2)]
  check <- apply(sample_dat, 2, clean_peaks)
  sample_data_mean <- sample_dat[, which(check == 1)]
  mass_inf <- read.csv(paste0(ddir, "/mass_inf.csv"))
  mass_inf <- mass_inf[which(check == 1), ]
  file_path <- paste0(ddir, "/mass_inf_mean.csv")
  write.csv(mass_inf, file_path, row.names = FALSE)
  sample_data_mean <- cbind(sample_data[, c(1, 2)], sample_data_mean)
  file_path_clean <- paste0(ddir, "/sample_mass_clean_samples_peaks_mean.csv")
  write.csv(sample_data_mean, file_path_clean, row.names = FALSE)

  list(mean_res = file_path_clean)
}


############## MetaboAnalyst translate#####
MetaboAnalyst <- function(ddir, data) {
  ### mass data
  file_path <- paste0(ddir, "/", data)
  sample_data <- read.csv(file = file_path)
  ## mass information
  mass_inf <- read.csv(paste0(ddir, "/mass_inf_mean.csv"))
  mz <- as.character(mass_inf$mzmed)
  rt <- as.character(mass_inf$rtmed)
  cl <- paste0(mz, "__", rt)
  cl <- c("Sample", "Label", cl)
  sample_data <- t(sample_data)

  sample_data <- cbind(cl, sample_data)
  colnames(sample_data) <- as.character(t(sample_data[1, ]))
  sample_data <- sample_data[-1, ]
  file <- paste0(ddir, "/MetaboAnalyst_", data)
  write.csv(sample_data, file, row.names = FALSE)
}
