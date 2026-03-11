library(shiny)
library(shinyWidgets)
library(bslib)
library(dplyr)
library(jsonlite)
library(leaflet)

url <- "https://opendata.vancouver.ca/api/explore/v2.1/catalog/datasets/free-and-low-cost-food-programs/records?limit=100"

df <- fromJSON(url)$results |>
  as.data.frame()

meal_cost_choices <- c("All", sort(unique(na.omit(df$meal_cost))))
area_choices <- sort(unique(na.omit(df$local_areas)))

ui <- page_sidebar(
  
  sidebar = sidebar(
    title = "Vancouver Food Programs",

    selectInput(
      "meal_cost",
      "Meal cost",
      choices = meal_cost_choices,
      selected = "All"
    ),
    
  ),
  
  layout_column_wrap(
    
    value_box(
      "Total Locations",
      textOutput("total_locations")
    ),
    
    value_box(
      "Free Programs (%)",
      textOutput("free_prop")
    ),
    
    value_box(
      "Accessibility (%)",
      textOutput("accessibility_prop")
    )
    
  ),
  
  card(
    full_screen = TRUE,
    card_header("Location Map"),
    leafletOutput("map", height = "600px")
  )
  
)

server <- function(input, output, session) {
  
  filtered_df <- reactive({
    dff <- df %>%
      filter(!is.na(latitude), !is.na(longitude))
    
    if (input$meal_cost != "All") {
      dff <- dff %>%
        filter(meal_cost == input$meal_cost)
    }
    dff
  })
  
  output$total_locations <- renderText({
    nrow(filtered_df())
  })
  
  output$free_prop <- renderText({
    dff <- filtered_df()
    if (nrow(dff) == 0) return("0%")
    prop <- mean(tolower(dff$meal_cost) == "free")
    paste0(round(prop * 100, 1), "%")
  })
  
  output$accessibility_prop <- renderText({
    dff <- filtered_df()
    if (nrow(dff) == 0) return("0%")
    prop <- mean(tolower(dff$wheelchair_accessible) == "yes")
    paste0(round(prop * 100, 1), "%")
  })

  output$map <- renderLeaflet({
    dff <- filtered_df()
    leaflet(dff) %>%
      addTiles() %>%
      setView(lng = -123.1207, lat = 49.2827, zoom = 12) %>%
      addMarkers(
        lng = ~longitude,
        lat = ~latitude,
        popup = ~program_name
      )
    
  })
  
}

shinyApp(ui, server)