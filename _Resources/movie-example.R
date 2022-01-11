library(gganimate)
library(Zcalc)
# function to plot a single frame
one_frame <- function(n=100) {
  P1 <- slice_plot(sin(2*pi*x/10) ~ x, domain(x=c(0,!!n))) %>%
    gf_lims(x=c(0,100), y=c(-1,1))

  P2 <- slice_plot(cos(2*pi*x/10) ~ x, domain(x=c(0,!!n))) %>%
    gf_lims(x=c(0,100), y=c(-1,1))

  gridExtra::grid.arrange(P1, P2, nrow=2)
}


animation::saveGIF({
  for (k in c(1:50, seq(51,100, by=2))) {
    print(one_frame(k))
  }
}, movie.name = "foo.gif")

system("convert -delay 1x30 foo.gif movie.gif")

