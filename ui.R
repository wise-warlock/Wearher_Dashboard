library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(ggplot2)

shinyUI(dashboardPage(
  dashboardHeader(title = "Weather Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      div(
        class = "user-profile",
        tags$img(src = "https://i.pinimg.com/736x/7a/87/78/7a8778df17c669476fd41cc7ab7c0f59.jpg", width = "50px", height = "50px"),
        div(
          style = "display: inline-block; vertical-align: top; margin-top: 5px; margin-left: 10px;",
          p("Dương Lâm", style = "text-align: center; font-size: 15px; margin: 0;"),
          div(
            style = "text-align: center; margin-top: -1px; margin-right: 20px;",
            icon("circle", class = "text-success", style = "font-size: 15px"),
            " Online"
          )
        )
      ),
      menuItem("Weather", tabName = "weather", icon = icon("cloud")),
      menuItem("Forecast", tabName = "forecast", icon = icon("line-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "weather",
              div(class = 'tab-content',
                  tabPanel("Weather",
                           class = "active",
                           h1(style ="font-size:66px;" ,"Current Weather"),
                           splitLayout(
                             cellWidths = c("50%", "50%"),
                             div(class = "content",
                                 fluidRow(
                                   column(
                                     width = 12,
                                     h2(
                                        span(icon("location-crosshairs", lib = "font-awesome", style = "font-size: 55px; margin-right: 5px;"),textOutput("city1"), style = "font-size: 55px; font-weight: bold;  display: flex;", id = "location")
                                     )
                                   )
                                 ),
                                 fluidRow(
                                   column(
                                     width = 12,
                                     h3(
                                       span(textOutput("datetime"), style = "font-size: 25px; font-weight: bold;", id = "Time")
                                     )
                                   )
                                 ),
                                 fluidRow(
                                   column(
                                     width = 12,
                                     h2(
                                       icon("temperature-three-quarters", lib = "font-awesome", style = "font-size: 35px; margin-right: 5px;"),
                                       span("Current Temperature: ", style = "font-size: 35px;"),
                                     )
                                   )
                                 ),
                                 fluidRow(
                                   column(
                                     width = 12,
                                     h3( style = "font-size: 35px;",textOutput("temperature")),
                                   )
                                 ),
                                 fluidRow(
                                   column(width = 12, div(class = "line-split"))
                                 ),
                                 fluidRow(column(width = 12)),
                                 fluidRow(
                                   box(
                                     width = 4,
                                     title = "Feels Like",
                                     status = "danger",
                                     solidHeader = TRUE,
                                     span(textOutput("feels_like"), id = "feels_like")
                                   ),
                                   box(
                                     width = 4,
                                     title = "Humidity",
                                     status = "info",
                                     solidHeader = TRUE,
                                     span(textOutput("humidity"), id = "humidity")
                                   ),


                                   box(
                                     width = 4,
                                     title = "Weather Condition",
                                     status = "success",
                                     solidHeader = TRUE,
                                     span(textOutput("weather_condition"), id = "weather_condition")
                                   ),

                                   box(
                                     width = 4,
                                     title = "Visibility",
                                     status = "warning",
                                     solidHeader = TRUE,
                                     span(textOutput("visibility"), id = "visibility")
                                   ),

                                   box(width = 4,
                                       title = "Wind Speed",
                                       status = "primary",
                                       solidHeader = TRUE,
                                       span(textOutput("wind_speed"), id = "wind_speed")
                                   ),

                                   box(width = 4,
                                       title = "Air Pressure",
                                       status = "info",
                                       solidHeader = TRUE,
                                       span(textOutput("pressure"), id = "pressure")
                                   )

                                 )
                             ),
                             div(class = "content",
                                 fluidRow(

                                   box(
                                     title = "Map",
                                     width = "7",
                                     height = "477px",
                                     leafletOutput("map", height = "400px")
                                   )
                                 )

                             )
                           ),
                  )
              ),
      ),
      tabItem(tabName = "forecast",
              fluidRow(
                div(class = 'tab-content', style = "margin-left: 35px;",
                  h1(textOutput("city2")),

                  div(class='form-group shiny-input-container',
                        selectizeInput(
                          label = "Features:",
                          inputId = "feature",
                          choices = c("temp", "feels_like", "temp_min", "temp_max", "pressure",
                                      "sea_level", "grnd_level", "humidity", "speed", "deg", "gust"),
                          selected = "temp",
                          options = list(
                            plugins = list('selectize-plugin-a11y')
                          )

                      ),
                    ),
                  div(class='col-sm-6',
                    plotlyOutput("weatherPlot")
                  )
                )

              )
      )
    )
  )
  )
)
