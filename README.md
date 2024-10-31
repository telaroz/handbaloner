
<!-- README.md is generated from README.Rmd. Please edit that file -->

# handbaloner

- Documentación en [español](README.es.md) <!-- badges: start -->
  <!-- badges: end -->

The `handbaloner` package has useful function for the visualization of
handball data.

## Package installation

The development version can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("telaroz/handbaloner")
```

Also, the `plot_paces` function has as dependency the package `ggflags`,
which is not in CRAN. So in order to use that function, that dependency
should be installed (not needed to use the rest of the functions)

``` r
install.packages("ggflags", repos = c(
  "https://jimjam-slam.r-universe.dev",
  "https://cloud.r-project.org"))
```

## Court visualization examples

In this example, we can draw a basic court.

``` r
library(handbaloner)

court()
```

<img src="man/figures/README-basic_example-1.png" width="100%" />

We can change the colours, rotate vertically and mirror the court with
the functions’ parameters

``` r
court(vertical = TRUE, flip = TRUE, court_color = "orange", 
      area_color = "#3431A2", lines_color = "black")
```

<img src="man/figures/README-example_with_colours-1.png" width="100%" />

As the plots are generated with ggplot, we can describe the colours with
their HEX code, rgb, number or by its name in english; see: [use of
colours in ggplot2](https://r-graph-gallery.com/ggplot2-color.html)

We can also draw half a court

``` r
half_court(vertical = TRUE, court_color = colors()[36], 
      area_color = rgb(red = 0.2, green = 0.4, blue = 0.6), 
      lines_color = "yellow")
```

<img src="man/figures/README-half_court_example-1.png" width="100%" />

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
#> # A tibble: 5 × 4
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

<img src="man/figures/README-court_with_shots-1.png" width="100%" />

## Goal visualization examples

In this example, we can draw a handball goal.

``` r
library(handbaloner)

draw_goal()
```

<img src="man/figures/README-basic_example_goal-1.png" width="70%" />

We can change the colour of the goal. It is red by default.

``` r
library(handbaloner)

draw_goal("blue")
```

<img src="man/figures/README-color_change-1.png" width="70%" />

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

<img src="man/figures/README-goal_with_shots-1.png" width="100%" />

## Generate Play by Play tidy data from IHF files

First, you need to download the PBP pdf file. You can use the
`scrape_from_ihf` function to do so. Find the link for the match
information and set the folder to download the file.

For the first match of the 2023 World Men’s Handball Championship, you
can download all PDFs as follows:

``` r

scrape_from_ihf(link = "https://www.ihf.info/competitions/men/308/28th-ihf-men039s-world-championship-2023-polandsweden/101253/match-center/118963",
                folder = "ejemplo")
```

Now, use the `generate_tidy_pbp` to generate a `data.frame` in a tidy
format.

``` r
tidy <- generate_tidy_pbp("ejemplo/47PBP.PDF")
#> Column 2 ['V3'] of item 2 is missing in item 1. Use fill=TRUE to fill with NA (NULL for list columns), or use.names=FALSE to ignore column names. use.names='check' (default from v1.12.2) emits this message and proceeds as if use.names=FALSE for  backwards compatibility. See news item 5 in v1.12.2 for options to control this message.
```

``` r
gt::gt_preview(tidy)
```

<div id="vgvbczkynz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#vgvbczkynz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#vgvbczkynz thead, #vgvbczkynz tbody, #vgvbczkynz tfoot, #vgvbczkynz tr, #vgvbczkynz td, #vgvbczkynz th {
  border-style: none;
}
&#10;#vgvbczkynz p {
  margin: 0;
  padding: 0;
}
&#10;#vgvbczkynz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#vgvbczkynz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#vgvbczkynz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#vgvbczkynz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#vgvbczkynz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#vgvbczkynz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#vgvbczkynz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#vgvbczkynz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#vgvbczkynz .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#vgvbczkynz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#vgvbczkynz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#vgvbczkynz .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#vgvbczkynz .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#vgvbczkynz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#vgvbczkynz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#vgvbczkynz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#vgvbczkynz .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#vgvbczkynz .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#vgvbczkynz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#vgvbczkynz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#vgvbczkynz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#vgvbczkynz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#vgvbczkynz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#vgvbczkynz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#vgvbczkynz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#vgvbczkynz .gt_left {
  text-align: left;
}
&#10;#vgvbczkynz .gt_center {
  text-align: center;
}
&#10;#vgvbczkynz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#vgvbczkynz .gt_font_normal {
  font-weight: normal;
}
&#10;#vgvbczkynz .gt_font_bold {
  font-weight: bold;
}
&#10;#vgvbczkynz .gt_font_italic {
  font-style: italic;
}
&#10;#vgvbczkynz .gt_super {
  font-size: 65%;
}
&#10;#vgvbczkynz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#vgvbczkynz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#vgvbczkynz .gt_indent_1 {
  text-indent: 5px;
}
&#10;#vgvbczkynz .gt_indent_2 {
  text-indent: 10px;
}
&#10;#vgvbczkynz .gt_indent_3 {
  text-indent: 15px;
}
&#10;#vgvbczkynz .gt_indent_4 {
  text-indent: 20px;
}
&#10;#vgvbczkynz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=""></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="match_id">match_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="teams">teams</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="gender">gender</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="time">time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="numeric_time">numeric_time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="half">half</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="action">action</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="number">number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="team">team</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="goalkeeper">goalkeeper</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="opponent_goalkeeper">opponent_goalkeeper</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="assist_number">assist_number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="goal_number">goal_number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="shot_number">shot_number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="goal">goal</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="shot_speed">shot_speed</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="in_goal_position">in_goal_position</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="shot_position">shot_position</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="post">post</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="saved">saved</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="vertical_goal_position">vertical_goal_position</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="horizontal_goal_position">horizontal_goal_position</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="causes_7m_number">causes_7m_number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="receives_7m_number">receives_7m_number</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="turnover">turnover</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="technical_foul">technical_foul</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="steal">steal</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="suspension">suspension</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="is_home">is_home</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="number_suspended">number_suspended</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="no_goalkeeper">no_goalkeeper</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="number_court_players">number_court_players</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="possession">possession</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="number_of_possession">number_of_possession</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_of_possession">start_of_possession</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_of_possession">end_of_possession</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="score">score</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="lead">lead</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="possession_length">possession_length</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">1</th>
<td headers="stub_1_1 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_1 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_1 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_1 time" class="gt_row gt_right">0:00</td>
<td headers="stub_1_1 numeric_time" class="gt_row gt_right">0</td>
<td headers="stub_1_1 half" class="gt_row gt_right">1</td>
<td headers="stub_1_1 action" class="gt_row gt_left">ROBINSON N Goalkeeper</td>
<td headers="stub_1_1 number" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_1 team" class="gt_row gt_left">USA</td>
<td headers="stub_1_1 goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_1 opponent_goalkeeper" class="gt_row gt_right">88 </td>
<td headers="stub_1_1 assist_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 goal_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 goal" class="gt_row gt_right">0</td>
<td headers="stub_1_1 shot_speed" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 in_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 shot_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 vertical_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 horizontal_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 turnover" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 technical_foul" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 steal" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_1 is_home" class="gt_row gt_center">TRUE</td>
<td headers="stub_1_1 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_1 no_goalkeeper" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 number_court_players" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 possession" class="gt_row gt_left">USA</td>
<td headers="stub_1_1 number_of_possession" class="gt_row gt_right">1</td>
<td headers="stub_1_1 start_of_possession" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 end_of_possession" class="gt_row gt_right">NA</td>
<td headers="stub_1_1 score" class="gt_row gt_right">0 - 0</td>
<td headers="stub_1_1 lead" class="gt_row gt_right">0</td>
<td headers="stub_1_1 possession_length" class="gt_row gt_right">NA</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">2</th>
<td headers="stub_1_2 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_2 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_2 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_2 time" class="gt_row gt_right">0:00</td>
<td headers="stub_1_2 numeric_time" class="gt_row gt_right">0</td>
<td headers="stub_1_2 half" class="gt_row gt_right">1</td>
<td headers="stub_1_2 action" class="gt_row gt_left">HENDAWY K Goalkeeper</td>
<td headers="stub_1_2 number" class="gt_row gt_right">88 </td>
<td headers="stub_1_2 team" class="gt_row gt_left">EGY</td>
<td headers="stub_1_2 goalkeeper" class="gt_row gt_right">88 </td>
<td headers="stub_1_2 opponent_goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_2 assist_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 goal_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 goal" class="gt_row gt_right">0</td>
<td headers="stub_1_2 shot_speed" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 in_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 shot_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 vertical_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 horizontal_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 turnover" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 technical_foul" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 steal" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_2 is_home" class="gt_row gt_center">FALSE</td>
<td headers="stub_1_2 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_2 no_goalkeeper" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 number_court_players" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 possession" class="gt_row gt_left">USA</td>
<td headers="stub_1_2 number_of_possession" class="gt_row gt_right">1</td>
<td headers="stub_1_2 start_of_possession" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 end_of_possession" class="gt_row gt_right">NA</td>
<td headers="stub_1_2 score" class="gt_row gt_right">0 - 0</td>
<td headers="stub_1_2 lead" class="gt_row gt_right">0</td>
<td headers="stub_1_2 possession_length" class="gt_row gt_right">NA</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">3</th>
<td headers="stub_1_3 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_3 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_3 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_3 time" class="gt_row gt_right">0:39</td>
<td headers="stub_1_3 numeric_time" class="gt_row gt_right">39</td>
<td headers="stub_1_3 half" class="gt_row gt_right">1</td>
<td headers="stub_1_3 action" class="gt_row gt_left">STROMBERG J Turnover</td>
<td headers="stub_1_3 number" class="gt_row gt_right"> 6 </td>
<td headers="stub_1_3 team" class="gt_row gt_left">USA</td>
<td headers="stub_1_3 goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_3 opponent_goalkeeper" class="gt_row gt_right">88 </td>
<td headers="stub_1_3 assist_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 goal_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 goal" class="gt_row gt_right">0</td>
<td headers="stub_1_3 shot_speed" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 in_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 shot_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 vertical_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 horizontal_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 turnover" class="gt_row gt_right"> 6 </td>
<td headers="stub_1_3 technical_foul" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 steal" class="gt_row gt_right">NA</td>
<td headers="stub_1_3 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_3 is_home" class="gt_row gt_center">TRUE</td>
<td headers="stub_1_3 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_3 no_goalkeeper" class="gt_row gt_right">0</td>
<td headers="stub_1_3 number_court_players" class="gt_row gt_right">6</td>
<td headers="stub_1_3 possession" class="gt_row gt_left">USA</td>
<td headers="stub_1_3 number_of_possession" class="gt_row gt_right">1</td>
<td headers="stub_1_3 start_of_possession" class="gt_row gt_right">0:00</td>
<td headers="stub_1_3 end_of_possession" class="gt_row gt_right">0:39</td>
<td headers="stub_1_3 score" class="gt_row gt_right">0 - 0</td>
<td headers="stub_1_3 lead" class="gt_row gt_right">0</td>
<td headers="stub_1_3 possession_length" class="gt_row gt_right">39</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">4</th>
<td headers="stub_1_4 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_4 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_4 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_4 time" class="gt_row gt_right">0:39</td>
<td headers="stub_1_4 numeric_time" class="gt_row gt_right">39</td>
<td headers="stub_1_4 half" class="gt_row gt_right">1</td>
<td headers="stub_1_4 action" class="gt_row gt_left">HENDAWY K Steal</td>
<td headers="stub_1_4 number" class="gt_row gt_right">88 </td>
<td headers="stub_1_4 team" class="gt_row gt_left">EGY</td>
<td headers="stub_1_4 goalkeeper" class="gt_row gt_right">88 </td>
<td headers="stub_1_4 opponent_goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_4 assist_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 goal_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 goal" class="gt_row gt_right">0</td>
<td headers="stub_1_4 shot_speed" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 in_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 shot_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 vertical_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 horizontal_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 turnover" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 technical_foul" class="gt_row gt_right">NA</td>
<td headers="stub_1_4 steal" class="gt_row gt_right">88 </td>
<td headers="stub_1_4 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_4 is_home" class="gt_row gt_center">FALSE</td>
<td headers="stub_1_4 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_4 no_goalkeeper" class="gt_row gt_right">0</td>
<td headers="stub_1_4 number_court_players" class="gt_row gt_right">6</td>
<td headers="stub_1_4 possession" class="gt_row gt_left">USA</td>
<td headers="stub_1_4 number_of_possession" class="gt_row gt_right">1</td>
<td headers="stub_1_4 start_of_possession" class="gt_row gt_right">0:00</td>
<td headers="stub_1_4 end_of_possession" class="gt_row gt_right">0:39</td>
<td headers="stub_1_4 score" class="gt_row gt_right">0 - 0</td>
<td headers="stub_1_4 lead" class="gt_row gt_right">0</td>
<td headers="stub_1_4 possession_length" class="gt_row gt_right">39</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">5</th>
<td headers="stub_1_5 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_5 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_5 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_5 time" class="gt_row gt_right">0:47</td>
<td headers="stub_1_5 numeric_time" class="gt_row gt_right">47</td>
<td headers="stub_1_5 half" class="gt_row gt_right">1</td>
<td headers="stub_1_5 action" class="gt_row gt_left">SAAD A Goal right wing top left (48 ABDELHAK M), 86 km/h</td>
<td headers="stub_1_5 number" class="gt_row gt_right">53 </td>
<td headers="stub_1_5 team" class="gt_row gt_left">EGY</td>
<td headers="stub_1_5 goalkeeper" class="gt_row gt_right">88 </td>
<td headers="stub_1_5 opponent_goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_5 assist_number" class="gt_row gt_right">48</td>
<td headers="stub_1_5 goal_number" class="gt_row gt_right">53 </td>
<td headers="stub_1_5 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_5 goal" class="gt_row gt_right">1</td>
<td headers="stub_1_5 shot_speed" class="gt_row gt_right">86</td>
<td headers="stub_1_5 in_goal_position" class="gt_row gt_left">top left</td>
<td headers="stub_1_5 shot_position" class="gt_row gt_left">right wing</td>
<td headers="stub_1_5 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_5 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_5 vertical_goal_position" class="gt_row gt_left">top</td>
<td headers="stub_1_5 horizontal_goal_position" class="gt_row gt_left">left</td>
<td headers="stub_1_5 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_5 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_5 turnover" class="gt_row gt_right">NA</td>
<td headers="stub_1_5 technical_foul" class="gt_row gt_right">NA</td>
<td headers="stub_1_5 steal" class="gt_row gt_right">NA</td>
<td headers="stub_1_5 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_5 is_home" class="gt_row gt_center">FALSE</td>
<td headers="stub_1_5 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_5 no_goalkeeper" class="gt_row gt_right">0</td>
<td headers="stub_1_5 number_court_players" class="gt_row gt_right">6</td>
<td headers="stub_1_5 possession" class="gt_row gt_left">EGY</td>
<td headers="stub_1_5 number_of_possession" class="gt_row gt_right">2</td>
<td headers="stub_1_5 start_of_possession" class="gt_row gt_right">0:39</td>
<td headers="stub_1_5 end_of_possession" class="gt_row gt_right">0:47</td>
<td headers="stub_1_5 score" class="gt_row gt_right">0 - 1</td>
<td headers="stub_1_5 lead" class="gt_row gt_right">-1</td>
<td headers="stub_1_5 possession_length" class="gt_row gt_right">8</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier; font-size: x-small; background-color: #E4E4E4;">6..172</th>
<td headers="stub_1_6 match_id" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 teams" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 gender" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 time" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 numeric_time" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 half" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 action" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 number" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 team" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 goalkeeper" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 opponent_goalkeeper" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 assist_number" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 goal_number" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 shot_number" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 goal" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 shot_speed" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 in_goal_position" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 shot_position" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 post" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 saved" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 vertical_goal_position" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 horizontal_goal_position" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 causes_7m_number" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 receives_7m_number" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 turnover" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 technical_foul" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 steal" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 suspension" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 is_home" class="gt_row gt_center" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 number_suspended" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 no_goalkeeper" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 number_court_players" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 possession" class="gt_row gt_left" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 number_of_possession" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 start_of_possession" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 end_of_possession" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 score" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 lead" class="gt_row gt_right" style="background-color: #E4E4E4;"></td>
<td headers="stub_1_6 possession_length" class="gt_row gt_right" style="background-color: #E4E4E4;"></td></tr>
    <tr><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub" style="font-family: Courier;">173</th>
<td headers="stub_1_7 match_id" class="gt_row gt_right">47</td>
<td headers="stub_1_7 teams" class="gt_row gt_left">USA - EGY</td>
<td headers="stub_1_7 gender" class="gt_row gt_left">M</td>
<td headers="stub_1_7 time" class="gt_row gt_right">59:55</td>
<td headers="stub_1_7 numeric_time" class="gt_row gt_right">3595</td>
<td headers="stub_1_7 half" class="gt_row gt_right">2</td>
<td headers="stub_1_7 action" class="gt_row gt_left">SHEBIB M Technical Fault (FB)</td>
<td headers="stub_1_7 number" class="gt_row gt_right">89 </td>
<td headers="stub_1_7 team" class="gt_row gt_left">EGY</td>
<td headers="stub_1_7 goalkeeper" class="gt_row gt_right">92 </td>
<td headers="stub_1_7 opponent_goalkeeper" class="gt_row gt_right"> 99 </td>
<td headers="stub_1_7 assist_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 goal_number" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 shot_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 goal" class="gt_row gt_right">0</td>
<td headers="stub_1_7 shot_speed" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 in_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 shot_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 post" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 saved" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 vertical_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 horizontal_goal_position" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 causes_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 receives_7m_number" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 turnover" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 technical_foul" class="gt_row gt_right">89 </td>
<td headers="stub_1_7 steal" class="gt_row gt_right">NA</td>
<td headers="stub_1_7 suspension" class="gt_row gt_left">NA</td>
<td headers="stub_1_7 is_home" class="gt_row gt_center">FALSE</td>
<td headers="stub_1_7 number_suspended" class="gt_row gt_right">0</td>
<td headers="stub_1_7 no_goalkeeper" class="gt_row gt_right">0</td>
<td headers="stub_1_7 number_court_players" class="gt_row gt_right">6</td>
<td headers="stub_1_7 possession" class="gt_row gt_left">EGY</td>
<td headers="stub_1_7 number_of_possession" class="gt_row gt_right">119</td>
<td headers="stub_1_7 start_of_possession" class="gt_row gt_right">59:45</td>
<td headers="stub_1_7 end_of_possession" class="gt_row gt_right">60:00</td>
<td headers="stub_1_7 score" class="gt_row gt_right">16 - 35</td>
<td headers="stub_1_7 lead" class="gt_row gt_right">-19</td>
<td headers="stub_1_7 possession_length" class="gt_row gt_right">15</td></tr>
  </tbody>
  &#10;  
</table>
</div>

## Plot paces of both teams throughout the game

To plot the paces of both teams in 5 minute intervals, we just need to
have the play by play data in a tidy format generated by the
`generate_tidy_pbp`. The `plot_paces` function takes the data and the
match ID we want to visualize and returns the plot.

``` r
plot_paces(tidy, 47)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
