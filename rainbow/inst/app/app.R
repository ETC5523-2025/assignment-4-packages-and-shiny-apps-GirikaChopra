
ui <- shiny::fluidPage(
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::h4("Choose sites"),
      shiny::p(
        "Use the checkboxes below to select which river sites to include ",
        "in the analysis. The plot and summary table will update automatically."
      ),
      shiny::checkboxGroupInput(
        "sites", "Select sites:",
        choices = unique(rainbow::rivers_data$Site),
        selected = unique(rainbow::rivers_data$Site)
      )
    ),
    shiny::mainPanel(
      shiny::plotOutput("nitrate_plot"),
      shiny::tableOutput("summary_tbl")
    )
  )
)

server <- function(input, output, session) {
  filtered <- shiny::reactive({
    subset(rainbow::rivers_data, Site %in% input$sites)
  })

  output$nitrate_plot <- shiny::renderPlot({
    ggplot2::ggplot(filtered(), ggplot2::aes(Site, Nitrate, fill = Site)) +
      ggplot2::geom_boxplot(outlier.alpha = 0.2) +
      ggplot2::labs(y = "Nitrate (µmol/L)", title = "Nitrate by Site") +
      ggplot2::theme_minimal()
  })

  output$summary_tbl <- shiny::renderTable({
    dplyr::summarise(
      dplyr::group_by(filtered(), Site),
      Mean = mean(Nitrate, na.rm = TRUE),
      SD = sd(Nitrate, na.rm = TRUE)
    )
  })
}

#running interative
if (interactive()) shiny::shinyApp(ui, server)

