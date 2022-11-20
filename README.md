# bananas
> Data set of ripening bananas

Color information about ripening bananas over 21 days.

[![Build
status](https://github.com/psolymos/bananas/actions/workflows/check.yml/badge.svg)](https://github.com/psolymos/bananas/actions)

``` r
install.packages("bananas", repos = "https://psolymos.r-universe.dev")

remotes::install_github("psolymos/bananas")
```

A sequence of images were taken of 11 banana fruits over 21 days:

![](26_B.gif)

After masking, pixels were classified according to this color palette:

![](palette.png)

Color changes over time:

![](colors.png)

Change in visible surface are (volume) over time:

![](volume.png)

[MIT License](./LICENSE) © 2022 Peter Solymos
