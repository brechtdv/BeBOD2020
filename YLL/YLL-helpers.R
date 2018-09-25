### BeBOD / YEARS OF LIFE LOST
### helper functions
### 24/09/2018

## residual life expectancy

## .. WHO/GHE standard life expectancy table
WHO <-
data.frame(age = c(0, 1, 5 * 1:19),
           LE = c(91.94, 91.00, 87.02, 82.03, 77.04, 72.06, 67.08,
                  62.11, 57.15, 52.20, 47.27, 42.36, 37.49, 32.65,
                  27.86, 23.15, 18.62, 14.41, 10.70,  7.60,  5.13))

## .. GBD standard life expectancy table
GBD <-
data.frame(age = c(0, 1, 5 * 1:22),
           LE = c(86.6, 85.8, 81.8, 76.8, 71.9, 66.9, 62.0, 57.0,
                  52.1, 47.2, 42.4, 37.6, 32.9, 28.3, 23.8, 19.4,
                  15.3, 11.5,  8.2,  5.5,  3.7,  2.6,  1.6,  1.4))

## .. interpolate life expectancy table
rle <-
function(x) {
  approx(GBD$age, GBD$LE, x, rule = 1:2)$y
}

## top causes
top <-
function(m, y, z, n) {
  x <- data.frame(Freq = tapply(m[[z]], m[[z]], length),
                  YLL = tapply(m$YLL, m[[z]], sum, na.rm = TRUE))
  out <- head(x[order(x[[y]], decreasing = TRUE), ], n)
  paste0(substr(rownames(out), 0, 30), " (", out[[y]], ")")
}

## slopegraph
slopegraph <-
function(tab) {
  df <-
  data.frame(Region = rep(c("BR", "FL", "WA"), each = 20),
             Label = c(tab),
             Order = rep(1:20, 3))
  df$ICD <- gsub(" \\(.*", "", df$Label)


  ggplot(df, aes(x = Region, y = 21-Order, group = ICD)) +
    geom_line(aes(colour = ICD)) +
    geom_label(aes(label = Order, colour = ICD)) +
    geom_text(data = subset(df, Region == "BR"),
              aes(label = Label),
              hjust = 1,
              nudge_x = -0.15) +
    geom_text(data = subset(df, Region == "WA"),
              aes(label = Label),
              hjust = 0,
              nudge_x = 0.15) +
    scale_y_discrete(NULL) +
    scale_x_discrete(NULL, position = "top", expand = c(2, 0)) +
    theme_minimal() +
    theme(panel.grid = element_blank()) +
    theme(axis.text.y = element_blank()) +
    theme(legend.position = "none")
}

