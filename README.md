
<!-- README.md is generated from README.Rmd. Please edit that file -->

# handbaloner

<!-- badges: start -->
<!-- badges: end -->

El paquete `handbaloner` contiene funciones útiles para la visualización
de datos de balonamno.

## Instalación del paquete

La versión de desarrollo se puede instalar desde
[GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("telaroz/handbaloner")
```

## Ejemplos de visualización de campo

En este ejemplo, podemos ver cómo dibujamos un campo básico.

``` r
library(handbaloner)

court()
```

<img src="man/figures/README-ejemplo basico-1.png" width="100%" />

Podemos cambiar los colores, rotar verticalmente y en espejo con sus
parámetros.

``` r
court(vertical = TRUE, flip = TRUE, court_color = "orange", 
      area_color = "#3431A2", lines_color = "black")
```

<img src="man/figures/README-ejemplo con colores-1.png" width="100%" />

Ya que los gráficos están hechos en ggplot, la manera de describir los
colores puede ser en código HEX, rgb, número o por su nombre en inglés;
ver [uso de colores en
ggplot2](https://r-graph-gallery.com/ggplot2-color.html)

Podemos igualmente dibujar la mitad de un campo.

``` r
half_court(vertical = TRUE, court_color = colors()[36], 
      area_color = rgb(red = 0.2, green = 0.4, blue = 0.6), 
      lines_color = "yellow")
```

<img src="man/figures/README-ejemplo medio campo-1.png" width="100%" />

Otra función útil es `distance_to_goal` que mide la distancia de un
punto del campo al marco más cercano, según sus coordenadas (\[-40, 40\]
en el eje x y \[-20, 20\] en el eje y):

``` r
distance_to_goal(c(10, 3))
#> [1] 10.11187
```

Además, ya que este gráfico es un ggplot, podemos seguir agregando más
capas encima. Por ejemplo, generemos un `data.frame` con coordenadas de
ciertos tiros y si hubo gol o no. A este `data.frame` le agregaremos
además la distancia a gol y graficaremos con puntos en color rojo y
verde si fueron gol o no.

``` r
tiros <- dplyr::tibble(x = c(-13, -12, 11, -11, 9.5),
                       y = c(2, 5, -3, -1, 0),
                       gol = c(1, 0, 1, 1, 0))

dplyr::mutate(tiros, distancia_a_gol = purrr::map2_dbl(x, y, ~ distance_to_goal(c(.x, .y))))
#> # A tibble: 5 x 4
#>       x     y   gol distancia_a_gol
#>   <dbl> <dbl> <dbl>           <dbl>
#> 1 -13       2     1            7.02
#> 2 -12       5     0            8.73
#> 3  11      -3     1            9.12
#> 4 -11      -1     1            9   
#> 5   9.5     0     0           10.5
```

``` r
court() +
  ggplot2::geom_point(data = tiros, ggplot2::aes(x, y),
                      color = ifelse(tiros$gol == 1, 'Green', 'Red'),
                      size = 4)
```

<img src="man/figures/README-campo con tiros-1.png" width="100%" />
