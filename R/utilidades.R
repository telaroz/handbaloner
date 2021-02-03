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
