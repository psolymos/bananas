library(magick)
#https://www.rostrum.blog/2018/11/25/art-of-the-possible/

#img <-image_read("images/example01.png")
#img <- image_background(img, "#ffffff", flatten = TRUE)


cols_vec <- setNames(
  c("#000000", "#0000ff", "#008000", "#ff0000", "#ffffff", "#ffff00"),
  c("black", "blue", "green", "red", "white", "yellow")
)

#cols_vec <- setNames(
#  c("#221a0f", "#828c2c", "#ffffff", "#eccd58"),
#  c("brown",   "green",   "white",   "yellow")
#)

ccc <- c(w ="#ffffff",
  g1="#576a26",
  g2="#919e39",
  yg="#b1ab3e",
  y1="#d6c350",
  y2="#eece5a",
  yb="#d1a123",
  b1="#966521",
  b2="#5c361f",
  b3="#261d19")
cols_vec <- setNames(ccc, names(ccc))

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
simple_cols

img <-image_read("images/example00.png")

ii <- image_map(img, simple_cols)

image_animate(c(img, ii), fps = 1)

## see other part of script for quantifying colors



## all images
ii <- list.files("images")
d <- data.frame(do.call(rbind, strsplit(gsub("\\.png", "", ii), "_")))
dimnames(d) <- list(ii, c("fruit", "group", "day"))
d$day <- as.Date(d$day)
d$day2 <- d$day %in% as.Date(c("2020-05-28", "2020-05-30", "2020-06-01",
                       "2020-06-03", "2020-06-05", "2020-06-07",
                       "2020-06-09", "2020-06-11", "2020-06-13",
                       "2020-06-15", "2020-06-17"))
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




count_colors <- function(image) {
  data <- image_data(image) %>%
    apply(2:3, paste, collapse = "") %>%
    as.vector %>% table() %>%  as.data.frame() %>%
    setNames(c("hex", "freq"))
  data$hex <- paste("#", data$hex, sep="")
  return(data)
}

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
