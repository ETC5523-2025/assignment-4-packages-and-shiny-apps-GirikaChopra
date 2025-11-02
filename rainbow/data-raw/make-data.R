# data-raw/make-data.R
set.seed(2626)

sites <- c("Arikaree River","Caribou Creek","Lewis Run")
n_by_site <- c(35, 35, 35)

params <- tibble::tibble(
  Site = sites,
  mean_temp = c(15, 4, 13),   sd_temp = c(4, 2, 3),
  mean_do   = c(8, 10, 9),    sd_do   = c(1.2, 1.0, 1.0),
  mean_cond = c(520, 100, 600), sd_cond = c(60, 30, 70),
  mean_turb = c(6, 12, 15),
  mean_elev = c(1100, 260, 240), sd_elev = c(20, 20, 15),
  mean_no3  = c(5, 2, 15),    sd_no3  = c(2, 0.6, 4)
)

rivers_data <- purrr::pmap_dfr(
  list(params$Site, n_by_site),
  function(s, n){
    mu <- dplyr::filter(params, Site == s)
    data.frame(
      Site            = s,
      Temperature     = stats::rnorm(n, mu$mean_temp, mu$sd_temp),
      DissolvedOxygen = stats::rnorm(n, mu$mean_do,  mu$sd_do),
      Conductance     = stats::rnorm(n, mu$mean_cond, mu$sd_cond),
      Turbidity       = stats::rlnorm(n, log(mu$mean_turb), 0.5),
      Elevation       = stats::rnorm(n, mu$mean_elev, mu$sd_elev),
      Nitrate         = stats::rnorm(n, mu$mean_no3,  mu$sd_no3)
    )
  }
)

rivers_data$Site <- factor(rivers_data$Site, levels = sites)

usethis::use_data(rivers_data, overwrite = TRUE)

my_first_plot <- function() {
  p_box <- ggplot2::ggplot(df, ggplot2::aes(Site, Nitrate, fill = Site)) +
    ggplot2::geom_boxplot(outlier.alpha = 0.2) +
    ggplot2::labs(x = NULL, y = "Nitrate (µmol/L)", title = "Nitrate by Site") +
    ggplot2::theme_minimal()
  p_box
}

my_first_plot()

