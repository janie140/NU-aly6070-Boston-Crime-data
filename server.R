# Trang Tran, ALY 6070, Module 5

library(shinydashboard)
library(shiny)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(RColorBrewer)#colour
library(DT) #data table
library(ggmap)# to create map
library(scales)

setwd("/Users/trangtran/Downloads/A3")

# Read data set
df <- read.csv("crime_df_cleaned.csv")

# year-to-year incidents and shootings count
yearly_data_df <- df |>
  group_by(year) |>
  summarise(total_incidents = n(), shooting_count = sum(shooting))

# Define server
shinyServer(function(input, output) {
  yearly_data <- reactive({
    filtered_data <- yearly_data_df |> 
      filter(year >= input$year_range[1] & year <= input$year_range[2])
    return(filtered_data)
  })
  
  output$Plot1 <- renderPlot({
    ggplot(yearly_data(), aes(x = year, y = total_incidents)) +
      geom_line(color = 'blue') +
      labs(title = "Number of Incidents over Years",
           subtitle = "Total crime incidents are in a downtrend during 2019-2020 period",
           x = "Year",
           y = "Total Incidents") +
      theme(plot.title = element_text(size = 20, color = "blue", face = "bold"),
            plot.subtitle = element_text(face = "bold")) +
      scale_y_continuous(labels = function(x) format(x/1000, big.mark = ",",
                                                     scientific = FALSE, trim = TRUE) |> 
                           paste0("K"),
                         limits = c(0, max(yearly_data()$total_incidents) + 3000)) +
      scale_x_continuous(breaks = seq(min(yearly_data()$year),
                                      max(yearly_data()$year), by = 1))
  })
  output$Plot2 <- renderPlot({
    ggplot(yearly_data(), aes(x = year, y = shooting_count)) +
      geom_line(color = "red") +
      labs(title = "Shooting Count over Years",
           subtitle = 'Total shooting counts saw a significant surge from 2019 to 2022',
           x = "Year",
           y = "Shooting Count") +
      theme(plot.title = element_text(size = 20, color = "red", face = "bold"),
            plot.subtitle = element_text(face = "bold")) +
      scale_y_continuous(limits = c(0, max(yearly_data()$shooting_count) + 5)) +
      scale_x_continuous(breaks = seq(min(yearly_data()$year), max(yearly_data()$year), by = 1))
  })
  
  top_crime_data <- reactive({
    filtered_data_2 <- df |> 
      filter(year >= input$year_range[1] & year <= input$year_range[2])
    return(filtered_data_2)
  })
  
  output$Plot3 <- renderPlot({
    top_crime_types <- top_crime_data() |> 
      group_by(offense_description) |> 
      summarise(total_incidents = n(), shooting_count = sum(shooting)) |> 
      arrange(desc(total_incidents)) |> 
      head(10)
    
    top_crime_types$offense_description <- factor(top_crime_types$offense_description,
                                                  levels = rev(top_crime_types$offense_description))
    
    
    ggplot(top_crime_types, aes(x = total_incidents, y = offense_description,
                                fill = shooting_count)) +
      geom_bar(stat = "identity") +
      labs(title = "Top 10 Crime Types with their Shooting Count",
           subtitle = 'Investigate Property and Vandalism have the highest counts of shootings among top 10 crimes',
           x = "Incidents Count",
           y = "Crime Type") +
      theme(plot.title = element_text(size = 20, color = "darkorange", face = "bold"),
            plot.subtitle = element_text(face = "bold")) +
      scale_fill_gradient(low = "yellow", high = "darkorange") +
      guides(fill = guide_legend(title = "Shooting Count"))
  })
})





