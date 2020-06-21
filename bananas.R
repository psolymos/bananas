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
  get(col_square[4]), get(col_square[5]), get(col_square[6])
))

img <-image_read("images/example00.png")

ii <- image_map(img, simple_cols)

image_animate(c(img, ii), fps = 1)

## see other part of script for quantifying colors
