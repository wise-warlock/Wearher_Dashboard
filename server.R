library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)
library(httr)
library(jsonlite)
library(plotly)

api_key <- "8757d6f27a761484bc44b16f4660a7c9"

get_weather_data <- function(api_key, lat, lon) {
  url <- paste0("http://api.openweathermap.org/data/2.5/forecast?lat=", lat,
                "&lon=", lon, "&appid=", api_key)
  response <- GET(url)
  data <- fromJSON(content(response, "text"), flatten = TRUE)
  

  city_info <- data$city
  
  forecast_list <- data$list
  
  forecast_data <- data.frame(
    time = as.POSIXct(forecast_list$dt_txt, format="%Y-%m-%d %H:%M:%S", tz="UTC"),
    temp = forecast_list$main.temp - 273.15,
    feels_like = forecast_list$main.feels_like - 273.15,
    temp_min = forecast_list$main.temp_min - 273.15,
    temp_max = forecast_list$main.temp_max - 273.15,
    pressure = forecast_list$main.pressure,
    sea_level = forecast_list$main.sea_level,
    grnd_level = forecast_list$main.grnd_level,
    humidity = forecast_list$main.humidity,
    speed = forecast_list$wind.speed,
    deg = forecast_list$wind.deg,
    gust = forecast_list$wind.gust,
    weather_condition = forecast_list$weather[[1]]$description,
    visibility = forecast_list$visibility
  )
  
  list(
    city = city_info,
    forecast = forecast_data
  )
}

shinyServer(function(input, output, session) {
  # Reactive values to store latitude and longitude
  lat_lon <- reactiveValues(lat = "21.027763", lon = "105.834160")
  
  weather_data <- reactive({
    get_weather_data(api_key, lat_lon$lat, lat_lon$lon)
  })
  
  output$datetime <- renderText({
    format(as.Date(weather_data()$forecast$time[1]), "%Y-%m-%d")
  })
  
  output$city1 <- renderText({
    paste(weather_data()$city$name)
  })
  
  output$city2 <- renderText({
    paste(weather_data()$city$name)
  })
  
  output$temperature <- renderText({
    paste(weather_data()$forecast$temp[1], "°C")
  })
  
  output$feels_like <- renderText({
    paste(weather_data()$forecast$feels_like[1], "°C")
  })
  
  output$humidity <- renderText({
    paste(weather_data()$forecast$humidity[1], "%")
  })
  
  output$weather_condition <- renderText({
    paste(weather_data()$forecast$weather_condition[1])
  })
  
  output$visibility <- renderText({
    paste(weather_data()$forecast$visibility[1] / 1000, "km")
  })
  
  output$wind_speed <- renderText({
    paste(weather_data()$forecast$speed[1], "km/h")
  })
  
  output$pressure <- renderText({
    paste(weather_data()$forecast$pressure[1], "hPa")
  })
  
  output$map <- renderLeaflet({
    leaflet()%>%
      addTiles()%>%
      setView(lng = lat_lon$lon, lat = lat_lon$lat, zoom = 10)
  })
  
  observeEvent(input$map_click, {
    lat_lon$lat <- input$map_click$lat
    lat_lon$lon <- input$map_click$lng
    
    # Update the map view
    leafletProxy("map") %>%
      setView(lng = lat_lon$lon, lat = lat_lon$lat, zoom = 10)
  })
  
  output$weatherPlot <- renderPlotly({
    selected_feature <- weather_data()$forecast[[input$feature]]
    ggplot(weather_data()$forecast, aes(x = time)) +
      geom_line(aes(y = selected_feature, color = "blue")) +
      geom_point(aes(y = selected_feature, color = "red")) +
      labs(y = input$feature, x = "time") +
      theme_minimal() +
      scale_x_datetime(date_labels = "%Y-%m-%d %H:%M:%S", date_breaks = "12 hour") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  })
})

