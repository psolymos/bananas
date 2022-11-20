x <- read.csv("data-raw/data-colors.csv", stringsAsFactors = TRUE)


bd <- data.frame(
  id=gsub("\\.png", "", as.character(x$file)),
  #date=paste(x$date, gsub("-", ":", x$time), "MDT"),
  fruit=paste0("fruit_", x$fruit),
  ripeness=sapply(x$ripeness, function(z) switch(as.character(z),
                  "U"="Under",
                  "R"="Ripe",
                  "V"="Very",
                  "O"="Over")),
  ripe=ifelse(x$ripeness == "R", 1L, 0L),
  treatment=sapply(x$group, function(z) switch(as.character(z),
                  "B"="Room",
                  "F"="Fridge")),
  day=x$day,
  training=x$training,
  x[,c("w", "g1", "g2", "yg", "y1", "y2", "yb", "b1", "b2", "b3")],
  p_green = x$g1 + x$g2,
  p_yellow = x$yg + x$y1 + x$y2 + x$yb,
  p_brown = x$b1 + x$b2 + x$b3)
bd$green <- bd$p_green / (bd$p_green+bd$p_brown+bd$p_yellow)
bd$yellow <- bd$p_yellow / (bd$p_green+bd$p_brown+bd$p_yellow)
bd$brown <- bd$p_brown / (bd$p_green+bd$p_brown+bd$p_yellow)
bd$ripeness <- factor(bd$ripeness, c("Under", "Ripe", "Very", "Over"))
bd$treatment <- as.factor(bd$treatment)

# z <- bd[bd$treatment == "Room",
#   c("fruit", "ripeness", "ripe", "day", "green", "yellow", "brown")]
# z$green <- round(z$green, 5)
# z$yellow <- round(z$yellow, 5)
# z$brown <- round(z$brown, 5)
# summary(z$green + z$brown + z$yellow)
# write.csv(z, row.names=FALSE, file="bananas.csv")

z <- bd[
  c("fruit", "ripeness", "ripe", "treatment", "day", "green", "yellow", "brown")]

bananas <- z
save(bananas, file="data/bananas.rda")

source("data-raw/00-constants.R")
banana_colors <- bcol
save(banana_colors, file="data/banana_colors.rda")

