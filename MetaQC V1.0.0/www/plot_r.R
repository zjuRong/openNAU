
plot_error <- function() {
  ggplot(tgc, aes(x = dose, y = len, colour = supp)) +
    geom_errorbar(aes(ymin = len - se, ymax = len + se), width = .1) +
    geom_line() +
    geom_point()
}
