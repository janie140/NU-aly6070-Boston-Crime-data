# Trang Tran, ALY 6070, Module 5

################ Define UI of the dashboard #####################################
shinyUI(dashboardPage(
  dashboardHeader(title = "BostonCrime_Trang"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview")
      # Add more menu items if needed
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              sliderInput('year_range',
                          'Select Year Range',
                          value = c(2016, 2022),
                          min = 2015,
                          max = 2023,
                          step = 1,
                          sep = ""),
              HTML("<h4 style='color: gray;'>We don't have a full year's data for 2015 and 2023</h4>"),
              fluidRow(
                column(6, plotOutput("Plot1", width = "100%", height = "350px")),
                column(6, plotOutput("Plot2", width = "100%", height = "350px"))
              ),
              fluidRow(
                column(12, plotOutput("Plot3", width = "100%", height = "400px"))
              )
      )
      # Add more tabItems for other tabs if needed
    )
  )
)
)

# ######################### Define UI of the Web App ############################
# shinyUI(fluidPage(
#   titlePanel("Boston Crime: Year-to-Year Overview"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput('year_range',
#                   'Select Year Range',
#                   value = c(2016, 2022),
#                   min = 2015,
#                   max = 2023,
#                   step = 1,
#                   sep = ""),
#       HTML("<h4 style='color: gray;'>We don't have a full year's data for 2015 and 2023</h4>")
# 
#     ),
#     mainPanel(
#       fluidRow(
#         column(6, plotOutput("Plot1", width = "100%", height = "350px")),
#         column(6, plotOutput("Plot2", width = "100%", height = "350px"))
#       ),
#       fluidRow(
#         column(12, plotOutput("Plot3", width = "100%", height = "400px")
#       ),
#     )
#   )
# )
# )
# )

