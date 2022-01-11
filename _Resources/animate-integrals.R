# Test out an animation

library(Zcalc)

fraw <- rfun( ~ t, seed=9090)
f <- function(t) fraw(t-5)
F <- antiD(f(t) ~ t)
time <- seq(0, 10, by=1)
pointer <- arrow(angle = 30, length = unit(0.25, "inches"),
                 ends = "last", type = "open")

arrow_plot <- function(start, T, h=1.0) {
  fval <- f(T)
  Fnew <- makeFun(F(t) - F(start) ~ t, start=start)
  yrange <- extendrange(range(f(time)), f=0.1)
  Yrange <- extendrange(range(Fnew(time)), f=0.1)
  Segment <- tibble(
    tstart = T,
    tend =T+h,
    ystart = 0,
    yend = fval*h,
    fval = fval
  )

  P1 <- slice_plot(f(t) ~ t, domain(t=c(start,T))) %>%
    slice_plot(f(t) ~ t, domain(t = range(time)), alpha=0.25, size=2) %>%
    gf_segment(ystart + yend ~ tstart + tend,
               data = Segment, color="magenta", size=2,
               arrow = pointer) %>%
    gf_lims(x=range(time), y = yrange) %>%
    gf_text(I(mean(yrange*c(1.3, 0.7))) ~ 8, label="f", size=40, color="lightgray") %>%
    gf_hline(yintercept = ~ 0, color = "blue") %>%
    gf_point(fval ~ tstart, data = Segment, color="magenta", size=4) %>%
    gf_labs(y = "f(t)")
  SegmentF <- Segment %>% mutate(
    ystart = Fnew(T) + ystart,
    yend   = Fnew(T) + yend
  )
  P2 <- slice_plot(Fnew(t) ~ t, domain(t=c(start,T))) %>%
    gf_segment(ystart + yend ~ tstart + tend,
               data = SegmentF, color="magenta", size=2,
               arrow = pointer) %>%
    gf_hline(yintercept = ~ 0, color = "blue") %>%
    gf_text(I(mean(Yrange*c(1.3, 0.7))) ~ 8, label="F", size=40, color="lightgray") %>%
    gf_lims(x=range(time), y = Yrange) %>%
    gf_labs(y = "F(t)")

  ggpubr::ggarrange(P1, P2, nrow=2)
}

riemann_plot <- function(start, T, h=1.0) {
  fval <- f(T)
  Fnew <- makeFun(F(t) - F(start) ~ t, start=start)
  Bars <- Riemann_bars(f(t) ~ t, domain(t=c(start, T)), h=0.1)
  Last_bar <- Bars[nrow(Bars),]
  Last_bar$color <- barcolor <- ifelse(fval > 0, "magenta", "red")
  yrange <- extendrange(range(f(time)), f=0.1)
  Yrange <- extendrange(range(Fnew(time)), f=0.1)
  P1 <-
    gf_rect(ymin+ymax ~ xmin+xmax, data = Bars, fill= ~ color, color=NA) %>%
    gf_rect(ymin+ymax ~ xmin+xmax, data = Last_bar, fill= ~ color, color=NA) %>%
    slice_plot(f(t) ~ t, domain(t=range(time)), alpha = 0.75, size=2, inherit=FALSE) %>%
    gf_text(I(mean(yrange*c(1.3, 0.7))) ~ 8, label="f", size=40, color="lightgray") %>%
    gf_refine(scale_fill_identity())
  Segment <- tibble(
    tstart = T,
    tend =T+0.5,
    ystart = Fnew(T),
    yend = ystart + fval*0.5,
    fval = fval
  )
  P2 <- slice_plot(Fnew(t) ~ t, domain(t=c(start,T))) %>%
    gf_segment(ystart + yend ~ tstart + tend,
               data = Segment, color=barcolor, size=2,
               arrow = pointer) %>%
    gf_text(I(mean(Yrange*c(1.3, 0.7))) ~ 8, label="F", size=40, color="lightgray") %>%
    gf_lims(x=range(time), y = Yrange) %>%
    gf_labs(y = "F(t)")

  ggpubr::ggarrange(P1, P2, nrow=2)
}


saveGIF({

    for (T in seq(2.01, 10, by=0.1)) {
      # dev.hold()
      print(riemann_plot(2, T, h=0.5))
      #print(arrow_plot(2, T, h=0.5))

    }
  }, movie.name = "raw.gif"
)

# system("convert -delay 1x20 raw.gif area-plot.gif")

# system("convert -delay 1x20 raw.gif arrow-plot.gif")

# Then run this in the shell
# Change frame rate shell command
# convert -delay 1x30 raw.gif arrow-plot.gif

