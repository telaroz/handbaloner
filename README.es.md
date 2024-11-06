
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
distance_to_goal(10 , 3)
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

dplyr::mutate(tiros, distancia_a_gol =  distance_to_goal(x, y))
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
scrape_from_ihf(link = "https://www.ihf.info/competitions/men/308/28th-ihf-men039s-world-championship-2023-polandsweden/101253/match-center/118963",
                folder = "ejemplo")
```

Ahora, con ayuda de `generate_tidy_pbp` se genera un `data.frame\` en formato 
tidy.

``` r
tidy <- generate_tidy_pbp("ejemplo/47PBP.PDF")
#> Column 2 ['V3'] of item 2 is missing in item 1. Use fill=TRUE to fill with NA (NULL for list columns), or use.names=FALSE to ignore column names. use.names='check' (default from v1.12.2) emits this message and proceeds as if use.names=FALSE for  backwards compatibility. See news item 5 in v1.12.2 for options to control this message.
```

``` r
tidy
#>      match_id     teams gender   time numeric_time  half
#>         <num>    <char> <char> <char>        <num> <num>
#>   1:       47 USA - EGY      M   0:00            0     1
#>   2:       47 USA - EGY      M   0:00            0     1
#>   3:       47 USA - EGY      M   0:39           39     1
#>   4:       47 USA - EGY      M   0:39           39     1
#>   5:       47 USA - EGY      M   0:47           47     1
#>  ---                                                    
#> 169:       47 USA - EGY      M  57:33         3453     2
#> 170:       47 USA - EGY      M  58:28         3508     2
#> 171:       47 USA - EGY      M  59:11         3551     2
#> 172:       47 USA - EGY      M  59:45         3585     2
#> 173:       47 USA - EGY      M  59:55         3595     2
#>                                                                action number
#>                                                                <char> <char>
#>   1:                                            ROBINSON N Goalkeeper    99 
#>   2:                                             HENDAWY K Goalkeeper    88 
#>   3:                                             STROMBERG J Turnover     6 
#>   4:                                                  HENDAWY K Steal    88 
#>   5:         SAAD A Goal right wing top left (48 ABDELHAK M), 86 km/h    53 
#>  ---                                                                        
#> 169:                            ELDERAA Y Goal centre 9m bottom right    39 
#> 170: AMITOVIC A Goal centre 9m bottom left (7 CHAN BLANCO A), 79 km/h     5 
#> 171:                             ELDERAA S Goal centre 9m bottom left    45 
#> 172:                                   AMITOVIC A Shot centre 9m post     5 
#> 173:                                    SHEBIB M Technical Fault (FB)    89 
#>        team goalkeeper opponent_goalkeeper assist_number goal_number
#>      <char>     <char>              <char>        <char>      <char>
#>   1:    USA        99                  88           <NA>        <NA>
#>   2:    EGY        88                  99           <NA>        <NA>
#>   3:    USA        99                  88           <NA>        <NA>
#>   4:    EGY        88                  99           <NA>        <NA>
#>   5:    EGY        88                  99             48         53 
#>  ---                                                                
#> 169:    EGY        92                  99           <NA>         39 
#> 170:    USA        99                  92              7          5 
#> 171:    EGY        92                  99           <NA>         45 
#> 172:    USA        99                  92           <NA>        <NA>
#> 173:    EGY        92                  99           <NA>        <NA>
#>      shot_number  goal shot_speed in_goal_position shot_position  post saved
#>           <char> <num>      <num>           <char>        <char> <num> <num>
#>   1:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   2:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   3:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   4:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>   5:        <NA>     1         86         top left    right wing    NA    NA
#>  ---                                                                        
#> 169:        <NA>     1         NA     bottom right     centre 9m    NA    NA
#> 170:        <NA>     1         79      bottom left     centre 9m    NA    NA
#> 171:        <NA>     1         NA      bottom left     centre 9m    NA    NA
#> 172:          5      0         NA             post     centre 9m     1    NA
#> 173:        <NA>     0         NA             <NA>          <NA>    NA    NA
#>      vertical_goal_position horizontal_goal_position causes_7m_number
#>                      <char>                   <char>           <char>
#>   1:                   <NA>                     <NA>             <NA>
#>   2:                   <NA>                     <NA>             <NA>
#>   3:                   <NA>                     <NA>             <NA>
#>   4:                   <NA>                     <NA>             <NA>
#>   5:                    top                     left             <NA>
#>  ---                                                                 
#> 169:                 bottom                    right             <NA>
#> 170:                 bottom                     left             <NA>
#> 171:                 bottom                     left             <NA>
#> 172:                   <NA>                     <NA>             <NA>
#> 173:                   <NA>                     <NA>             <NA>
#>      receives_7m_number turnover technical_foul  steal suspension is_home
#>                  <char>   <char>         <char> <char>     <char>  <lgcl>
#>   1:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>   2:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>   3:               <NA>       6            <NA>   <NA>       <NA>    TRUE
#>   4:               <NA>     <NA>           <NA>    88        <NA>   FALSE
#>   5:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>  ---                                                                     
#> 169:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 170:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#> 171:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 172:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#> 173:               <NA>     <NA>            89    <NA>       <NA>   FALSE
#>      number_suspended no_goalkeeper number_court_players possession
#>                 <int>         <num>                <num>     <char>
#>   1:                0            NA                   NA        USA
#>   2:                0            NA                   NA        USA
#>   3:                0             0                    6        USA
#>   4:                0             0                    6        USA
#>   5:                0             0                    6        EGY
#>  ---                                                               
#> 169:                0             0                    6        EGY
#> 170:                0             0                    6        USA
#> 171:                0             0                    6        EGY
#> 172:                0             0                    6        USA
#> 173:                0             0                    6        EGY
#>      number_of_possession start_of_possession end_of_possession   score  lead
#>                     <int>              <char>            <char>  <char> <num>
#>   1:                    1                <NA>              <NA>   0 - 0     0
#>   2:                    1                <NA>              <NA>   0 - 0     0
#>   3:                    1                0:00              0:39   0 - 0     0
#>   4:                    1                0:00              0:39   0 - 0     0
#>   5:                    2                0:39              0:47   0 - 1    -1
#>  ---                                                                         
#> 169:                  115               57:22             57:33 15 - 34   -19
#> 170:                  116               57:33             58:28 16 - 34   -18
#> 171:                  117               58:28             59:11 16 - 35   -19
#> 172:                  118               59:11             59:45 16 - 35   -19
#> 173:                  119               59:45             60:00 16 - 35   -19
#>      possession_length
#>                  <num>
#>   1:                NA
#>   2:                NA
#>   3:                39
#>   4:                39
#>   5:                 8
#>  ---                  
#> 169:                11
#> 170:                55
#> 171:                43
#> 172:                34
#> 173:                15
```


## Graficar ritmo de juego de ambos equipos a través del juego

Para graficar el ritmo de ambos equipos en intervalos de 5 minutos, solamente
necesitamos los datos del play by play generados en formato tidy por la 
función `generate_tidy_pbp`. La función `plot_paces` toma los datos el número
identificador del partido que queremos visualizar y devuelve el gráfico.


``` r
plot_paces(tidy, 47)
```

<img src="man/figures/imagen_paces.png" width="100%" />
