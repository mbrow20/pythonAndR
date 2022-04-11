# Import R packages needed for the app here:
library(shiny)
library(DT)
library(RColorBrewer)

# Define any Python packages needed for the app here:
PYTHON_DEPENDENCIES = c('pip', 'numpy')

# Begin app server
shinyServer(function(input, output) {
  filedata <- reactive({
    infile <- input$file1
    if (is.null(infile)){
      return(NULL)      
    }
    read.csv(infile$datapath)
  })
  # ------------------ App virtualenv setup (Do not edit) ------------------- #
  
  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  python_path = Sys.getenv('PYTHON_PATH')
  
  # Create virtual env and install dependencies
  reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES, ignore_installed=TRUE)
  reticulate::use_virtualenv(virtualenv_dir, required = T)
  
  # ------------------ App server logic (Edit anything below) --------------- #
  
  #plot_cols <- brewer.pal(7, 'BrBG')
  
  # Import python functions to R
  reticulate::source_python('python_functions.py')
  
  # Generate the requested distribution
  #d <- reactive({
    #dist <- switch(input$dist,
                   #norm = rnorm,
                   #unif = runif,
                   #lnorm = rlnorm,
                   #exp = rexp,
                   #rnorm)
    
    #return(dist(input$n))
  #})
  
  #display table on main panel
  output$contents <- renderTable({
    df <- filedata()
    df <- na.omit(df)
    if (is.null(df)) return(NULL)
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  output$outcomeVar <- renderUI({
    df <- filedata()
    df <- na.omit(df)
    if (is.null(df)) return(NULL)
    if(apply(df,2, is.character) == TRUE){
      createAlert(session, "alert", "exampleAlert", title = "CAUTION",
                  content = "You must use only numeric or integer variables in your model. No strings, please.",
                  append = FALSE)}
    
    
    items=names(df)
    #items[1] = "id"
    names(items)=items
    selectInput("outcomeVar","Select ONE variable as dependent variable from:",items)
  })
  
  output$independents <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    items=names(df)
    #items[1] = "id"
    checkboxGroupInput('independents','Select the regressors (exclude dependent/outcome variable)', choices = items)
  })
  
  model4 <-  eventReactive (input$random,{
    data4    <- filedata()
    data4    <- na.omit(data4)
    varNames <- colnames(data4)
    n        =  nrow(data4)
    
    outVar = input$outcomeVar
    data4 <- data4[,c(outVar,unlist(input$independents))]
    
    if(length(input$independents)<2){
      print("Please choose more than 1 regressor variable!")
      return()}
    lmMod = lm (data4[,1]~., data=data4)
    summary(lmMod)
})
  
  output$linearModel <- renderPrint({
    if (is.null(df)) return(NULL)
    model4()
  })
  
  # Generate a plot of the data
  #output$plot <- renderPlot({
    #dist <- input$dist
    #n <- input$n
    
    #return(hist(d(),
                #main = paste0('Distribution plot: ', dist, '(n = ', n, ')'),
                #xlab = '',
                #col = plot_cols))
  #})
  
  # Test that the Python functions have been imported
  #output$message <- renderText({
    #return(test_string_function(input$str))
  #})
  
  # Test that numpy function can be used
  #output$xy <- renderText({
    #z = test_numpy_function(input$x, input$y)
    #return(paste0('x + y = ', z))
  #})
  
  # Display info about the system running the code
  output$sysinfo <- DT::renderDataTable({
    s = Sys.info()
    df = data.frame(Info_Field = names(s),
                    Current_System_Setting = as.character(s))
    return(datatable(df, rownames = F, selection = 'none',
                     style = 'bootstrap', filter = 'none', options = list(dom = 't')))
  })
  
  # Display system path to python
  output$which_python <- renderText({
    paste0('which python: ', Sys.which('python'))
  })
  
  # Display Python version
  output$python_version <- renderText({
    rr = reticulate::py_discover_config(use_environment = 'python35_env')
    paste0('Python version: ', rr$version)
  })
  
  # Display RETICULATE_PYTHON
  output$ret_env_var <- renderText({
    paste0('RETICULATE_PYTHON: ', Sys.getenv('RETICULATE_PYTHON'))
  })
  
  # Display virtualenv root
  output$venv_root <- renderText({
    paste0('virtualenv root: ', reticulate::virtualenv_root())
  })
  
})
