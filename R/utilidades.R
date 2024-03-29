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

#' Function used to fill NAs in the possesions sections in pbp
#'
#' @param tabla Tabla que recibe
#' @param columna Columna a llenar los NAs
#'
#' @return
#' @export
#'
#' @examples fill_nas(table, 'numero_jugada')
fill_nas <- function(table, column){

  table[, (column) := get(column)[1], cumsum(!is.na(get(column)))]

  primer_no_na <- table[!is.na(get(column))][[column]][1]

  table[is.na(get(column)), (column) := primer_no_na]
}

#' Function to download pdfs of World Championships in the new IHF site
#'
#' @param link Site were we want to download the pdfs
#' @param folder Folder were the pdfs will be downloaded
#' @param from_archive Whether the pdfs are in the archive.ihf.info site
#'
#' @return
#' @export
#'
#' @examples scrape_from_ihf(link = 'https://www.ihf.info/competitions/men/308/27th-ihf-men039s-world-championship-2021/22415/match-center/23765', carpeta = 'matches')
scrape_from_ihf <- function(link, folder, from_archive = FALSE){
  link %>%
    xml2::read_html() %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href") %>%
    stringr::str_subset("\\.pdf|\\.PDF") %>%
    purrr::map_if(.f = ~ paste0('https://archive.ihf.info', .),
                  .p = rep(from_archive, length(.)) == rep(TRUE, length(.))) %>%
    unlist() %>%
    as.character() %>%
    purrr::walk2(., paste0(folder,'/', basename(.) %>%
                             stringr::str_remove('[?=].*')),
                 download.file, mode = "wb")
}

#' Assign a band to the values of a numerical column
#'
#' @param data Table to add band
#' @param minutes_column Name of the numerical column.
#' @param band_cuts Numerical vector specifying the cuts of the bands.
#' @param bands_column_name Name of the column to be created.
#' @param number_bands Whether or not to add numbering to the bands.
#'
#' @return
#' @export
#'
#' @examples
#'\dontrun{
#' add_bands(data, "minutes",
#' c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60))
#'}
add_bands <- function(data,
                      minutes_column,
                      band_cuts = c(0, 1, 5, 10, 25, 50, 100, 150, 200, 300, 500, 750, 1000, 1500, 2000),
                      bands_column_name = 'minutes_band',
                      truncate_in_data_max = FALSE,
                      number_bands = FALSE) {

  if(!(minutes_column %chin% colnames(data))){
    stop('Column ', minutes_column, ' not in data. ')
  }

  # create empty column
  data.table::setDT(data)
  data[, (bands_column_name) := NA_character_]

  # index for the bands
  run <- seq_along(band_cuts)
  if(truncate_in_data_max){
    band_cuts <- c(band_cuts, max(data[[minutes_column]], na.rm = TRUE) + 1)  |>
      unique() |>
      sort()
  }else{
    band_cuts <- band_cuts |>
      unique() |>
      sort()
  }
  band_length <- length(band_cuts)

  # Nice names for bands
  band_names <- paste0(if(number_bands){paste0(fifelse(1:(band_length-1) > 9, '', '0'), run, '. ')},
                       '[',band_cuts[-band_length], '-', band_cuts[-1], ']')

  # assign band to each value
  purrr::walk(run, ~ data.table::set(data,
                                     which(band_cuts[.x] <= data[[minutes_column]] & data[[minutes_column]] < band_cuts[.x + 1]),
                                     bands_column_name,
                                     band_names[.x])[])

  data[, (bands_column_name) := factor(x = get(bands_column_name), levels = band_names)]
}

