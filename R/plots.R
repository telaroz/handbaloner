#' Creación del campo completo
#'
#' @param vertical Si la visualización se quiere vertical, poner TRUE
#' @param flip Si la visualizción se quiere rotada (ver dónde está la zona de cambios)
#' @param court_color Color del campo. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#' @param area_color Color del área. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#' @param lines_color Color de las líneas de campo. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#' @return Un gráfico completo con los colores y orientación deseada
#' @export
#'
#' @examples
#' \dontrun{
#' court(vertical = TRUE, flip = FALSE, court_color = '#1871c9',
#' area_color = '#d1b111', lines_color = 'white')
#' }
court <- function(vertical = FALSE, flip = FALSE, court_color = '#1871c9',
                    area_color = '#d1b111', lines_color = 'white'){
    lines <- lines_generator()
    make_flip <- NULL

    if(flip) make_flip <- '-'

    type_of_plot <-
      ifelse(vertical,
             paste0('ggplot2::aes(', make_flip, 'y, ', make_flip, 'x)'),
             paste0('ggplot2::aes(', 'x, ', make_flip, 'y)'))


    plot <- ggplot2::ggplot(mapping = eval(parse(text = type_of_plot))) +
      ggplot2::geom_path(data = lines$side_and_goal_lines, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$goal1, color = 'red', size = 1.5) +
      ggplot2::geom_path(data = lines$goal2, color = 'red', size = 1.5) +
      ggplot2::geom_polygon(data = lines$side_and_goal_lines, fill = court_color) +
      ggplot2::geom_path(data = lines$center_line, size = 1, color = lines_color) +
      ggplot2::geom_polygon(data = lines$six_m1, fill = area_color) +
      ggplot2::geom_polygon(data = lines$six_m2, fill = area_color) +
      ggplot2::geom_path(data = lines$front6_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$front6_2, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$quart_circle6_1_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$quart_circle6_1_2, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$quart_circle6_2_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$quart_circle6_2_2, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$free_thr_compl1, linetype = 'dashed', size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$free_thr_compl2, linetype = 'dashed', size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$goal_restr_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$goal_restr_2, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$sevenm_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$sevenm_2, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$substitution_1, size = 1, color = lines_color) +
      ggplot2::geom_path(data = lines$substitution_2, size = 1, color = lines_color) +
      ggplot2::coord_fixed() + # Queremos mantener la proporción 40x20
      ggplot2::theme_void()

    return(plot)
  }



#' Creación de medio campo verticalmente (arriba)
#'
#' @param vertical Si la visualización se quiere vertical, poner TRUE
#' @param flip Si la visualizción se quiere rotada (ver dónde está la zona de cambios)
#' @param court_color Color del campo. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#' @param area_color Color del área. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#' @param lines_color Color de las líneas de campo. Ver las opciones de ggplot2 (Puede ser dado en HEX o colores)
#'
#' @return a completeUn gráfico completo con los colores y orientación deseada
#' @export
#'
#' @examples
#' \dontrun{
#' half_court(vertical = TRUE, flip = FALSE, court_color = '#1871c9',
#' area_color = '#d1b111', lines_color = 'white')
#' }
half_court <- function(vertical = TRUE, flip = FALSE, court_color = '#1871c9',
                       area_color = '#d1b111', lines_color = 'white'){

  lines <- lines_generator()
  make_flip <- NULL

  if(flip) make_flip <- '-'

  type_of_plot <-
    ifelse(vertical,
           paste0('ggplot2::aes(y, ', make_flip, 'x)'),
           paste0('ggplot2::aes(', make_flip, 'x, ', 'y)'))


  plot <- ggplot2::ggplot(mapping = eval(parse(text = type_of_plot))) +
    ggplot2::geom_path(data = lines$side_and_goal_lines_half, size = 1, color = lines_color) +
    ggplot2::geom_polygon(data = lines$side_and_goal_lines_half, fill = court_color) +
    ggplot2::geom_polygon(data = lines$six_m2, fill = area_color) +
    ggplot2::geom_path(data = lines$goal2, color = 'red', size = 1.5) +
    ggplot2::geom_path(data = lines$front6_2, size = 1, color = lines_color) +
    ggplot2::geom_path(data = lines$quart_circle6_2_1, size = 1, color = lines_color) +
    ggplot2::geom_path(data = lines$quart_circle6_2_2, size = 1, color = lines_color) +
    ggplot2::geom_path(data = lines$free_thr_compl2, linetype = 'dashed', size = 1, color = lines_color) +
    ggplot2::geom_path(data = lines$goal_restr_2, size = 1, color = lines_color) +
    ggplot2::geom_path(data = lines$sevenm_2, size = 1, color = lines_color) +
    ggplot2::coord_fixed() + # Queremos mantener la proporción 40x20
    ggplot2::theme_void()

  return(plot)
}

#' Draw the goal
#'
#' @param color Colour of the goal. By default red.
#'
#' @return ggplot plot showing a goal
#' @export
#'
#' @examples draw_goal("blue")
draw_goal <- function(color = "#b90d16"){

  library(ggplot2)

  goal_width <- 0.08
  contour_size <- 1.1

  coloured_dimensions <-
    data.frame(xmin = c(seq(from = -1.5, to = 1.5 - 0.2,
                            by = 0.4) ,
                        rep(-1.5 - goal_width, 5) + 0.004,
                        rep(1.5, 5) + 0.004,
                        c(-1.5 - goal_width + 0.004, 1.5)),
               xmax = c(seq(from = -1.5 + 0.2, to = 1.5, by = 0.4),
                        rep(-1.5, 5) - 0.002,
                        rep(1.5 + goal_width, 5) - 0.002,
                        c(-1.5, 1.5 + goal_width - 0.002)),
               ymin = c(rep(1, 8) + 0.002,
                        seq(from = -1 + 0.2, to = 1, by = 0.4),
                        seq(from = -1 + 0.2, to = 1, by = 0.4),
                        c(1, 1)),
               ymax = c(rep(1 + goal_width, 8) - 0.004,
                        seq(from = -1 + 0.2 + 0.2, to = 1, by = 0.4),
                        seq(from = -1 + 0.2 + 0.2, to = 1, by = 0.4),
                        c(1 + goal_width - 0.004, 1 +
                            goal_width - 0.004)))
  ggplot2::ggplot() +
    ggplot2::geom_rect(data = coloured_dimensions,
                       ggplot2::aes(xmin = xmin ,
                                    xmax = xmax,
                                    ymin = ymin,
                                    ymax = ymax),
                       fill = color) +
    ggplot2::geom_line(ggplot2::aes(x = c(-1.5, -1.5, 1.5, 1.5),
                                    y = c(-1, 1, 1, -1)),
                       linewidth = contour_size) +
    ggplot2::geom_line(aes(x = c(-1.5 - goal_width, -1.5 - goal_width,
                                 1.5 + goal_width, 1.5 + goal_width),
                           y = c(-1, 1 + goal_width,
                                 1 + goal_width, -1)),
                       linewidth = contour_size) +
    ggplot2::geom_segment(ggplot2::aes(x = -2, xend = 2,
                                       y = -1, yend = -1),
                          size = 2.5) +
    ggplot2::theme_void()

}

#' Generate a pace plot for each 5-minutes inverval for 2 teams
#' @param pbp_data PBP data
#' @param chosen_match_id Which match_id you want to plot
#' @param move_explanation_right Explanation on what pace is can be moved to the rigth
#'
#' @return plot with the paces
#' @export
#'
#' @examples plot_paces(pbp_data, 1)
#' @importFrom ggplot2 layer
plot_paces <- function(pbp_data, chosen_match_id, move_explanation_right = 0){
  library(ggflags)
  raw_data <- data.table::as.data.table(pbp_data)

  data <- raw_data[start_of_possession != "",
                   .(match_id, score, half, team, teams, is_home, number_of_possession,
                     possession, start_of_possession, end_of_possession,
                     lead, numeric_time)]

  data <- data[,.SD[.N], .(match_id, number_of_possession)]

  data[, start_of_possession := data.table::fifelse(stringr::str_length(start_of_possession) == 8,
                                                    stringr::str_sub(start_of_possession, 1, 5),
                                                    as.character(start_of_possession))]


  data[, end_of_possession := data.table::fifelse(stringr::str_length(end_of_possession) == 8,
                                                  stringr::str_sub(end_of_possession, 1, 5),
                                                  as.character(end_of_possession))]

  data[, possession_length := as.numeric(lubridate::ms(end_of_possession)) -
         as.numeric(lubridate::ms(start_of_possession))]

  data[, sum(possession_length)]
  data[, sum(possession_length), .(match_id, half)]


  data[, lead_at_beginning_of_possession := data.table::shift(lead), match_id]
  data[is.na(lead_at_beginning_of_possession), lead_at_beginning_of_possession := 0]


  data[, .(pace = mean(possession_length)), possession][order(pace)]



  ex <- data[match_id == chosen_match_id][, numeric_time := as.numeric(lubridate::ms(start_of_possession))][]

  which_home <- ex[is_home == TRUE]$team[1]
  ex[, is_home := possession == which_home]
  ex[, lead_by_team := data.table::fifelse(is_home,
                                           lead_at_beginning_of_possession,
                                           -lead_at_beginning_of_possession)]

  ex[, mean_pace := round(mean(possession_length)), possession]


  add_pace <- function(minutes){
    ex[, glue::glue("interval_{minutes}_minutes") := (numeric_time %/% (minutes*60))*minutes]
    ex[, glue::glue("pace_by_{minutes}_minutes") := mean(possession_length), by = c("possession", glue::glue("interval_{minutes}_minutes"))]
  }

  purrr::walk(c(1, 5, 10, 15, 20, 25, 30), add_pace)

  ex <- handbaloner::complete_team_names[ex, on = "team==possession"][, possession := team]

  for_plot <- ex[, .(numeric_time, possession = team,
                     minutes = interval_5_minutes,
                     pace = pace_by_5_minutes,
                     lead_by_team, score, lower_ggflag)]

  handbaloner::add_bands(data = for_plot,
                         minutes_column =  "minutes",
                         band_cuts = c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60))
  #interval_5_minutes,
  # pace_by_1_minutes, pace_by_10_minutes, pace_by_5_minutes, pace_by_15_minutes, pace_by_20_minutes, pace_by_25_minutes, pace_by_30_minutes)]

  pace_plot <- for_plot[,.(minutes, numeric_time, pace, possession, score, minutes_band, lower_ggflag)
  ][,.SD[1],  by = .(minutes, pace, possession)
  ][order(numeric_time)]


  for_plot[, max_pace := max(pace), .(minutes)]
  lead_plot <- for_plot[,.(minutes, lead_by_team, possession)] %>% unique()

  scores_at_the_end_of_cuts <- for_plot[,.SD[.N],
                                              by = .(minutes)]

  final_score <- for_plot[.N]$score


  for_title_part1 <- glue::glue("{ex[is_home == TRUE]$country[1]} - {ex[is_home == FALSE]$country[1]}")
  for_title_part2 <- glue::glue("Final score: {ex[is_home == TRUE]$possession[1]} {final_score} {ex[is_home == FALSE]$possession[1]}")
  for_title_part3 <- glue::glue("Match id: {ex$match_id[1]}")

  for_subtitle <- glue::glue("Displayed is the score each interval ended with.")
  for_means <- glue::glue("
                           Mean pace in seconds:
                              {ex[is_home == TRUE]$possession[1]}: {ex[is_home == TRUE]$mean_pace[1]}
                              {ex[is_home == FALSE]$possession[1]}: {ex[is_home == FALSE]$mean_pace[1]}
                          ")


  round_up <- function(x, to = 5)
  {
    to*(x%/%to + as.logical(x%%to))
  }

  maximo_hacia_arriba <- round_up(max(pace_plot$pace) + 5, 5)

  pace_plot[, two_min_image := "2min.png"]


  plot_colours <- c("#B9AF49", "#5049B9")

  ggplot2::ggplot(pace_plot, mapping = ggplot2::aes(x = minutes, y = pace, colour = possession, country = lower_ggflag)) +
    ggplot2::theme_classic() +
    ggplot2::geom_area(ggplot2::aes(fill = possession), alpha = 0.10, position = 'identity', show.legend = FALSE) +
    ggplot2::geom_line(size = 0.7) +
    ggflags::geom_flag(size = 5, show.legend = FALSE) +
    # geom_text(data = scores_at_the_beggining_of_cuts,
    #           aes(y = max(pace_plot$pace) + 2,label = score),
    #           colour = "black",
    #           size = 4) +
    ggplot2::geom_text(data = scores_at_the_end_of_cuts,
                       ggplot2::aes(y = max_pace + 3,label = score),
                       colour = "black",
                       size = 4) +
    #    scale_x_continuous(, limits = c(0,60)) + scale_y_continuous(expand = c(0, maximo_hacia_arriba)) +
    ggplot2::scale_x_continuous(breaks = seq(0, 55, by = 5),
                                expand = c(0.015, 0.30),
                                labels = unique(for_plot$minutes_band)) +
    ggplot2::scale_y_continuous(breaks = seq(0, maximo_hacia_arriba, by = 5)) +
    ggplot2::scale_fill_manual(values = plot_colours) +
    ggplot2::scale_color_manual(values = plot_colours) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 20),
                   plot.subtitle = ggplot2::element_text(hjust = 1),
                   panel.grid.major = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_rect(fill = "#F0EEEF", colour = "black", size = 1)) +
    ggplot2::guides(colour = ggplot2::guide_legend(title = "Team")) +
    # guides(fill = "none") +
    #scale_country(guide = "possession") +
    ggplot2::labs(title = bquote(atop(bold(.(for_title_part1)), atop(.(for_title_part2), atop(.(for_title_part3)), ""))), # look at: https://stackoverflow.com/questions/35367095/multi-line-ggplot-title-with-different-font-size-face-etc
                  subtitle = for_subtitle,
                  x = "Interval in minutes",
                  y = "Pace",
                  caption = "Source: ihf.info") +
    ggplot2::annotate("label", x = 5.5 + move_explanation_right,
                      y = maximo_hacia_arriba,
                      label = "Pace is defined as the mean possession \n  length in seconds for a specified game interval",
                      fill = "#B9AF49") +
    ggplot2::annotate("label", x = 25,
                      y = 5,
                      label = for_means, fill = "#A6A5EE")
}

#' Takes a data.table with shots, locations (or coordinates) and if goal or not and displays them in around the goal
#'
#' @param data Shot data. If ihf_pbp = TRUE, `in_goal_position_column` and `goal_column` so that the funcions fills with the x, y coordinates. 
#' @param ihf_pbp Should be TRUE if we get the shots data from IHF Play by Play. If not, we need the x and y coordinates columns as `x` and `y`. goal_column (categorical "0" - "1" ) is needed.
#' @param goal_column Name of the column that indicates if there is a goal or not (should be in categorical "0" - "1" format)
#' @param in_goal_position_column Name of the column that indicates the in goal position (if data has the IHF PBP format)
#' @param ... additional parameters to pass to draw_goal
#' 
#' @return Plot with the goal and the shots displayed (green are goals and red not goals)
#' @export
#'
#' @examples draw_shots_on_goal(data, TRUE)
draw_shots_on_goal <- function(data, ihf_pbp = FALSE, goal_column = "goal", 
in_goal_position_column = "in_goal_position", ...){
  
if (subset(data, select = goal_column, drop = TRUE) |> 
  class() != "character") {
  stop('The goal column should be a character column with "0" - "1" values')
}
  
if (!subset(data, select = goal_column, drop = TRUE) |> 
  setequal(c("0", "1"))) {
stop('The goal column should be a character column with "0" - "1" values')
}

  coordinates <- in_goal_position_centroid

  colnames(coordinates) <- c(in_goal_position_column, "x", "y")

  sym_in_goal_position_column <- as.name(in_goal_position_column)
  sym_goal_column <- as.name(goal_column)
  
  if (ihf_pbp){
    
    data <- data.table::as.data.table(data) |> 
      data.table::merge.data.table(coordinates, by = in_goal_position_column, 
                                   all.x = TRUE)
    
    draw_goal(...) +
      ggplot2::geom_point(data = data, ggplot2::aes(x = x, y = y, 
                                                     fill = !!sym_goal_column), 
                          size = 4, shape = 21, color = "black",
                          position = ggplot2::position_jitter(width = 0.25,
                                                              height = 0.2)) +
      ggplot2::scale_fill_manual(values = c("0" = "red", "1" = "green")) +
      ggplot2::theme(legend.position = "none") +
      ggplot2::geom_text(data = data[get(in_goal_position_column) %in% c("blocked", "missed", "post")],
                         ggplot2::aes(x = x, y = y + 0.25, 
                                      label = !!sym_in_goal_position_column))
  } else {
    handbaloner::draw_goal(color = "blue") +
      ggplot2::geom_point(data = data, ggplot2::aes(x = x, y = y, 
                                                     fill = !!sym_goal_column),
                          size = 4, shape = 21, color = "black") +
      ggplot2::scale_fill_manual(values = c("0" = "red","1" = "green")) +
      ggplot2::theme(legend.position = "none")
  }
}


#' Takes a data.table with shots, locations (or coordinates) and if goal or not and displays them in the court
#'
#' @param data Shot data. If ihf_pbp = TRUE, `in_goal_position_column` and `goal_column` so that the funcions fills with the x, y coordinates. 
#' @param ihf_pbp Should be TRUE if we get the shots data from IHF Play by Play. If not, we need the x and y coordinates columns as `x` and `y`. goal_column (categorical "0" - "1" ) is needed.
#' @param goal_column Name of the column that indicates if there is a goal or not (should be in categorical "0" - "1" format)
#' @param shot_position_column Name of the column that indicates the in court position (if data has the IHF PBP format)
#' @param ... Aditional parameters to pass to `handbaloner::half_court()`
#' 
#' @return Plot with the goal and the shots displayed (green are goals and red not goals)
#' @export
#'
#' @examples draw_shots_on_half_court(data, TRUE)
draw_shots_on_half_court <- function(data, ihf_pbp = FALSE, goal_column = "goal", 
                                     shot_position_column = "shot_position", ...){
  
if (subset(data, select = goal_column, drop = TRUE) |> 
  class() != "character") {
  stop('The goal column should be a character column with "0" - "1" values')
}
  
if (!subset(data, select = goal_column, drop = TRUE) |> 
  setequal(c("0", "1"))) {
stop('The goal column should be a character column with "0" - "1" values')
}
  coordinates <- in_court_position

  colnames(coordinates) <- c(shot_position_column, "x", "y")

  sym_shot_position_column <- as.name(shot_position_column)
  sym_goal_column <- as.name(goal_column)
  
  if (ihf_pbp){
    
    data <- data.table::as.data.table(data) |> 
      data.table::merge.data.table(coordinates, by = shot_position_column, 
                                   all.x = TRUE)
    
    handbaloner::half_court(...) +
      ggplot2::geom_point(data = data[get(shot_position_column) != "Penalty"],
                          ggplot2::aes(x = x, y = y, fill = !!sym_goal_column),
                          size = 2, shape = 21, colour = "black",
                          position = ggplot2::position_jitter(width = 1,
                                                              height = 0.25)) +
      ggplot2::geom_point(data = data[get(sym_shot_position_column) == "Penalty"],
                          ggplot2::aes(x = x, y = y, fill = !!sym_goal_column),
                          size = 2, shape = 21, colour = "black",
                          position = ggplot2::position_jitter(width = 0.45,
                                                              height = 0.2)) +
      ggplot2::scale_fill_manual(values = c("0" = "red","1" = "green")) +
      ggplot2::theme(legend.position = "none") +
      ggplot2::geom_text(data = data[get(shot_position_column) %in% 
        c("fast break", "empty goal",
          "breakthrough")],
                         ggplot2::aes(x = x, y = y + 0.7, 
                                      label = !!sym_shot_position_column),
                         color = "white")
  } else {
    handbaloner::half_court() +
      ggplot2::geom_point(data = data,
                          ggplot2::aes(x = x, y = y, 
                                       fill = !!sym_goal_column),
                          size = 2, shape = 21, colour = "black",
                          position = ggplot2::position_jitter(width = 1,
                                                              height = 0.25)) +
      ggplot2::scale_fill_manual(values = c("0" = "red","1" = "green")) +
      ggplot2::theme(legend.position = "none") 
  }
}
