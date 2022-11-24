#' Creación del campo completo
#'
#' @param vertical Si la visualización es vertical u horizontal
#' @param flip
#' @param court_color
#' @param area_color
#' @param lines_color
#' @return
#' @export
#'
#' @examples
court <- function(vertical = FALSE, flip = FALSE, court_color = '#1871c9',
                    area_color = '#d1b111', lines_color = 'white'){
    lines <- handbaloner::lines_generator()
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
      ggplot2::coord_fixed() + # We want to maintain the 40x20 proportion
      ggplot2::theme_void()

    return(plot)
  }



#' Creación de medio campo verticalmente (arriba)
#'
#' @param vertical
#' @param flip
#' @param court_color
#' @param area_color
#' @param lines_color
#'
#' @return
#' @export
#'
#' @examples
half_court <- function(vertical = TRUE, flip = FALSE, court_color = '#1871c9',
                       area_color = '#d1b111', lines_color = 'white'){

  lines <- handbaloner::lines_generator()
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
    ggplot2::coord_fixed() +  # We want to maintain the 40x20 proportion
    ggplot2::theme_void()

  return(plot)
}
