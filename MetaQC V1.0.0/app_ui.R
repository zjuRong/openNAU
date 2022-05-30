# Define UI for application that draws a histogram
ui <- shinyUI(navbarPage("Metabolism quality control systerm",
  id = "index",
  theme = shinytheme("cosmo"),
  useShinyjs(),
  tabPanel("Overview",
    id = "tab1",
    sidebarLayout(
      sidebarPanel(
        textInput("title", "Project title", width = "100%"),
        actionButton("title_load", "Create", width = "100%"),
        hidden(tags$div(helpText("Project created!"), id = "lags")),
        tags$hr(),

        # Input: Select a file ----
        # shinyFilesButton("file_raw", "File select", "Please select a file", multiple = TRUE, viewtype = "detail"),
        # tags$p(),
        shinyDirButton("directory_raw", "Select a dataset ", "Please select a folder", style = "width:100%"),
        tags$p(),
        shinyFilesButton("file_raw", "Select a sample group dataset", "Please select a file", style = "width:100%", multiple = TRUE, viewtype = "detail"),
        helpText("You should select a sample group data file (.csv). it includes two columns: filename, group."),
        tags$p(),
        # radioButtons("plot_type","The plot type for raw data",c("Line"="1","Heatmap"="2"),selected = "1" ),
      ),
      mainPanel(
        # withSpinner(tableOutput("plot_step11")),

        tags$hr(),
        tags$p("Raw data file size:"),
        # withSpinner(uiOutput("check_1")),
        hidden(tags$div(id = "plot1", plotlyOutput("plot_step1"))),
        tags$hr(id = "line1"),
        withSpinner(plotOutput("plot_step2")),
        tags$hr(id = "line2"),
        # withSpinner(uiOutput("check_2"))
        withSpinner(plotOutput("plot_step3", height = "600"))
      )
    )
  ),
  tabPanel("Find peaks",
    id = "tab2",
    sidebarLayout(
      sidebarPanel(
        checkboxInput("preprocessor", "Optimize XCMS parameters", value = FALSE, width = "100%"),
        tags$hr(),
        selectInput("polarity", "Select ploarity:", choices = c("Positive", "Negative"), width = "100%"),
        uiOutput("prep"),
        # checkboxInput("custom","Custom parameters",value = FALSE,width = "100%"),
        tags$hr(),
        hidden(uiOutput("threshold_ui")),
        tags$hr(),
        hidden(uiOutput("threshold_ui_IPO"))
        # # Input: Select a file ----
        # fileInput("file", "Choose Raw1 data",
        #           multiple = TRUE,
        #           accept = c(".raw", "text/comma-separated-values,text/plain",".xml"),
        #           placeholder = "Select all data"),
      ),
      mainPanel(
        tags$div(id = "top"),
        verbatimTextOutput("IPO_analysis"),
        # tags$div(plotOutput("update", width = "100%", height = "100px"),id="update"),
        withSpinner(uiOutput("xcms")),
        hidden(plotlyOutput("plot_bar")),
        tags$hr(),
        # uiOutput("xcms_result"),
        # tags$hr(),
        withSpinner(verbatimTextOutput("IPO_res")),
        hidden(verbatimTextOutput("IPO_res_R")),
        tags$hr(),
        withSpinner(verbatimTextOutput("IPO_peaks_res")),
        hidden(plotlyOutput("plot_bar_IPO")),
      )
    )
  ),
  tabPanel("Data cleaning",
    id = "tab3",
    sidebarLayout(
      sidebarPanel(
        actionButton("samples_check", "Samples check", width = "100%"),
        hidden(sliderInput("threshold_sample", "Select a threshold", min = 0, max = 1, step = 0.1, value = 0.5)),
        tags$hr(),
        actionButton("peaks_check", "Peaks check", width = "100%"),
        hidden(sliderInput("threshold_peak", "Select a threshold", min = 0, max = 1, step = 0.1, value = 0.8)),
        tags$hr(),
        actionButton("abnormal", "Test of outlier", width = "100%"),
        tags$hr(),
        actionButton("impute", "Impute peaks", width = "100%"),
        hidden(uiOutput("impute_method")),
        tags$hr()
      ),
      mainPanel(
        withSpinner(textOutput("case_check_inf")),
        hidden(plotlyOutput("case_check")),
        withSpinner(textOutput("peak_check_inf")),
        hidden(plotlyOutput("peak_check")),
        withSpinner(verbatimTextOutput("abnormal_plot_inf")),
        hidden(plotlyOutput("abnormal_plot", height = "500px")),
        withSpinner(uiOutput("impute_result"))
      )
    )
  ),
  tabPanel("All jobs",
    id = "tab4",
    sidebarLayout(
      sidebarPanel(
        dateInput("date_id", "Select a date:", value = Sys.Date()),
        uiOutput("jobs_list"),
        tags$hr(),
        uiOutput("translate"),
        # uiOutput("menu"),
        # hidden(actionButton("menu_exec","Execute", width = "100%") ),
        # tags$hr(),
        # withSpinner(uiOutput("pro_detail"))
        tags$hr(),
        withSpinner(uiOutput("tometa"))
      ),
      mainPanel(
        verbatimTextOutput("jobs_detail")
        # bsModal("mods_menu_exec","Status","menu_exec",size = "small",uiOutput("progress_check"))
      )
    )
  )
))
