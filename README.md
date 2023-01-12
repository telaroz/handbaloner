
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

## Generate Play by Play tidy data from IHF files

First, you need to download the PBP pdf file. You can use the
`scrape_from_ihf` function to do so. Find the link for the match
information and set the folder to download the file.

For the first match of the 2023 World Men’s Handball Championship, you
can download all PDFs as follows:

``` r
scrape_from_ihf(link = "https://www.ihf.info/competitions/men/308/28th-ihf-men039s-world-championship-2023/101253/match-center/118895",
                folder = "pol_swe")
```

Now, use the `generate_tidy_pbp` to generate a `data.frame` in a tidy
format.

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
