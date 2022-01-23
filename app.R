## app.R ##
library(shiny)
library(shinydashboard)

source("prep_data.R")

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "classicalmodel"),
  dashboardSidebar(width = 200,
                   sidebarMenu(
                     menuItem("Overview", tabName="Overview", icon=icon("chart-bar")),
                     menuItem("Data", tabName="Data", icon=icon("database"))
                   )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Overview",

      fluidRow(
        box(
          title = "Daily statistics", solidHeader = TRUE,
          collapsible = FALSE, width=8,
          DT::dataTableOutput("table")
        ),
        
        box(
          title = "Total Price", solidHeader = TRUE,
          width=4,
          plotOutput("plot_price")
        )
        ),
      
      hr(),
      
      fluidRow(
      box(title = "Total orders", solidHeader = TRUE,
          width=4, textOutput("n_orders"))
      ) #fluidRow
      ), # tabItem 1
      
      
      tabItem(tabName = "Data",
        fluidRow(
          box(
            title = "Browse order details", solidHeader = TRUE,
            width = 12,
            DT::dataTableOutput("df_orders")
          )
        )
      ) # tabItem 2
      
    ) #tabItems
  
    
  ) # dashboardBody
) #dashboardPage



server <- function(input, output) { 

  output$table <- DT::renderDataTable(order_by_status,
                                       filter = list(position = 'top', clear = FALSE), # filter for columns
                                       extensions = 'Buttons', # copy / download buttons
                                       options = list(dom = 'Bfrtip',
                                                      buttons = list('copy', list(
                                                        extend = 'collection',
                                                        buttons = c('csv', 'excel', 'pdf'),
                                                        text = 'Download'
                                                      )))
  )  
  # Reactive dataframe that depend on the filtered 'table2' using 'search' tab in UI
  selected_orders <- reactive({
    df_orders[input$table_rows_all, ]
  })

  output$n_orders <- renderText({
    paste("N. Orders:", as.character(length(unique(selected_orders()$orderNumber))))
  })

  
  } # server function end

shinyApp(ui, server)