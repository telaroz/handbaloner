
<!-- README.md is generated from README.Rmd. Please edit that file -->

# handbaloner

-   Documentación en [español](README.es.md) <!-- badges: start -->
    <!-- badges: end -->

The `handbaloner` packages has useful function for the visualization of
handball data.

## Package installation

The development version can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("telaroz/handbaloner")
```

## Court visualization examples

In this example, we can draw a basic court.

``` r
library(handbaloner)

court()
```

<img src="man/figures/README-basic example-1.png" width="100%" />

Podemos cambiar los colores, rotar verticalmente y en espejo con sus
parámetros.

We can change the colours, rotate vertically and mirror the court with
the functions’ parameters

``` r
court(vertical = TRUE, flip = TRUE, court_color = "orange", 
      area_color = "#3431A2", lines_color = "black")
```

<img src="man/figures/README-example with colours-1.png" width="100%" />

As the plots are generated with ggplot, we can describe the colourse
with their HEX code, rgb, number or by its name in english; see: [use of
colours in ggplot2](https://r-graph-gallery.com/ggplot2-color.html)

We can also draw half a court

``` r
half_court(vertical = TRUE, court_color = colors()[36], 
      area_color = rgb(red = 0.2, green = 0.4, blue = 0.6), 
      lines_color = "yellow")
```

<img src="man/figures/README-half court example-1.png" width="100%" />

Another useful function is `distance_to_goal` which measures the
distance from a point of the field to its closest goal, given some
coordinates (\[-40, 40\] in the x axis and \[-20, 20\] in the y axis):

``` r
distance_to_goal(c(10, 3))
#> [1] 10.11187
```

Also, as this is a ggplot, we can add some additional layers. For
example, let’s generate a `data.frame` with some coordinates of shots
and whether they were goals or not. We will add the distance to goal as
a column and plot in green and red if the shots were goal or not.

``` r
tiros <- dplyr::tibble(x = c(-13, -12, 11, -11, 9.5),
                       y = c(2, 5, -3, -1, 0),
                       gol = c(1, 0, 1, 1, 0))

dplyr::mutate(tiros, distance_to_goal = purrr::map2_dbl(x, y, ~ distance_to_goal(c(.x, .y))))
#> # A tibble: 5 x 4
#>       x     y   gol distance_to_goal
#>   <dbl> <dbl> <dbl>            <dbl>
#> 1 -13       2     1             7.02
#> 2 -12       5     0             8.73
#> 3  11      -3     1             9.12
#> 4 -11      -1     1             9   
#> 5   9.5     0     0            10.5
```

``` r
court() +
  ggplot2::geom_point(data = tiros, ggplot2::aes(x, y),
                      color = ifelse(tiros$gol == 1, 'Green', 'Red'),
                      size = 4)
```

<img src="man/figures/README-court with shots-1.png" width="100%" />
