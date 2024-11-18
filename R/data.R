xg_egipto21 <- data.table::fread('xg_egipto21.csv')
data.table::setkey(xg_egipto21, posicion_tiro)

usethis::use_data(xg_egipto21, xg_egipto21, overwrite = TRUE)

#' Expected goals from the complete egypt 2021 men's world championship
#'
#'
#' @format A data frame with 12 rows and 3 variables:
#' \describe{
#'   \item{posicion_tiro}{Position of the shot}
#'   \item{xg}{Expected Goals}
#'   \item{cantidad_tiros}{Number of shot in this position in this zone}
#'   ...
#' }
#' @source \url{'https://raw.githubusercontent.com/telaroz/egipto21/main/partidos_pbp_egipto2021.csv'}
"xg_egipto21"


#' Complete names
#'
#'
#' @format A data frame with 32 rows and 2 variables:
#' \describe{
#'   \item{team}{Short Name}
#'   \item{complete_name}{Complete Name}
#'   ...
#' }
"complete_team_names"
complete_team_names <-
  data.table::setDT(countrycode::codelist)[,.(country = country.name.en, country.name.de, country.name.fr,lower_ggflag = iso2c, team = ioc, flag = unicode.symbol)
  ][, lower_ggflag := tolower(lower_ggflag)]

usethis::use_data(complete_team_names, complete_team_names, overwrite = TRUE)


in_goal_position_centroid <- data.table::data.table(in_goal_position = c("blocked", "bottom centre", 
"bottom left", "bottom right", "middle centre", "middle left", 
"middle right", "missed", "post", "top centre", "top left", "top right"),
 x = c(1.85, 0, -1.125, 1.125, 0, -1.125, 1.125, 0, -1.85, 
0, -1.125, 1.125), 
y = c(0, -0.75, -0.75, -0.75, 0, 0, 0, 1.35, 
0, 0.75, 0.75, 0.75))


in_court_position <- data.table::data.table(shot_position = c("Penalty", "breakthrough", "fast break", 
"empty goal", "centre 6m", "centre 9m", "left 6m", "left 9m", 
"left wing", "right 6m", "right 9m", "right wing"), 
x = c(0, 7.5, -7.5, 0, 0, 0, -5.5, -6, -8.7, 5.5, 6, 8.7),
y = c(12.6, 6, 6, 6, 13.5, 9.5, 14.3, 11, 19, 14.3, 11, 19))

usethis::use_data(in_goal_position_centroid, in_goal_position_centroid, overwrite = TRUE)
usethis::use_data(in_court_position, in_court_position, overwrite = TRUE)