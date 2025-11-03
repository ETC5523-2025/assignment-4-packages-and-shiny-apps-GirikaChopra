my_first_function <- function() {
  print("Hello World")
}



#' My First Plot
#' Plots a simple `ggplot2` boxplot of the `rivers_data` dataset,
#' with Site on the x-axis and Nitrate on the y-axis.
#' @returns
#' A `ggplot2` object containing the plot.
#'
#' @description
#' This function visualises nitrate concentration differences between
#' sampling sites in the synthetic `rivers_data` dataset. It uses a clean minimal theme and returns the ggplot object so it can be
#' further customised.
#'
#' @examples
#' devtools::load_all()
#' my_first_plot()
#' @export
#' @importFrom ggplot2 ggplot aes geom_boxplot labs theme_minimal
#'
my_first_plot <- function() {
  df <- rivers_data
  p_box <- ggplot2::ggplot(df, ggplot2::aes(Site, Nitrate, fill = Site)) +
  ggplot2::geom_boxplot(outlier.alpha = 0.2) +
  ggplot2::labs(x = NULL, y = "Nitrate (µmol/L)", title = "Nitrate by Site") +
  ggplot2::theme_minimal()
p_box
}
