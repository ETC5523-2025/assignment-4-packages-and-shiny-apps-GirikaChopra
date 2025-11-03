
ui <- shiny::fluidPage(

  shiny::titlePanel("Rainbow: Nitrate Explorer"),

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::h4("Choose sites"),
      shiny::p(
        "Use the checkboxes below to select which river sites to include ",
        "in the analysis. The plot and summary table will update automatically."
      ),
      shiny::checkboxGroupInput(
        inputId = "sites",
        label   = "Select sites:",
        choices = unique(rainbow::rivers_data$Site),
        selected = unique(rainbow::rivers_data$Site)
      ),
      shiny::hr(),
      shiny::h4("Field descriptions"),
      shiny::tags$ul(
        shiny::tags$li(shiny::tags$strong("Site:"), " sampling location."),
        shiny::tags$li(shiny::tags$strong("Nitrate:"),
                       " nitrate concentration in µmol/L."),
        shiny::tags$li(shiny::tags$strong("Mean, SD:"),
                       " average and variability of nitrate for each site.")
      )
    ),

    shiny::mainPanel(
      shiny::h3("Nitrate concentrations by site"),
      shiny::p(
        "Each boxplot shows the distribution of nitrate concentrations at a site. ",
        "Higher boxes indicate higher typical nitrate levels. Points outside the ",
        "box show more extreme measurements."
      ),
      shiny::plotOutput("nitrate_plot"),
      shiny::hr(),
      shiny::h3("Summary statistics"),
      shiny::p(
        "This table reports the mean and standard deviation (SD) of nitrate for ",
        "the selected sites. Compare these values to see which rivers tend to ",
        "have higher and more variable nitrate concentrations."
      ),
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
      ggplot2::labs(
        x = NULL,
        y = "Nitrate (µmol/L)",
        title = "Nitrate by Site"
      ) +
      ggplot2::theme_minimal()
  })

  # Summary table: mean + SD by site
  output$summary_tbl <- shiny::renderTable({
    dplyr::summarise(
      dplyr::group_by(filtered(), Site),
      Mean = mean(Nitrate, na.rm = TRUE),
      SD   = sd(Nitrate,   na.rm = TRUE)
    )
  })
}


if (interactive()) {
  shiny::shinyApp(ui, server)
}
