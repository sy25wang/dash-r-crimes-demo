library(dash)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(dplyr)
library(purrr)

app <- Dash$new()

crime <- read.csv("data/crime.csv")
data <- crime |> group_by(TIME, YEAR, Neighborhood) |> count(HOUR) 

feature_mapping <- function(label, value) {
  list(label = label, value = value)
}

neighborhoods <- unique(data$Neighborhood)

feature_labels <- neighborhoods[-1]
feature_values <- neighborhoods[-1]

app$layout(
  dbcContainer(
    list(
      dccGraph(id='p'),
      dccDropdown(
        id = "neighborhood-dropdown",
        options = purrr::map2(feature_labels, feature_values, feature_mapping),
        value = 'Kitsilano')
    )
  )
)


# # Add plot
app$callback(
  output('p', 'figure'),
  list(input('neighborhood-dropdown', 'value')),
  function(neighborhood) {
    df <- data |> 
      filter(Neighborhood == neighborhood)
    p <- ggplot(df, aes(x=YEAR, n, color=TIME)) + geom_line(stat = 'summary', fun = mean)
    ggplotly(p)
  }
)

app$run_server(debug = T)

