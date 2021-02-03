#' Dibujar un círculo.
#' Tomado de: http://stackoverflow.com/questions/6862742/draw-a-circle-with-ggplot2
#' @param center Centro del círculo
#' @param diameter Diámetro del círculo
#' @param npoints  Cantidad de puntos dibujados
#' @param start Inicio del círculo (Va de 0 a 2pi)
#' @param end Fin del círculo (Va de 0 a 2pi)
#'
#' @return
#' @export
#'
#' @examples
draw_circle <- function(center = c(0, 0), diameter = 1, npoints = 12000, start = 0, end = 2){

  tt <- seq(start*pi, end*pi, length.out = npoints)

  data.table::data.table(x = center[1] + diameter / 2 * cos(tt),
                         y = center[2] + diameter / 2 * sin(tt))

}


#' Calculate the distance to goal in any point of a handbaloner::court()
#'
#' @param shot_coordinates
#'
#' @return
#' @export
#'
#' @examples
distance_to_goal <- function(shot_coordinates){

  x <- shot_coordinates[1]
  y <- shot_coordinates[2]
  starting_point <- as.numeric(unlist(strsplit(data.table::fcase(x > 0 & y < -1.5, paste(20, -1.5),
                                                                 x > 0 & y > 1.5, paste(20, 1.5),
                                                                 x < 0 & y < -1.5, paste(-20, -1.5),
                                                                 x < 0 & y > 1.5, paste(-20, 1.5),
                                                                 x > 0 & data.table::between(y, -1.5, 1.5), paste(20, y),
                                                                 x < 0 & data.table::between(y, -1.5, 1.5), paste(-20, y)),' ')))

  sqrt(sum((starting_point - shot_coordinates) ^ 2))
}

