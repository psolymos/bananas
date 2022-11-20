#' ---
#' title: Bananas Palette
#' output: html_document
#' ---
#'
#' The colors of the bananas were determined with GIMP.
#' We evaluate the color palette using the {colorspace} package.
library(colorspace)
source("00-constants.R")
data.frame(bcol)
demoplot(bcol[-1L], "bar")
demoplot(bcol[-1L], "heatmap")
hclplot(bcol[-1L])
specplot(bcol[-1L], type = "o")
#'
#' We follow https://www.rostrum.blog/2018/11/25/art-of-the-possible/
#' to create an image with the palette using the {magick} package
library(magick)
for (i in seq_along(bcol)) {
  fig_name <- paste0(names(bcol)[i], "_square")  # create object name
  assign(
    fig_name,  # set name
    image_graph(width = 100, height = 100, res = 300)  # create magick object
  )
  par(mar = rep(0, 4))  # set plot margins
  plot.new()  # new graphics frame
  rect(0, 0, 1, 1, col = bcol[i], border = bcol[i])  # build rectangle
  assign(fig_name, magick::image_crop(get(fig_name), "50x50+10+10")) # crop
  dev.off()  # shut down plotting device
  rm(i, fig_name)  # clear up
}
col_square <- paste0(names(bcol), "_square")
#' Combine {magick} objects (coloured squares)
bananas_pal <- image_append(c(
  get(col_square[1]), get(col_square[2]), get(col_square[3]),
  get(col_square[4]), get(col_square[5]), get(col_square[6]),
  get(col_square[7]), get(col_square[8]), get(col_square[9]),
  get(col_square[10])
))
#' This is the palette that we'll use as am image map later
bananas_pal
if (interactive())
  image_write(bananas_pal, "palette.png")
