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
