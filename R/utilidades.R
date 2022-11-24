#' Dibujar un círculo.
#' Tomado de: http://stackoverflow.com/questions/6862742/draw-a-circle-with-ggplot2
#' @param center Centro del círculo
#' @param diameter Diámetro del círculo
#' @param npoints  Cantidad de puntos dibujados
#' @param start Inicio del círculo (Va de 0 a 2pi)
#' @param end Fin del círculo (Va de 0 a 2pi)
#'
#' @examples
#' \dontrun{
#' draw_circle(center = c(0, 0), diameter = 1, npoints = 12000,
#' start = 0, end = 2)
#' }
draw_circle <- function(center = c(0, 0), diameter = 1, npoints = 12000, start = 0, end = 2){

  tt <- seq(start*pi, end*pi, length.out = npoints)

  data.table::data.table(x = center[1] + diameter / 2 * cos(tt),
                         y = center[2] + diameter / 2 * sin(tt))

}


#' Calcula la distancia a gol desde unas coordenadas en handbaloner::court()
#'
#' Toma el centro del campo como las coordenadas (0, 0) y calcula la distancia
#' a gol desde un punto en específico. El cálculo se toma desde el punto al gol
#' más cercano, es decir, desde el propio campo. Un tiro del campo contrario no
#' lo calculará correctamente.
#' @param shot_coordinates Coordenadas del tiro (centro del campo en (0,0))
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' distance_to_goal(shot_coordinates = c(-10, -3))
#' }
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

