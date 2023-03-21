
<!-- README.md is generated from README.Rmd. Please edit that file -->

# handbaloner

- Documentación en [español](README.es.md) <!-- badges: start -->
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

As the plots are generated with ggplot, we can describe the colours with
their HEX code, rgb, number or by its name in english; see: [use of
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
shots <- dplyr::tibble(x = c(-13, -12, 11, -11, 9.5),
                       y = c(2, 5, -3, -1, 0),
                       gol = c(1, 0, 1, 1, 0))

dplyr::mutate(shots, distance_to_goal = purrr::map2_dbl(x, y, ~ distance_to_goal(c(.x, .y))))
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
  ggplot2::geom_point(data = shots, ggplot2::aes(x, y),
                      color = ifelse(shots$gol == 1, 'Green', 'Red'),
                      size = 4)
```

<img src="man/figures/README-court with shots-1.png" width="100%" />

## Goal visualization examples

In this example, we can draw a handball goal.

``` r
library(handbaloner)

draw_goal()
```

<img src="man/figures/README-basic example goal-1.png" width="100%" />

We can change the colour of the goal. It is red by default.

``` r
library(handbaloner)

draw_goal("blue")
```

<img src="man/figures/README-color change-1.png" width="100%" />

Now, let’s draw some shots, just as we did with the court:

``` r
goal_shots <- dplyr::tibble(x = c(-2, -1, 0.5, 0.7, 1.4),
                       y = c(0.2, 2, -0.5, 0.3, 0.9),
                       gol = c(0, 0, 1, 1, 1))

draw_goal() +
  ggplot2::geom_point(data = goal_shots, ggplot2::aes(x, y),
                      color = ifelse(goal_shots$gol == 1, 'Green', 'Red'),
                      size = 4)
```

<img src="man/figures/README-goal with shots-1.png" width="100%" />

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
generate_tidy_pbp("pol_swe/01PBP.PDF")
#> Warning in .parse_hms(..., order = "MS", quiet = quiet): Some strings failed to
#> parse, or all strings are NAs
#> Column 2 ['V3'] of item 2 is missing in item 1. Use fill=TRUE to fill with NA (NULL for list columns), or use.names=FALSE to ignore column names. use.names='check' (default from v1.12.2) emits this message and proceeds as if use.names=FALSE for  backwards compatibility. See news item 5 in v1.12.2 for options to control this message.
#> Warning in .parse_hms(..., order = "MS", quiet = quiet): Some strings failed to
#> parse, or all strings are NAs

#> Warning in .parse_hms(..., order = "MS", quiet = quiet): Some strings failed to
#> parse, or all strings are NAs
#>      match_id     teams gender   time numeric_time  half
#>         <num>    <char> <char> <char>        <num> <num>
#>   1:        1 FRA - POL      M   0:00            0     1
#>   2:        1 FRA - POL      M   0:00            0     1
#>   3:        1 FRA - POL      M   0:38           38     1
#>   4:        1 FRA - POL      M   1:28           88     1
#>   5:        1 FRA - POL      M   1:37           97     1
#>  ---                                                    
#> 168:        1 FRA - POL      M  59:17         3557     2
#> 169:        1 FRA - POL      M  59:36         3576     2
#> 170:        1 FRA - POL      M  59:43         3583     2
#> 171:        1 FRA - POL      M  59:53         3593     2
#> 172:        1 FRA - POL      M  59:56         3596     2
#>                                                           action number   team
#>                                                           <char> <char> <char>
#>   1:                                         GERARD V Goalkeeper     12    FRA
#>   2:                                       MORAWSKI A Goalkeeper     94    POL
#>   3:                    TOURNAT N Shot centre 6m saved top right     11    FRA
#>   4:                         SICKO S Shot left 6m saved top left      9    POL
#>   5: GREBILLE M Goal left wing bottom left (5 REMILI N), 79 km/h     15    FRA
#>  ---                                                                          
#> 168:                                                Team timeout           FRA
#> 169:           NAHI D Goal left wing bottom left (23 FABREGAS L)     31    FRA
#> 170:                        DASZEK Mfor 94 MORAWSKI A Empty goal      3    POL
#> 171:                      SICKO S Goal breakthrough bottom right      9    POL
#> 172:                    MORAWSKI Afor 3 DASZEK M Goalkeeper back     94    POL
#>      goalkeeper opponent_goalkeeper assist_number goal_number shot_number  goal
#>          <char>              <char>        <char>      <char>      <char> <num>
#>   1:         12                  94          <NA>        <NA>        <NA>     0
#>   2:         94                  12          <NA>        <NA>        <NA>     0
#>   3:         12                  94          <NA>        <NA>          11     0
#>   4:         94                  12          <NA>        <NA>           9     0
#>   5:         12                  94             5          15        <NA>     1
#>  ---                                                                           
#> 168:         12                  94          <NA>        <NA>        <NA>     0
#> 169:         12                  94            23          31        <NA>     1
#> 170: Empty goal                  12          <NA>        <NA>        <NA>     0
#> 171: Empty goal                  12          <NA>           9        <NA>     1
#> 172:         94                  12          <NA>        <NA>        <NA>     0
#>      shot_speed in_goal_position shot_position  post saved
#>           <num>           <char>        <char> <num> <num>
#>   1:         NA             <NA>          <NA>    NA    NA
#>   2:         NA             <NA>          <NA>    NA    NA
#>   3:         NA        top right     centre 6m    NA     1
#>   4:         NA         top left       left 6m    NA     1
#>   5:         79      bottom left     left wing    NA    NA
#>  ---                                                      
#> 168:         NA             <NA>          <NA>    NA    NA
#> 169:         NA      bottom left     left wing    NA    NA
#> 170:         NA             <NA>          <NA>    NA    NA
#> 171:         NA     bottom right  breakthrough    NA    NA
#> 172:         NA             <NA>          <NA>    NA    NA
#>      vertical_goal_position horizontal_goal_position causes_7m_number
#>                      <char>                   <char>           <char>
#>   1:                   <NA>                     <NA>             <NA>
#>   2:                   <NA>                     <NA>             <NA>
#>   3:                    top                    right             <NA>
#>   4:                    top                     left             <NA>
#>   5:                 bottom                     left             <NA>
#>  ---                                                                 
#> 168:                   <NA>                     <NA>             <NA>
#> 169:                 bottom                     left             <NA>
#> 170:                   <NA>                     <NA>             <NA>
#> 171:                 bottom                    right             <NA>
#> 172:                   <NA>                     <NA>             <NA>
#>      receives_7m_number turnover technical_foul  steal suspension is_home
#>                  <char>   <char>         <char> <char>     <char>  <lgcl>
#>   1:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>   2:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>   3:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>   4:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>   5:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#>  ---                                                                     
#> 168:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#> 169:               <NA>     <NA>           <NA>   <NA>       <NA>    TRUE
#> 170:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 171:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#> 172:               <NA>     <NA>           <NA>   <NA>       <NA>   FALSE
#>      number_suspended no_goalkeeper number_court_players possession
#>                 <int>         <num>                <num>     <char>
#>   1:                0            NA                   NA        FRA
#>   2:                0            NA                   NA        FRA
#>   3:                0             0                    6        FRA
#>   4:                0             0                    6        POL
#>   5:                0             0                    6        FRA
#>  ---                                                               
#> 168:                0             0                    6        FRA
#> 169:                0             0                    6        FRA
#> 170:                0             1                    7        FRA
#> 171:                0             1                    7        POL
#> 172:                0             0                    6        POL
#>      number_of_possession start_of_possession end_of_possession   score  lead
#>                     <int>              <char>            <char>  <char> <num>
#>   1:                    1                <NA>              <NA>   0 - 0     0
#>   2:                    1                <NA>              <NA>   0 - 0     0
#>   3:                    1                0:00              0:38   0 - 0     0
#>   4:                    2                0:38              1:28   0 - 0     0
#>   5:                    3                1:28              1:37   1 - 0     1
#>  ---                                                                         
#> 168:                   93               58:46             59:36 25 - 23     2
#> 169:                   93               58:46             59:36 26 - 23     3
#> 170:                   93               58:46             59:36 26 - 23     3
#> 171:                   94               59:36             60:00 26 - 24     2
#> 172:                   94               59:36             60:00 26 - 24     2
#>      possession_length
#>                  <num>
#>   1:                NA
#>   2:                NA
#>   3:                38
#>   4:                50
#>   5:                 9
#>  ---                  
#> 168:                50
#> 169:                50
#> 170:                50
#> 171:                24
#> 172:                24
```
