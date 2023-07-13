#' Data Set of Ripening Bananas
#'
#' Color information about ripening bananas over 21 days.
#'
#' The data set contains these columns:
#'
#' * `fruit`: fruit ID (first digit refers to the bunch, second digit that individual fruit);
#' * `ripeness`: ripeness class (under ripe , ripe, very ripe, over ripe;
#' * `ripe`: 0/1 indicator (`ripeness == "ripe"`);
#' * `treatment`: Fridge or basement Room temperature, fruits were randomly assigned;
#' * `day`: days since the start of the study;
#' * `green`: proportion of pixels classified as green relative to the visible surface area;
#' * `yellow`: proportion of pixels classified as yellow relative to the visible surface area;
#' * `brown`: proportion of pixels classified as brown relative to the visible surface area.
#' 
#' The vector has the following colors:
#'
#' * `w`: white (`"#ffffff"`);
#' * `g1`: dark green (`"#576a26"`);
#' * `g2`: green (`"#919e39"`);
#' * `yg`: yellow-green (`"#b1ab3e"`);
#' * `y1`: yellow (`"#d6c350"`);
#' * `y2`: light yellow (`"#eece5a"`);
#' * `yb`: yellow-brown (`"#d1a123"`);
#' * `b1`: light brown (`"#966521"`);
#' * `b2`: brown (`"#5c361f"`);
#' * `b3`: dark brown (`"#261d19"`).
#' @examples 
#' head(bananas)
#' str(bananas)
#' summary(bananas)
#'
#' banana_colors
#'
#' x <- bananas[bananas$treatment == "Room",]
#'
#' plot(x = jitter(x$day, 0.5), y = x$green,
#'     col = banana_colors["g1"], pch = 19,
#'     xlab = "Days", ylab = "Proportion", ylim = c(0, 1))
#' points(x = jitter(x$day, 0.5), y = x$yellow,
#'     col = banana_colors["y2"], pch = 19)
#' points(x = jitter(x$day, 0.5), y = x$brown,
#'     col = banana_colors["b2"], pch = 19)
#' lines(lowess(x = x$day, y = x$green, f = 0.3), 
#'     col = banana_colors["g1"], lwd = 3)
#' lines(lowess(x = x$day, y = x$yellow, f = 0.3), 
#'     col = banana_colors["y2"], lwd = 3)
#' lines(lowess(x = x$day, y = x$brown, f = 0.3), 
#'     col = banana_colors["b2"], lwd = 3)
#'
#' @format A data frame with 220 rows and 19 columns for `bananas`. A character vector with 10 values for `banana_colors`.
#'
#' @docType package
#' @name bananas
#' @rdname banas
#' @aliases bananas bananas-package
NULL

#' @rdname banas
"bananas"


#' @rdname banas
"banana_colors"
