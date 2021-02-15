xg_egipto21 <- data.table::fread('xg_egipto21.csv')
data.table::setkey(xg_egipto21, posicion_tiro)

usethis::use_data(xg_egipto21, xg_egipto21, overwrite = TRUE)

#' Prices of 50,000 round cut diamonds.
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{posicion_tiro}{Position of the shot}
#'   \item{xg}{Expected Goals}
#'   \item{cantidad_tiros}{Number of shot in this position in this zone}
#'   ...
#' }
#' @source \url{'https://raw.githubusercontent.com/telaroz/egipto21/main/partidos_pbp_egipto2021.csv'}
"xg_egipto21"
