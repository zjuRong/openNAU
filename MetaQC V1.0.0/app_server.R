# import R source

source("www/readData.R")
source("www/xcms_default.R")

server <- shinyServer(function(input, output, session) {
  showTab("index", "Overview", select = TRUE)
  ft <- Sys.time()
  f <- as.numeric(ft)
  ff <- paste0("data/jobs/", f)
  file.create(ff)

  observeEvent(input$compute,
    {
      shinyjs::hide("IPO_peaks_res")
      shinyjs::hide("xcms")
      shinyjs::hide("IPO_res")
      shinyjs::hide("IPO_res_R")
    },
    once = TRUE
  )

  #################### tab1

  volumes <- c(Home = getwd(), "R Installation" = R.home(), getVolumes()())

  shinyFileChoose(input, "file_raw", roots = volumes, session = session)
  # by setting `allowDirCreate = FALSE` a user will not be able to create a new directory
  shinyDirChoose(input, "directory_raw", roots = volumes, session = session, restrictions = system.file(package = "base"), allowDirCreate = FALSE)
  #   shinyFileSave(input, "save", roots = volumes, session = session, restrictions = system.file(package = "base"))

  observeEvent(input$title_load, {
    title <- input$title
    title <- paste0("Title: ", title)
    cat(title, file = ff, sep = "\n", append = TRUE)
    time <- paste0("Create Time: ", ft)
    cat(time, file = ff, sep = "\n", append = TRUE)
    on.exit({
      shinyjs::show("lags")
    })
  })
  dir <- reactive({
    if (length(parseDirPath(volumes, input$directory_raw)) > 0) {
      dir <- parseDirPath(volumes, input$directory_raw)
      dii <- paste0("Data directory: ", dir)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      list(dir = dir)
    }
  })

  data <- reactive({
    if (length(parseDirPath(volumes, input$directory_raw)) > 0) {
      dir <- parseDirPath(volumes, input$directory_raw)
      if (length(parseFilePaths(volumes, input$file_raw)$datapath) > 0) {
        clinicf <- parseFilePaths(volumes, input$file_raw)$datapath
        dd <- list.dirs(dir, recursive = F, full.names = F)
        if (length(dd) > 0) {
          n <- length(dd)
          clinic <- c()
          for (i in 1:n) {
            file <- list.files(paste0(dir, "/", dd[i]))
            fi <- unlist(lapply(file, function(x) {
              return(unlist(strsplit(x, ".", fixed = T))[1])
            }))
            fi <- cbind(fi, dd[i])
            clinic <- rbind(clinic, fi)
          }
          clinic <- data.frame(clinic)

          colnames(clinic) <- c("sample_name", "sample_group")
          file <- list.files(dir, full.names = TRUE, recursive = TRUE)
          raw_data <- readMSData(
            files = file, pdata = new("NAnnotatedDataFrame", clinic),
            mode = "onDisk"
          )
          bpis <- chromatogram(raw_data, aggregationFun = "max", BPPARAM = SerialParam())
          dii <- paste0("Clinic data path: ", clinicf)
          cat(dii, file = ff, sep = "\n", append = TRUE)
          list(dir = dir, clinic = clinic, data = file, bpis = bpis, cd = clinicf)
        }
      }
    }
  })


  shinyjs::show("plot1", anim = TRUE)
  output$plot_step1 <- renderPlotly({
    if (length(parseDirPath(volumes, input$directory_raw)) > 0) {

      # dir=parseDirPath(volumes, input$directory_raw)
      file1 <- list.files(dir()$dir, full.names = TRUE, recursive = TRUE)
      file2 <- unlist(lapply(file1, file_split))
      size <- unlist(lapply(file1, file_size))
      dat <- cbind(file2, size)
      colnames(dat) <- c("file", "size")
      dat <- data.frame(dat)
      gg <- ggplot(data = dat, mapping = aes(x = file, y = as.numeric(size), group = 1)) +
        geom_line(color = "red") +
        geom_point() +
        scale_x_discrete(guide = guide_axis(check.overlap = TRUE)) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          y = "File size (M)", x = "File names"
        )
      ggplotly(gg)
    }
  })



  output$plot_step2 <- renderPlot({
    # dir=parseDirPath(volumes, input$directory_raw)


    if (length(parseFilePaths(volumes, input$file_raw)$datapath) > 0) {
      group_colors <- brewer.pal(length(unique(as.character(data()$clinic[, 2]))), "Set1")[1:length(unique(as.character(data()$clinic[, 2])))]
      names(group_colors) <- unique(as.character(data()$clinic[, 2]))
      plot(data()$bpis, col = group_colors[data()$clinic[, 2]])
      legend("topright", inset = .05, unique(as.character(data()$clinic[, 2])), bty = "n", cex = 1, fill = group_colors, horiz = F)
    } else {


    }
  })

  output$plot_step3 <- renderPlot({
    dir <- parseDirPath(volumes, input$directory_raw)

    if (length(parseFilePaths(volumes, input$file_raw)$datapath) > 0) {
      clinic <- parseFilePaths(volumes, input$file_raw)$datapath
      clinic <- data.frame(read.csv(clinic))
      group <- as.character(data()$clinic[, 2])
      group_colors <- brewer.pal(length(unique(as.character(data()$clinic[, 2]))), "Set1")[1:length(unique(as.character(data()$clinic[, 2])))]
      names(group_colors) <- unique(group)

      bpis_bin <- bin(data()$bpis, binSize = 2)

      ## Calculate correlation on the log2 transformed base peak intensities
      cormat <- cor(log2(do.call(cbind, lapply(bpis_bin, intensity)) + 1))
      colnames(cormat) <- rownames(cormat) <- data()$clinic[, 1]

      ## Define which phenodata columns should be highlighted in the plot
      ann <- data.frame(group = data()$clinic[, 2])
      rownames(ann) <- data()$clinic[, 1]
      ## Perform the cluster analysis
      ha <- rowAnnotation(
        Group = data()$clinic$sample_group,
        col = list(Group = group_colors)
      )
      Heatmap(cormat, name = "R", right_annotation = ha, show_column_names = FALSE, show_row_names = FALSE, cluster_columns = FALSE, clustering_distance_rows = "pearson")
    }
  })




  ############### tab2

  # Select data ----

  output$prep <- renderUI({
    if (input$preprocessor) {
      tags$div(
        selectInput("method", "Select method:", choices = c("centWave", "matchedFilter"), width = "100%"),
        helpText("centWave(High resolution chromatography); matchedFilter(Low resolution chromatography)"),
        hr(),
        actionButton("IPO", "IPO optimize", width = "100%"),
        hr(),
        actionButton("IPO_peaks", "IPO peaks", width = "100%")
      )
    } else {
      tags$p(
        selectInput("method", "Select a method:", choices = c("XCMS", "CAMERA"), selected = "XCMS", width = "100%"),
        tags$hr(),
        actionButton("compute", "Computing", width = "100%")
      )
    }
  })
  IPO_status <- eventReactive(input$preprocessor, {
    shinyjs::hide("threshold_ui")
    shinyjs::hide("plot_bar")
    shinyjs::show("IPO_res")
    if (input$preprocessor) {
      dii <- paste0("IPO: TRUE")
    } else {
      dii <- paste0("IPO: FALSE")
    }
    list(dii = dii)
  })

  # output$XC <- renderUI({
  #   if(input$custom)
  #   {
  #     removeUI("#compute")
  #     tags$p(
  #     h4(strong("xcmsSet parameters:")),
  #     tags$hr(),
  #     selectInput("polarity","Select ploarity:",choices =c("Positive","Negative") ,width='100%'),
  #     numericInput("fwhm","The full width at half maximum",value="10",width = '100%'),
  #     numericInput("step","The width of the bins/slices in m/z dimension",value="0.1",width = '100%'),
  #     hr(),
  #     h4(strong("Align retention times parameters:")),
  #     selectInput("rmethod","Select method:",choices =c("obiwarp","loess") ,selected="",width='100%'),
  #     hr(),
  #     h4(strong("Group peaks parameters:")),
  #     selectInput("gmethod","Grouping (or alignment) methods:",choices =c("density","mzClust","nearest") ,selected="density",width='100%'),
  #     numericInput("bw","Bandwidth",value="10",width = '100%'),
  #     helpText("bandwidth (standard deviation or half width at half maximum) of gaussian smoothing kernel to apply to the peak density chromatogram."),
  #     actionButton("submit","Custom",width = '100%')
  #
  #   )
  #   }else{
  #     insertUI(selector="#XC",where="afterEnd",ui=tags$div(tags$hr(),
  #              actionButton("compute","Computing", width = '100%'),id="compute"))
  #
  #   }
  #
  # })
  #



  xcms <- eventReactive(input$compute,
    {
      if (length(parseDirPath(volumes, input$directory_raw)) > 0) {
        shinyjs::show("xcms")
        file <- list.files(dir()$dir, full.names = TRUE, recursive = TRUE)
        invisible(cat(IPO_status()$dii, file = ff, sep = "\n", append = TRUE))
        tt <- as.character(Sys.Date())
        ddir <- dir_name(tt)
        if (!dir.exists(ddir)) {
          dir.create(ddir)
        }
        dii <- paste0("Result directory: ", ddir)
        invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
        dii <- paste0("Polarity: ", input$polarity)
        invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
        if (input$method == "XCMS") {
          data <- xcms_peaks(file, ddir, input$polarity)
          type <- 1
          dii <- "XCMS-deafult: TRUE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
          dii <- "CAMERA-deafult: FALSE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
          dii <- "Peaks quantification: TRUE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
        }
        if (input$method == "CAMERA") {
          data <- camera_peaks(file, ddir, input$polarity)
          type <- 0
          dii <- "XCMS-deafult: FALSE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
          dii <- "CAMERA-deafult: TRUE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
          dii <- "Peaks quantification: TRUE"
          invisible(cat(dii, file = ff, sep = "\n", append = TRUE))
        }

        list(ddir = ddir, type = type)
      }
      # progress$inc(amount = 90, message = NULL, detail = NULL)
    },
    ignoreInit = TRUE
  )
  output$plot_bar <- renderPlotly({
    plot <- plot_bar(xcms()$ddir, xcms()$type, input$threshold)
    ggplotly(plot)
  })
  output$xcms <- renderUI({
    tags$div(
      hr(),
      p("The file path for results: "),
      strong(xcms()$ddir),
      hr()
    )
    on.exit({
      shinyjs::show("threshold_ui")
      shinyjs::show("plot_bar")
    })
  })
  output$threshold_ui <- renderUI({
    ddir <- xcms()$ddir
    type <- xcms()$type
    ds <- select_input(ddir, type)
    sliderInput("threshold", "Select a threshold", min = ds$min, max = ds$max, step = 1, value = ds$min)
  })
  output$plot_bar <- renderPlotly({
    plot <- plot_bar(xcms()$ddir, xcms()$type, input$threshold)
    ggplotly(plot)
  })

  ipo <- eventReactive(input$IPO,
    {
      file <- list.files(dir()$dir, full.names = TRUE, recursive = TRUE)
      invisible(cat(IPO_status()$dii, file = ff, sep = "\n", append = TRUE))
      tt <- as.character(Sys.Date())
      ddir <- dir_name_IPO(tt)
      if (!dir.exists(ddir)) {
        dir.create(ddir)
      }
      dii <- paste0("Result directory: ", ddir)
      invisible(cat(IPO_status()$dii, file = ff, sep = "\n", append = TRUE))
      dii <- "XCMS-deafult: FALSE"
      invisible(cat(IPO_status()$dii, file = ff, sep = "\n", append = TRUE))
      dii <- "CAMERA-deafult: FALSE"
      invisible(cat(IPO_status()$dii, file = ff, sep = "\n", append = TRUE))
      IPO_optimize(file, ddir, dir()$dir, input$method)
      list(ddir = ddir)
    },
    ignoreInit = TRUE
  )

  output$IPO_res <- renderPrint({
    ipo()

    on.exit({
      shinyjs::show("IPO_res_R")
      shinyjs::hide("IPO_res")
    })
  })
  output$IPO_res_R <- renderPrint({
    ddir <- ipo()$ddir
    name <- paste0(ddir, "/IPO_optimize.R")
    dii <- paste0("IPO optimization code: ", name)
    cat(dii, file = ff, sep = "\n", append = TRUE)
    dd <- readLines(name)
    cat(dd, sep = "\n")
  })


  ipo_peaks <- eventReactive(input$IPO_peaks, {
    shinyjs::show("IPO_peaks_res")
    IPO_peaks(ipo()$ddir, input$polarity)
    dii <- paste0("Preaks quantification: TRUE")
    cat(dii, file = ff, sep = "\n", append = TRUE)
  })
  output$IPO_peaks_res <- renderPrint({
    ipo_peaks()
    on.exit({
      shinyjs::hide("IPO_peaks_res")
      shinyjs::show("threshold_ui_IPO")
      shinyjs::show("plot_bar_IPO")
    })
  })


  output$threshold_ui_IPO <- renderUI({
    ddir <- ipo()$ddir
    ds <- select_input(ddir, 0)
    sliderInput("threshold1", "Select a threshold", min = ds$min, max = ds$max, step = 1, value = ds$min)
  })
  output$plot_bar_IPO <- renderPlotly({
    plot <- plot_bar(ipo()$ddir, 0, input$threshold1)
    ggplotly(plot)
  })





  file_line <- readLines(ff)
  if (length(file_line) <= 4) {
    unlink(ff)
  }

  ################ tab3################################################################################

  thres_sample <- reactive({
    thres <- input$threshold_sample
    list(thres = thres)
  })

  sample <- eventReactive(input$samples_check,
    {
      shinyjs::show("case_check_inf")
      data_dir <- dir()$dir
      if (input$preprocessor) {
        ddir <- ipo()$ddir
        type <- 0
      } else {
        ddir <- xcms()$ddir
        type <- xcms()$type
      }
      clinic <- as.character(data()$cd)
      res <- sample_check(ddir, data_dir, type, input$polarity, clinic)
      dd <- res$sample_mass
      dii <- paste0("Samples check: TRUE")
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Peaks mass information: ", res$mass_inf)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Raw peaks intensity data: ", res$sample_mass)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Reserved peaks intensity data after samples checking: ", res$mean_res)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Droped peaks intensity data after samples checking: ", res$drop_res)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      data <- read.csv(dd)
      dat <- data[, -c(1, 2)]
      y <- as.numeric(as.vector(apply(dat, 1, data_count)))
      sample <- as.character(data[, 1])
      yo <- order(y)
      y <- y[yo]
      x <- sample[yo]

      dat <- data.frame(Sample = x, Frequence = y)

      list(dat = dat)
    },
    ignoreInit = TRUE
  )
  output$case_check_inf <- renderPrint({
    sample()
    on.exit({
      shinyjs::hide("case_check_inf")
      shinyjs::show("case_check")
      shinyjs::show("threshold_sample")
    })
  })

  output$case_check <- renderPlotly({
    dat <- sample()$dat
    s <- which(as.numeric(dat[, 2]) <= thres_sample()$thres)
    if (length(s) > 0) {
      dat <- dat[s, ]
    } else {
      dat <- dat
    }
    gg <- ggplot() +
      geom_bar(
        data = dat, aes(x = Sample, y = Frequence), fill = "green",
        stat = "identity"
      ) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggplotly(gg)
  })
  thres_peak <- reactive({
    thres <- input$threshold_peak
    list(thres = thres)
  })

  peaks <- eventReactive(input$peaks_check,
    {
      shinyjs::show("peak_check_inf")

      if (input$preprocessor) {
        ddir <- ipo()$ddir
        type <- 0
      } else {
        ddir <- xcms()$ddir
        type <- xcms()$type
      }
      res <- peaks_check(ddir)
      dii <- paste0("Peaks check: TRUE")
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Reserved peaks intensity data after peaks checking: ", res$mean_res)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      data <- read.csv(paste0(ddir, "/sample_mass.csv"))
      dat <- data[, -c(1, 2)]
      y <- as.numeric(as.vector(apply(dat, 2, data_count)))
      sample <- colnames(dat)
      yo <- order(y)
      y <- y[yo]
      x <- sample[yo]

      dat <- data.frame(Peaks = x, Frequence = y)

      list(dat = dat, ddir = ddir)
    },
    ignoreInit = TRUE
  )

  output$peak_check_inf <- renderPrint({
    peaks()
    on.exit({
      shinyjs::hide("peak_check_inf")
      shinyjs::show("peak_check")
      shinyjs::show("threshold_peak")
    })
  })
  output$peak_check <- renderPlotly({
    dat <- peaks()$dat
    s <- which(as.numeric(dat[, 2]) <= thres_peak()$thres)
    if (length(s) > 0) {
      dat <- dat[s, ]
    } else {
      dat <- dat
    }
    gg <- ggplot() +
      geom_bar(
        data = dat, aes(x = Peaks, y = Frequence), fill = "red",
        stat = "identity"
      ) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggplotly(gg)
  })



  abnormal_detail <- eventReactive(input$abnormal, {
    shinyjs::show("abnormal_plot_inf")
    ddir <- peaks()$ddir
    file_path <- paste0(ddir, "/sample_mass_clean_samples_peaks_mean.csv")
    data <- read.csv(file = file_path)
    rownames(data) <- as.character(data[, 1])
    dat <- data[, -c(1, 2)]
    res <- pcout(dat)
    if (class(res) == "list") {
      group <- res$wfinal01
      gs <- which(group == 1)
      data <- data[gs, ]
      file_path1 <- paste0(ddir, "/sample_mass_clean_samples_peaks_abnormal_mean.csv")
      write.csv(data, file_path1, row.names = FALSE)
      dii <- paste0("Peaks check: TRUE")
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Reserved peaks intensity data after abnormal checking: ", file_path1)
      cat(dii, file = ff, sep = "\n", append = TRUE)
    } else {
      dii <- paste0("Peaks check: FALSE")
      cat(dii, file = ff, sep = "\n", append = TRUE)
    }
    list(ddir = ddir, res = res)
  })



  output$abnormal_plot_inf <- renderPrint({
    abnormal_detail()
    if (class(abnormal_detail()$res) == "list") {
      shinyjs::show("abnormal_plot")
    }
  })
  output$abnormal_plot <- renderPlotly({
    if (class(abnormal_detail()$res) == "list") {
      dat <- data.frame(abnormal_detail()$res)
      dat[which(dat$wfinal01 == 1), "wfinal01"] <- "Retain"
      dat[which(dat$wfinal01 == 0), "wfinal01"] <- "Outlier"
      dat <- data.frame(sample = rownames(dat), dist1 = dat$x.dist1, dist2 = dat$x.dist2, group = dat$wfinal01)
      gg <- ggplot(data = dat, (aes(dist1, dist2, fill = group, colour = group))) +
        geom_point(size = 2) +theme_bw()
        guides(colour = guide_legend(override.aes = list(size = 2))) +
        theme(legend.position = "bottom") +
        geom_text(aes(dist1, dist2, label = sample))
      ggplotly(gg)
    }
  })

  observeEvent(input$impute,
    {
      shinyjs::show("impute_method")
    },
    ignoreInit = TRUE
  )
  output$impute_method <- renderUI({
    ddir <- peaks()$ddir
    file <- list.files(ddir)
    file <- file[grep(".", file, fixed = TRUE)]
    tags$p(
      selectInput("method_impute", "Select a method:", choices = c("mice.impute.pmm", "mice.impute.midastouch", "mice.impute.cart", "mice.impute.norm", "mice.impute.quadratic", "impute.knn"), selected = "mice.impute.pmm", width = "100%"),
      selectInput("data_impute", "Select a method:",
        choices = file, selected = "sample_mass_clean_samples_abnormal_mean.csv", width = "100%"
      ),
      tags$hr(),
      actionButton("compute_impute", "Go !", width = "100%")
    )
  })

  impute_custom <- eventReactive(input$compute_impute,
    {
      shinyjs::show("impute_result")
      method <- input$method_impute
      ddir <- peaks()$ddir
      file_path <- paste0(ddir, "/", input$data_impute)
      data <- read.csv(file = file_path)
      data[data == 0] <- NA
      dat <- data[, -c(1, 2)]
      if (length(grep("mice", method)) > 0) {
        mm <- unlist(strsplit(method, ".", fixed = TRUE))[3]
        imp <- mice(data, method = mm)
        impute_data <- complete(imp)
        # pp=paste0(ddir,"/",method,".pdf")
        # pdf(pp)
        # plot(imp)
        # dev.off()
      } else {
        dr <- impute.knn(as.matrix(dat), rowmax = 1, colmax = 1)
        impute_data <- cbind(data[, c(1, 2)], dr$data)
      }
      impute_dat <- impute_data[, -c(1, 2)]
      file <- paste0(ddir, "/impute_", input$data_impute)
      write.csv(impute_data, file, row.names = FALSE)
      dii <- paste0("Peaks impute: TRUE")
      cat(dii, file = ff, sep = "\n", append = TRUE)
      dii <- paste0("Peaks intensity data after Peaks imputing: ", file)
      cat(dii, file = ff, sep = "\n", append = TRUE)
      mean_raw <- apply(dat, 1, function(x) {
        mean(x, na.rm = TRUE)
      })
      mean_impute <- apply(impute_dat, 1, function(x) {
        mean(x, na.rm = TRUE)
      })
      id <- c(1:length(mean_raw))
      mean_raw1 <- cbind(mean_raw, "Raw")
      mean_impute1 <- cbind(mean_impute, "Impute")
      mean <- rbind(mean_raw1, mean_impute1)
      colnames(mean) <- c("intensity", "group")
      mean <- data.frame(mean)
      mean <- cbind(id, mean)
      g1 <- ggplot(mean, aes(x = id, y = intensity, color = group, group = group)) +
        geom_line() +
        labs(
          y = "Mean of peaks intensity", x = ""
        ) +
        theme(axis.text = element_blank())


      sd_raw <- apply(dat, 1, function(x) {
        sd(x, na.rm = TRUE)
      })
      sd_impute <- apply(impute_dat, 1, function(x) {
        sd(x, na.rm = TRUE)
      })
      id <- c(1:length(sd_raw))
      sd_raw1 <- cbind(sd_raw, "Raw")
      sd_impute1 <- cbind(sd_impute, "Impute")
      sd <- rbind(sd_raw1, sd_impute1)
      colnames(sd) <- c("intensity", "group")
      sd <- cbind(id, sd)
      sd <- data.frame(sd)
      g2 <- ggplot(sd, aes(x = id, y = intensity, color = group, group = group)) +
        geom_line() +
        labs(
          y = "SD of peaks intensity", x = ""
        ) +
        theme(axis.text = element_blank())
      pp <- plot_grid(g1, g2, nrow = 2, labels = LETTERS[1:2], align = c("v", "h"))
      list(plot = pp, file = file, data = impute_data)
    },
    ignoreInit = TRUE
  )

  output$impute_plot <- renderPlot({
    impute_custom()$plot
  })
  output$download <- downloadHandler(
    filename = function() {
      paste("impute_peaks_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(impute_custom()$data, file, row.names = FALSE)
    }
  )

  output$download_peaks <- downloadHandler(
    filename = function() {
      paste("peaks_information_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      ddir <- peaks()$ddir
      file_path <- paste0(ddir, "/mass_inf_mean.csv")
      data <- read.csv(file_path)
      write.csv(data, file, row.names = FALSE)
    }
  )

  output$impute_result <- renderUI({
    impute_custom()
    shinyjs::show("translate")
    tags$div(
      plotOutput("impute_plot"),
      hr(),
      downloadLink("download", "Download imputed results"),
      strong("  | "),
      downloadLink("download_peaks", "Download peaks information")
    )
  })






  ################# tab4############################################################
  observeEvent(input$ok,
    {
      shinyjs::hide("pro_detail")
    },
    once = TRUE
  )

  output$jobs_list <- renderUI({
    data <- list.files("data/jobs")
    text <- as.POSIXct(as.numeric(data), origin = "1970-01-01")
    names(data) <- text
    data <- sort(data, decreasing = TRUE)
    dd <- which(as.Date(names(data)) == input$date_id)
    if (length(dd) > 0) {
      shinyjs::show("jobs_detail")
      data <- data[dd]
      selectInput("jobs_ID", "Jobs list", choices = data, width = "100%")
    } else {
      shinyjs::hide("jobs_detail")
      helpText(paste0("No related work on ", input$date_id))
    }
  })

  output$jobs_detail <- renderPrint({
    file <- file(paste0("data/jobs/", input$jobs_ID), "rt")
    dd <- readLines(file)
    ff <- paste0("data/jobs/", input$jobs_ID)
    cat(paste0("Result data: ", ff), sep = "\n\n")
    cat("************************************************", sep = "\n\n")
    cat(dd, sep = "\n\n")
    close(file)
  })

  output$translate <- renderUI({
    ddir <- peaks()$ddir
    file <- list.files(ddir)
    file <- file[grep(".", file, fixed = TRUE)]
    tags$p(
      selectInput("data_meta", "Select peaks data:",
        choices = file, selected = "sample_mass_clean_samples_abnormal_mean.csv", width = "100%"
      ),
      tags$hr(),
      actionButton("MetaboAnalyst", "To MetaboAnalyst", width = "100%")
    )
  })
  toMeta <- eventReactive(input$MetaboAnalyst, {
    file <- input$data_meta
    ddir <- peaks()$ddir
    MetaboAnalyst(ddir, file)
    ff <- paste0("MetaboAnalyst_", file)
    list(file = ff, ddir = ddir)
  })
  output$download_mass <- downloadHandler(
    filename = function() {
      paste("MetaboAnalyst_peaks_intensity_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      ddir <- peaks()$ddir
      file_path <- paste0(ddir, "/", toMeta()$file)
      data <- read.csv(file_path)
      write.csv(data, file, row.names = FALSE)
    }
  )
  output$download_inf <- downloadHandler(
    filename = function() {
      paste("MetaboAnalyst_mass_inf_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      ddir <- peaks()$ddir
      file_path <- paste0(ddir, "/mass_inf_mean.csv")
      data <- read.csv(file_path)
      write.csv(data, file, row.names = FALSE)
    }
  )

  output$tometa <- renderUI({
    toMeta()
    tags$div(
      downloadLink("download_inf", "Download peaks information"),
      tags$br(),
      downloadLink("download_mass", "Download peaks matrix")
    )
  })

  data_res <- reactive({
    file <- file(paste0("data/jobs/", input$jobs_ID), "rt")
    dd <- readLines(file)
    close(file)
    if (length(dd) > 3) { ## data results
      dirr <- grep("Result directory", dd)
      dir <- dd[max(dirr)]
      dir <- unlist(strsplit(dir, ": "))[2]

      ## Data directory
      ddir <- grep("Data directory", dd)
      ddir <- dd[max(ddir)]
      ddir <- unlist(strsplit(ddir, ": "))[2]


      # polarity
      polar <- grep("Polarity", dd)
      if (length(polar) > 0) {
        polar <- dd[max(polar)]
        polar <- unlist(strsplit(polar, ": "))[2]
      } else {
        polar <- NA
      }

      ## IPO
      IPO <- grep("IPO: ", dd)
      ipo <- dd[max(IPO)]
      ipo <- unlist(strsplit(ipo, ": "))[2]
      data <- list.files(dir)
      if (ipo) {
        rcode <- which(data == "IPO_optimize.R")
        if (length(rcode) > 0) {
          IPO_R <- 1
          quantify <- which(data == "IPO_output_camera.csv")
          if (length(quantify) > 0) {
            IPO_quantify <- 1
            CAMERA <- 1
          } else {
            IPO_quantify <- 0
            CAMERA <- 0
          }
        } else {
          IPO_R <- 0
          IPO_quantify <- 0
          CAMERA <- 0
        }
      } else {
        IPO_R <- 0
        IPO_quantify <- 0
        CAMERA <- 0
        XCMS <- 0
        camera <- grep("CAMERA-deafult: ", dd)
        camera <- dd[max(camera)]
        camera <- unlist(strsplit(camera, ": "))[2]
        if (camera) {
          CAMERA <- 1
        }
        xcms <- grep("XCMS-deafult: ", dd)
        xcms <- dd[max(xcms)]
        xcms <- unlist(strsplit(xcms, ": "))[2]
        if (xcms) {
          XCMS <- 1
        }
      }
    } else {
      dir <- ""
      data <- ""
      IPO_R <- 0
      IPO_quantify <- 0
      CAMERA <- 0
      XCMS <- 0
    }
    list(ddir = dir, data = ddir, polar = polar, IPO_R = IPO_R, IPO_quantify = IPO_quantify, CAMERA = CAMERA, XCMS = XCMS)
  })
  output$menu <- renderUI({
    menu <- c(
      "Select a progress" = "0",
      "IPO code" = "IPO_R",
      "IPO quantify for peaks" = "IPO_quantify",
      "Default CAMERA quantify for peaks" = "CAMERA",
      "Default XCMS quantify for peaks" = "XCMS"
    )
    shinyjs::show("menu_exec")
    tags$div(
      hr(),
      selectInput("menu_check", "Analysis of the process", choices = menu)
    )
  })






  observeEvent(input$menu_exec, {
    if (input$menu_check == 0) {
      st <- "Please select a analysis progress!"
    } else {
      if (data_res()[input$menu_check] == 1) {
        st <- "This analysis progress has been done,do you want to analysis agin ?"
      } else {
        st <- "This analysis progress has not been done,do you want to analysis ?"
      }
    }
    showModal(modalDialog(
      title = "Status",
      st,
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok", "OK")
      )
    ))
  })


  pro_exec <- eventReactive(input$ok, {
    removeModal(session)
    shinyjs::show("pro_detail")
    if (input$menu_check == 0) {
      HTML("<font color='red'><strong>Please select a analysis progress!</strong></font>")
    }
    if (input$menu_check == "IPO_R") {
      file <- list.files(data_res()$data, full.names = TRUE, recursive = TRUE)
      IPO_optimize(file, data_res()$ddir, data_res()$data)
      HTML("<font color='green'><strong>Analysis has been done!</strong></font>")
    }
    if (input$menu_check == "IPO_quantify") {
      IPO_peaks(data_res()$ddir, data_res()$data, data_res()$polar)
      HTML("<font color='green'><strong>Analysis has been done!</strong></font>")
    }
    if (input$menu_check == "CAMERA") {
      file <- list.files(data_res()$data, full.names = TRUE, recursive = TRUE)
      camera_peaks(file, data_res()$ddir, data_res()$polar)
      HTML("<font color='green'><strong>Analysis has been done!</strong></font>")
    }
    if (input$menu_check == "XCMS") {
      file <- list.files(data_res()$data, full.names = TRUE, recursive = TRUE)
      xcms_peaks(file, data_res()$ddir, data_res()$polar)
      HTML("<font color='green'><strong>Analysis has been done!</strong></font>")
    }
  })
  output$pro_detail <- renderUI({
    pro_exec()
  })
  ############ data clean
  output$menu <- renderUI({
    menu <- c(
      "Select a progress" = "0",
      "IPO code" = "IPO_R",
      "IPO quantify for peaks" = "IPO_quantify",
      "Default CAMERA quantify for peaks" = "CAMERA",
      "Default XCMS quantify for peaks" = "XCMS"
    )
    shinyjs::show("menu_exec")
    tags$div(
      hr(),
      selectInput("menu_check", "Analysis of the process", choices = menu)
    )
  })
})
