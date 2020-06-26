library(magick)
#https://www.rostrum.blog/2018/11/25/art-of-the-possible/

bcol <- c(w ="#ffffff",
  g1="#576a26",
  g2="#919e39",
  yg="#b1ab3e",
  y1="#d6c350",
  y2="#eece5a",
  yb="#d1a123",
  b1="#966521",
  b2="#5c361f",
  b3="#261d19")
cols_vec <- setNames(bcol, names(bcol))


## CSS
#background-image: linear-gradient(to right top, #576a26, #6f7d2e, #8a9037, #a6a241, #c4b54b, #c5ab4a, #c5a24a, #c3994b, #9e7540, #775435, #4e3728, #261d19);

library(colorspace)

cc <- bcol[-1]
cc <- hcl.colors(9, "viridis")
cc <- rev(bc[c(5:1)])
cc <- rev(bc[c(5:9)])
colorspace::demoplot(cc, "bar")
demoplot(cc, "heatmap")
hclplot(cc)
specplot(cc, type = "o")


for (i in seq_along(cols_vec)) {
  fig_name <- paste0(names(cols_vec)[i], "_square")  # create object name
  assign(
    fig_name,  # set name
    image_graph(width = 100, height = 100, res = 300)  # create magick object
  )
  par(mar = rep(0, 4))  # set plot margins
  plot.new()  # new graphics frame
  rect(0, 0, 1, 1, col = cols_vec[i], border = cols_vec[i])  # build rectangle
  assign(fig_name, magick::image_crop(get(fig_name), "50x50+10+10")) # crop
  dev.off()  # shut down plotting device
  rm(i, fig_name)  # clear up
}

# Generate names of the coloured square objects
col_square <- paste0(names(cols_vec), "_square")

# Combine magick objects (coloured squares)
simple_cols <- image_append(c(
  get(col_square[1]), get(col_square[2]), get(col_square[3]),
  get(col_square[4]), get(col_square[5]), get(col_square[6]),
  get(col_square[7]), get(col_square[8]), get(col_square[9]),
  get(col_square[10])
))

## this is what we use as map
simple_cols



## all images
bi <- list.files("images")

d <- data.frame(do.call(rbind, strsplit(gsub("\\.png", "", bi), "_")))
dimnames(d) <- list(bi, c("fruit", "group", "date", "time", "ripeness"))
d$date <- as.Date(d$date)

d$training <- d$fruit != "26" & d$date %in% as.Date(c(
    "2020-05-28", "2020-05-30", "2020-06-01",
    "2020-06-03", "2020-06-05", "2020-06-07",
    "2020-06-09", "2020-06-11", "2020-06-13",
    "2020-06-15", "2020-06-17"))
d$day <- as.integer(d$date - min(d$date))
d$file <- rownames(d)
tmp <- lapply(strsplit(as.character(d$time), "-"), as.numeric)
d$hour <- round(d$day*24 + sapply(tmp, "[[", 1) + sapply(tmp, "[[", 2)/60, 1)
d$hour <- d$hour - min(d$hour)

count_colors <- function(image) {
  data <- image_data(image) %>%
    apply(2:3, paste, collapse = "") %>%
    as.vector %>% table() %>%  as.data.frame() %>%
    setNames(c("hex", "freq"))
  data$hex <- paste("#", data$hex, sep="")
  return(data)
}

pcolor <- function(f, size="300x200") {
  tmp <- image_read(f) %>%
    image_resize(size) %>%
    image_map(simple_cols) %>%
    count_colors()
  p <- structure(tmp$freq / sum(tmp$freq),
    names=names(bcol)[match(tmp$hex, paste0(bcol, "ff"))])
  out <- numeric(length(bcol))
  names(out) <- names(bcol)
  out[names(p)] <- p
  out
}

M <- t(pbapply::pbsapply(file.path("images", bi), pcolor))
M <- data.frame(d, M)

#write.csv(M, row.names=FALSE, file="data-colors.csv")



x <- read.csv("data-colors.csv")
summary(x)
x$gr <- x$g1 + x$g2
x$yl <- x$yg + x$y1 + x$y2 + x$yb
x$br <- x$b1 + x$b2 + x$b3
x$gyb <- 1 - x$w
xstart <- x[x$day==0,]
x$a0 <- x$gyb / xstart$gyb[match(x$fruit, xstart$fruit)]
levels(x$group) <- c("Room", "Fridge")


xt <- x[x$training,]

xt1 <- xt
xt1$color <- "green"
xt1$prop <- 100 * xt1$gr / xt1$gyb

xt2 <- xt
xt2$color <- "yellow"
xt2$prop <- 100 * xt2$yl / xt2$gyb

xt3 <- xt
xt3$color <- "brown"
xt3$prop <- 100 * xt3$br / xt3$gyb

xt0 <- rbind(xt1, xt2, xt3)

library(mgcv)
library(ggplot2)

cols <- bcol[c(2,6,9)]
names(cols) <- c("green", "yellow", "brown")
p <- ggplot(xt0, aes(x=jitter(day, 0.5), y=prop, group=color, color=color)) +
  geom_point() +
  geom_smooth() +
  facet_grid(rows=vars(group)) +
  scale_color_manual(values=cols, aesthetics = c("colour", "fill")) +
  #theme_bananas() +
  labs(title = "Colors",
        subtitle = "of the bananas",
        caption = "Over time.",
        x = "Days",
        y = "% of surface area")

p <- ggplot(xt, aes(x=jitter(day, 0.5), y=100*a0, group=group, color=group)) +
  geom_point() +
  geom_smooth() +
  scale_color_manual(values=unname(cols)[c(1,2)],
                     aesthetics = c("colour", "fill")) +
  #theme_bananas() +
  labs(title = "Area",
        subtitle = "of the bananas",
        caption = "Over time.",
        x = "Days",
        y = "% of surface area")


m <- gam(w ~ s(day) + group, data=xt)


with(d, table(day, fruit, training))
## establish colors
i <- c("22_B_2020-05-28.png", "22_B_2020-05-30.png", "22_B_2020-06-01.png",
  "22_B_2020-06-07.png", "22_B_2020-06-13.png", "22_B_2020-06-17.png")
img <- image_read(file.path("images", i))
img <- image_resize(img, "300x200")
img <- image_append(c(img[1], img[2], img[3], img[4], img[5], img[6]), stack=TRUE)

imgq <- image_quantize(img, 10)

i <- ii[1]
img <-image_read(file.path("images", i))

imq <- image_quantize(img, 20)
image_write(img, "col.png")

vv <- image_map(img, simple_cols)





z <- count_colors(vv)
z$prop <- z$freq / sum(z$freq)
z

iv <- ii[d$fruit == "22"]
val <- list()
for (i in iv) {
  tmp <- image_read(file.path("images", i)) %>%
    image_resize("300x200") %>%
    image_map(simple_cols) %>%
    count_colors()
  val[[i]] <- structure(tmp$freq / sum(tmp$freq), names=tmp$hex)
}
#ccc2 <- sort(unique(unlist(lapply(val, names))))
M <- matrix(0, length(iv), length(ccc))
dimnames(M) <- list(iv, paste0(ccc, "ff"))
for (i in iv) {
  M[i, names(val[[i]])] <- val[[i]]
}
colnames(M) <- names(ccc)

z <- round(M[,-1]*100/rowSums(M[,-1]))
matplot(z,lty=1,type="l", col=ccc[-1], lwd=3, xlab="Days", ylab="% of color")

z <- cbind(g=rowSums(M[,c("g1", "g2")]),
           y=rowSums(M[,c("yg", "y1", "y2", "yb")]),
           b=rowSums(M[,c("b1", "b2", "b3")]))
z <- z/rowSums(z)
matplot(z, lty=1,type="l", col=ccc[c(3,6,8)], lwd=3)

z2 <- t(apply(z, 1, cumsum))
matplot(z2, lty=1,type="l", col=ccc[c(3,6,8)], lwd=3)


theme_bananas <- function() {

  #showtext::showtext_auto()

  base <- 12
  double_base <- base * 2
  half_base <- base / 2

  ggplot2::theme(

    # Global text formating
    #text = ggplot2::element_text(family = font),

    # Title format:
    plot.title = ggplot2::element_text(size = ggplot2::rel(1.5),
                              face = "bold",
                              color = "#5c361f",
                              lineheight = 1.2),
    # Subtitle format:
    plot.subtitle = ggplot2::element_text(size = ggplot2::rel(1.1),
                                 color = "#5c361f",
                                 lineheight = 1.2,
                                 margin = ggplot2::margin(half_base, 0, base, 0)),
    # Caption format:
    plot.caption = ggplot2::element_text(size = ggplot2::rel(0.7),
                                color = "#576a26",
                                lineheight = 1.2,
                                hjust = 0,
                                margin = ggplot2::margin(base, 0, 0, 0)),

    # Legend format
    legend.position = "right",
    legend.text.align = 0,
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_text(color = "#242222"),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(color = "#242222"),

    # Axis format
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = base)),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = base)),
    axis.text = ggplot2::element_text(size = ggplot2::rel(0.8)),
    axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = half_base)),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = half_base)),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),

    # Grid lines
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_line(color = "grey90"),
    #panel.grid.major.x = ggplot2::element_blank(),

    # Blank background
    panel.background = ggplot2::element_blank(),

    # Strip background
    strip.background = ggplot2::element_rect(fill = "white"),
    strip.text = ggplot2::element_text(size = ggplot2::rel(0.8), hjust = 0)
  )

}
