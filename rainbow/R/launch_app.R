#' Launch the rainbow Shiny app
#'
#' This function launches the interactive Shiny app included in the package.
#' The app allows users to explore nitrate concentration by site.
#'
#' @returns Starts the Shiny application
#' @export
#'
#' @examples
#' # rainbow::launch_app()
launch_app <- function() {
  app_dir <- system.file("app", package = "rainbow", mustWork = TRUE)
  shiny::runApp(app_dir, display.mode = "normal")
  shiny::shinyAppDir(app_dir)
}



