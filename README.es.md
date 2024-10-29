
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

Además, la función `plot_paces` tiene como dependencia el paquete `ggflags` que
no se encuentra en CRAN. Para utilizar estar función, esa dependencia debe
estar instalada (no es necesaria para el resto de funciones del paquete)

``` r
install.packages("ggflags", repos = c(
  "https://jimjam-slam.r-universe.dev",
  "https://cloud.r-project.org"))
```
```

## Ejemplos de visualización de campo

En este ejemplo, podemos ver cómo dibujamos un campo básico.

``` r
library(handbaloner)

court()
```

<img src="man/figures/README-basic_example-1.png" width="100%" />

Podemos cambiar los colores, rotar verticalmente y en espejo con sus
parámetros.

``` r
court(vertical = TRUE, flip = TRUE, court_color = "orange", 
      area_color = "#3431A2", lines_color = "black")
```

<img src="man/figures/README-example_with_colours-1.png" width="100%" />

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

<img src="man/figures/README-half_court_example-1.png" width="100%" />

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

<img src="man/figures/README-court_with_shots-1.png" width="100%" />

## Ejemplos de visualización del marco

Con este ejemplo, dibujamos un marco de balonmano en sus dimensiones oficiales.

``` r
library(handbaloner)

draw_goal()
```

<img src="man/figures/README-basic_example_goal-1.png" width="70%" />

Cambiamos el color del marco. Por defecto es rojo

``` r
library(handbaloner)

draw_goal("blue")
```

<img src="man/figures/README-color_change-1.png" width="70%" />

Ahora, dibujemos algunos tiros, como hicimos con el campo completo

``` r
tiros_a_gol <- dplyr::tibble(x = c(-2, -1, 0.5, 0.7, 1.4),
                       y = c(0.2, 2, -0.5, 0.3, 0.9),
                       gol = c(0, 0, 1, 1, 1))

draw_goal() +
  ggplot2::geom_point(data = tiros_a_gol, ggplot2::aes(x, y),
                      color = ifelse(tiros_a_gol$gol == 1, 'Green', 'Red'),
                      size = 4)
```

<img src="man/figures/README-goal_with_shots-1.png" width="100%" />


## Generar Play by Play en formato tidy desde datos de IHF

Primero, se necesita descargar el archivo PDF con el PBP. Para esta tarea, se 
puede utilizar la función `scrape_from_ihf`. Se necesita el enlace de la 
información del partido y la carpeta a la cuál descargar el archivo.

Para el primer partido del mundial masculino del 2023, se puede descargar los 
PDFs de la siguiente forma:

``` r
scrape_from_ihf(link = "https://www.ihf.info/competitions/men/308/28th-ihf-men039s-world-championship-2023/101253/match-center/118895",
                folder = "pol_swe")
```

Ahora, con ayuda de `generate_tidy_pbp` se genera un `data.frame\` en formato 
tidy.

``` r
generate_tidy_pbp("pol_swe/02PBP.PDF")

#>      match_id   time numeric_time  half
#>         <num> <char>        <num> <num>
#>   1:        2   0:00            0     1
#>   2:        2   0:00            0     1
#>   3:        2   0:41           41     1
#>   4:        2   1:26           86     1
#>   5:        2   1:49          109     1
#>  ---                                   
#> 197:        2  58:46         3526     2
#> 198:        2  59:01         3541     2
#> 199:        2  59:33         3573     2
#> 200:        2  59:34         3574     2
#> 201:        2  59:47         3587     2
#>                                                             action number
#>                                                             <char> <char>
#>   1:                                           GARCIA F Goalkeeper     12
#>   2:                                 SIAVOSHISHAHENAYAT Goalkeeper     16
#>   3:                                FEUCHTMANN E Shot left 6m post     10
#>   4:                                FRELIJJ J 2-minutes suspension      9
#>   5: NOROUZINEZHAD Goal left 6m middle right (44 SADEGHI ASKARI A)      7
#>  ---                                                                     
#> 197:  SALINAS E Goal left 6m bottom left (4 FEUCHTMANN E), 68 km/h     11
#> 198:               BEHNAMNIA Mfor 16 SIAVOSHISHAHENAYAT Empty goal     24
#> 199:          BEHNAMNIA M Goal centre 6m bottom right (23 ORAEI M)     24
#> 200:          SIAVOSHISHAHENAYATfor 4 GHALANDARI M Goalkeeper back     16
#> 201:               SCARAMELLI L Shot right wing saved bottom right     28
#>        team goalkeeper opponent_goalkeeper assist_number goal_number
#>      <char>     <char>              <char>        <char>      <char>
#>   1:    CHI         12                  16          <NA>        <NA>
#>   2:    IRI         16                  12          <NA>        <NA>
#>   3:    CHI         12                  16          <NA>        <NA>
#>   4:    CHI         12                  16          <NA>        <NA>
#>   5:    IRI         16                  12            44           7
#>  ---                                                                
#> 197:    CHI         12                  16             4          11
#> 198:    IRI Empty goal                  12          <NA>        <NA>
#> 199:    IRI Empty goal                  12            23          24
#> 200:    IRI         16                  12          <NA>        <NA>
#> 201:    CHI         12                  16          <NA>        <NA>
#>      shot_number  goal shot_speed in_goal_position shot_position  post saved
#>           <char> <num>      <num>           <char>        <char> <num> <num>
#>   1:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   2:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   3:          10     0         NA             post       left 6m     1    NA
#>   4:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   5:        <NA>     1         NA     middle right       left 6m    NA    NA
#>  ---                                                                        
#> 197:        <NA>     1         68      bottom left       left 6m    NA    NA
#> 198:        <NA>     0         NA             <NA>          <NA>    NA    NA
#> 199:        <NA>     1         NA     bottom right     centre 6m    NA    NA
#> 200:        <NA>     0         NA             <NA>          <NA>    NA    NA
#> 201:          28     0         NA     bottom right    right wing    NA     1
#>      vertical_goal_position horizontal_goal_position causes_7m_number
#>                      <char>                   <char>           <char>
#>   1:                   <NA>                     <NA>             <NA>
#>   2:                   <NA>                     <NA>             <NA>
#>   3:                   <NA>                     <NA>             <NA>
#>   4:                   <NA>                     <NA>             <NA>
#>   5:                 middle                    right             <NA>
#>  ---                                                                 
#> 197:                 bottom                     left             <NA>
#> 198:                   <NA>                     <NA>             <NA>
#> 199:                 bottom                    right             <NA>
#> 200:                   <NA>                     <NA>             <NA>
#> 201:                 bottom                    right             <NA>
#>      receives_7m_number turnover technical_foul  steal suspension is_home
#>                  <char>   <char>         <char> <char>     <char>  <lgcl>
#>   1:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>   2:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>   3:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>   4:               <NA>     <NA>           <NA>   <NA>          9    TRUE
#>   5:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>  ---                                                                     
#> 197:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#> 198:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 199:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 200:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 201:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>      number_suspended no_goalkeeper number_court_players posession
#>                 <int>         <num>                <num>    <char>
#>   1:                0            NA                   NA       CHI
#>   2:                0            NA                   NA       CHI
#>   3:                0             0                    6       CHI
#>   4:                0             0                    6       CHI
#>   5:                0             0                    6       IRI
#>  ---                                                              
#> 197:                0             0                    6       CHI
#> 198:               -1             1                    6       CHI
#> 199:               -1             1                    6       IRI
#> 200:               -1             0                    5       IRI
#> 201:                0             0                    6       CHI
#>      number_of_possesion start_of_possession end_of_possession   score  lead
#>                    <int>              <char>            <char>  <char> <num>
#>   1:                   1                <NA>              <NA>   0 - 0     0
#>   2:                   1                <NA>              <NA>   0 - 0     0
#>   3:                   1                0:00              0:41   0 - 0     0
#>   4:                   1                0:00              0:41   0 - 0     0
#>   5:                   2                0:41              1:49   0 - 1    -1
#>  ---                                                                        
#> 197:                 100               58:20             58:46 24 - 24     0
#> 198:                 100               58:20             58:46 24 - 24     0
#> 199:                 101               58:46             59:33 24 - 25    -1
#> 200:                 101               58:46             59:33 24 - 25    -1
#> 201:                 102               59:33             60:00 24 - 25    -1
```
