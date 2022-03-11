library(dash)
library(ggplot2)
library(plotly)

app <- Dash$new()

crime <- read.csv("data/crime.csv")
crime <- crime |> group_by(TIME, YEAR, Neighborhood) |> count(HOUR)

p <- ggplot(crime, aes(x=YEAR, n, color=TIME)) + geom_line(stat = 'summary', fun = mean)

app$layout(dccGraph(figure=ggplotly(p)))

app$run_server(debug = T)