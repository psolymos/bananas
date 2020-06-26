#' ---
#' title: Bananas Palette
#' output: html_document
#' ---
#'
#' We follow https://www.rostrum.blog/2018/11/25/art-of-the-possible/
#' to estimate the amount of different colors using the {magick} package.
#' We need the `palette.png` file that we created with `01-palette.R` script
library(magick)
source("00-constants.R")
data.frame(bcol)
#' This is the palette we use to map colors to, then count those mapped colors
bananas_pal <- image_read("palette.png")
bananas_pal
#'
#' List image names from the `/images` folder
bi <- list.files("images")
str(bi)
#' This function counts the individual colors
count_colors <- function(image) {
  data <- image_data(image) %>%
    apply(2:3, paste, collapse = "") %>%
    as.vector %>% table() %>%  as.data.frame() %>%
    setNames(c("hex", "freq"))
  data$hex <- paste("#", data$hex, sep="")
  return(data)
}
#' This function returns a vector of values that sum to 1
#' and the names match `bcol`.
#' Original image sizes (w x h): 1488 x 1141
#' We are resizing to 261 x 200
pcolor <- function(f, size="300x200") {
  tmp <- image_read(f) %>%
    image_resize(size) %>%
    image_map(bananas_pal) %>%
    count_colors()
  p <- structure(tmp$freq / sum(tmp$freq),
    names=names(bcol)[match(tmp$hex, paste0(bcol, "ff"))])
  out <- numeric(length(bcol))
  names(out) <- names(bcol)
  out[names(p)] <- p
  out
}
#'
#' Now let's estimate the amount of colors
est <- t(pbapply::pbsapply(file.path("images", bi), pcolor))
#'
#'
est <- data.frame(file=bi, est)
if (interactive())
  write.csv(est, row.names=FALSE, file="color-estimates.csv")
