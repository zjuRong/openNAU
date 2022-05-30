
#############################################################################
# file data source
file_size <- function(file) {
  info <- file.size(file) / (1024 * 1024)

  return(round(info, 2))
}

############################################################################
file_split <- function(x) {
  res <- unlist(strsplit(x, "/", fixed = TRUE))
  return(res[length(res)])
}

###########################################################################
dir_name <- function(x) {
  dir <- list.dirs("data/results", full.names = FALSE, recursive = FALSE)
  i <- 1
  x1 <- x
  while (x1 %in% dir) {
    x1 <- paste0(x, "-", i)
    i <- i + 1
  }
  dd <- list.dirs("data/results")[1]
  if (x %in% dir) {
    x1 <- paste0(dd, "/", x1)
  } else {
    x1 <- paste0(dd, "/", x)
  }
  return(x1)
}

###########################################################################
dir_name_IPO <- function(x) {
  dir <- list.dirs("data/result_IPO", full.names = FALSE, recursive = FALSE)
  i <- 1
  x1 <- x
  while (x1 %in% dir) {
    x1 <- paste0(x, "-", i)
    i <- i + 1
  }
  dd <- list.dirs("data/result_IPO")[1]
  if (x %in% dir) {
    x1 <- paste0(dd, "/", x1)
  } else {
    x1 <- paste0(dd, "/", x)
  }
  return(x1)
}

##########################################################################
# data results directory
## type=1 xcms,type=0 CAMERA
# thres threshold for the number of peaks of each group
plot_bar <- function(ddir, type, thres) {
  name <- list.files(ddir)
  if (type) {
    nn <- grep("output_xcms.tsv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.table(name)
  } else {
    nn <- grep("output_camera.csv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.csv(name)
  }
  dat <- data[, c("name", "npeaks")]
  dat <- dat[which(as.numeric(dat[, 2]) > thres), ]
  total <- sum(as.numeric(dat[, 2]))
  group <- length(as.numeric(dat[, 1]))
  dat <- dat[order(as.numeric(dat[, 2])), ]

  dat[, 1] <- factor(dat[, 1], levels = as.character(dat[, 1]))
  title <- paste0("Total (Raw) peaks: ", total, ", Groups(Peaks): ", group)
  ggplot(dat, aes(x = name, y = npeaks)) +
    geom_segment(aes(xend = name, yend = 0)) +
    scale_x_discrete(guide = guide_axis(check.overlap = TRUE)) +
    geom_point(size = 2, color = "red") +
    theme(axis.text.x = element_blank()) +
    ggtitle(title)
}

#########################################################
select_input <- function(ddir, type) {
  name <- list.files(ddir)
  if (type) {
    nn <- grep("output_xcms.tsv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.table(name)
  } else {
    nn <- grep("output_camera.csv", name)
    name <- paste0(ddir, "/", name[nn])
    data <- read.csv(name)
  }
  dat <- as.numeric(data[, "npeaks"])
  min <- min(dat)
  max <- max(dat)
  list(min = min, max = max)
}
