#' Converts the play by play sheet from the IFH site to a tidy table
#'
#' @param input Path of the Play by Play PDF file
#' @param two_min How the 2 minutes suspension is described
#' @param columns_in_spanish By default, the language is english. If TRUE, the colnames will be in spanish
#'
#' @return Una data.table with the play by play of the game in tidy format (one observation per row)
#' @export
#'
#' @examples generate_tidy_pbp('01pbp.pdf')
generate_tidy_pbp <- function(input, two_min = '2-minutes suspension',
                              match_id_pattern = 'Match No: ',
                              differentiate_gender = FALSE,
                              columns_in_spanish = FALSE,
                              gender = "M"){ # or "W"
  texto <- pdftools::pdf_text(input) %>%
    readr::read_lines()

  if (differentiate_gender) {
    gender <- data.table::fifelse(any(
      stringr::str_extract(texto,
                           "Masculino|Femenino") == "Masculino") == TRUE ,
      "M",
      "W")

  }

  numero_partido_ext <- texto[stringr::str_detect(texto, match_id_pattern)][1] %>%
    stringr::str_extract(paste0(match_id_pattern, '\\d+'))  %>% # Esto es para asegurarnos que verdaderamente saquemos el número del partido y no otras cosas.
    stringr::str_extract('\\d+') %>%
    as.numeric()
  # 1.1 - Limpieza de jugadores ---------------------------------------------


  tables <- tabulizer::extract_tables(input, method = 'stream')


  equipos <- purrr::keep(tables, ~ .x[2,1] == '') %>%
    data.table::as.data.table()

  nombres_equipos <- unique(equipos$V1[equipos$V1 != ''])

  pbp <-  purrr::keep(tables, ~ .x[2,1] != '') %>%
    purrr::map(~data.table::as.data.table(.x))

  pbp_limpio <- pbp %>%
    purrr::keep(~ .x[2, V4] == 'Score')

  if(length(pbp_limpio) != 0){
    pbp_limpio <- pbp_limpio %>%
      purrr::map_if( ~ ncol(.) == 6, ~.[, V7 := '']) %>%
      purrr::map_if(~ ncol(.) == 8, ~ .[, V7 := paste0(V7, V8)]) %>%
      purrr::map_df(~ .x[,1:7]) %>%
      data.table::setnames(colnames(.), c('tiempo', 'numero_casa',
                                          'accion_casa', 'marcador',
                                          'ventaja_casa', 'numero_visita',
                                          'accion_visita'))

  }else{
    pbp_limpio <- NULL
  }

  pbp_sucio <- NULL
  pbp_sucio1 <- NULL
  pbp_sucio2 <- NULL


  if(length(pbp %>%
            purrr::keep(~ .x[2, V4] == 'Score')) != length(pbp)){

    pbp_sucio <- pbp %>%
      purrr::keep(~ .x[2, V4] != 'Score')

    pbp_sucio1 <- pbp_sucio %>%
      purrr::keep(~length(.x) == 9)

    if(length(pbp_sucio1) != 0){
      pbp_sucio1 <- pbp_sucio1 %>%
        purrr::walk(~ .x[, V4 := NULL][, V9 := NULL]) %>%
        data.table::rbindlist() %>%
        data.table::setnames(colnames(.), c('tiempo', 'numero_casa',
                                            'accion_casa', 'marcador',
                                            'ventaja_casa', 'numero_visita',
                                            'accion_visita'))

    }else{
      pbp_sucio1 <- NULL
    }

    pbp_sucio2 <- pbp_sucio %>%
      purrr::keep(~ length(.x) == 8)

    if(length(pbp_sucio2) != 0){
      pbp_sucio2 <- pbp_sucio2 %>%
        purrr::walk(~ .x[, V3 := paste0(V3,V4)][, V4 := NULL]) %>%
        purrr::map_df(~ .x[,1:7]) %>%
        data.table::setnames(colnames(.), c('tiempo', 'numero_casa',
                                            'accion_casa', 'marcador',
                                            'ventaja_casa', 'numero_visita',
                                            'accion_visita'))

    }else{
      pbp_sucio2 <- NULL
    }
  }


  pbp <- data.table::rbindlist(list(pbp_limpio, pbp_sucio1, pbp_sucio2))



  # Agregar si 1ero o 2do tiempo o tiempos extra

  pbp[tiempo < '59:59' & (stringr::str_detect(accion_casa, 'Goalkeeper') | stringr::str_detect(accion_visita, 'Goalkeeper')) &
                            !stringr::str_detect(accion_casa, 'for') & !stringr::str_detect(accion_visita, 'for'),
      mitad := data.table::fifelse(tiempo == '0:00', 1, 2)]

  pbp[(stringr::str_detect(accion_casa, 'Goalkeeper') | stringr::str_detect(accion_visita, 'Goalkeeper')) &
        !stringr::str_detect(accion_casa, 'for') & !stringr::str_detect(accion_visita, 'for') & tiempo == '60:00',
      mitad := 3]

  pbp[(stringr::str_detect(accion_casa, 'Goalkeeper') | stringr::str_detect(accion_visita, 'Goalkeeper')) &
        !stringr::str_detect(accion_casa, 'for') & !stringr::str_detect(accion_visita, 'for') & tiempo == '70:00',
      mitad := 4]


  pbp[, tiempo_numerico := as.numeric(lubridate::ms(tiempo))]
  pbp <- pbp[order(tiempo_numerico)]
  pbp[, mitad := mitad[1L], cumsum(!is.na(mitad))]


  equipos[, V1 := V1[1L] , cumsum(V1 != '')]

  data.table::rbindlist(list(equipos[,.(V1, V2, V4, V6, V8)],
                             equipos[,.(V1, V3, V5, V7, V9)]))

  tidy_equipo <- data.table::melt(equipos, id.vars = c('V1'),
                                  measure.vars = c('V2', 'V4', 'V6', 'V8'),
                                  value.name = 'numero',
                                  variable.name = 'columna_numero' ) %>%
    cbind(data.table::melt(equipos, id.vars = c('V1'),
                           measure.vars = c('V3', 'V5', 'V7', 'V9'),
                           value.name = 'nombre',
                           variable.name = 'columna_jugador' ))

  tidy_equipo[, V1 := NULL]
  tidy_equipo[, columna_numero := NULL]
  tidy_equipo[, columna_jugador := NULL]
  tidy_equipo <- tidy_equipo[numero != '']

  colnames(tidy_equipo) <- c('numero', 'equipo', 'nombre')
  data.table::setcolorder(tidy_equipo, c('equipo', 'numero', 'nombre'))

  cuerpo_tecnico <- tidy_equipo[numero %in% LETTERS][order(equipo, numero)]
  jugadores <- tidy_equipo[!numero %in% LETTERS][order(equipo, numero)]

  jugadores[, nombre_planilla := stringr::str_remove_all(nombre, '[a-z]')]

  # 1.1 - Limpieza de PBP ------------------------------------------------
  # Primero lo hacemos solamente para casa. Para visita es exactamente lo mismo
  #data.table::setnames(pbp, paste0('V', 1:7), c('tiempo', 'numero_casa', 'accion_casa', 'marcador', 'ventaja_casa', 'numero_visita', 'accion_visita'))

  pbpv <- pbp[, .(tiempo, numero = numero_visita, accion = accion_visita, mitad)]
  pbpc <- pbp[, .(tiempo, numero = numero_casa, accion = accion_casa, mitad)]

  func_tidy_pbp_por_equipo <- function(tabla,  casa = TRUE, nombre_equipo, numero_partido = numero_partido_ext){

    tabla[stringr::str_detect(tiempo, '0:00|30:00') & stringr::str_detect(accion, 'Goalkeeper')]
    tabla[, accion := stringr::str_squish(accion)]

    tabla <- tabla[stringr::str_detect(tiempo, '\\d')]


    tabla[stringr::str_detect(tiempo, '0:00') & stringr::str_detect(accion, 'Goalkeeper'), portero := numero]
    tabla[stringr::str_detect(tiempo, '30:00') & stringr::str_detect(accion, 'Goalkeeper'), portero := numero]
    tabla[stringr::str_detect(tiempo, '60:00') & stringr::str_detect(accion, 'Goalkeeper'), portero := numero]
    tabla[stringr::str_detect(tiempo, '70:00') & stringr::str_detect(accion, 'Goalkeeper'), portero := numero]

    tabla[stringr::str_detect(accion, 'Empty goal'), portero := 'Empty goal']
    tabla[stringr::str_detect(accion, 'Goalkeeper back'), portero := numero]
    tabla[, portero := portero[1L], cumsum(!is.na(portero))]


    # Describe Goals

    tabla[stringr::str_detect(accion, '\\bGoal\\b'),
          ':='(asistencia_numero = stringr::str_extract(accion, '\\(([^)]+)\\)') %>%
                 stringr::str_extract('\\d+'),
               gol_numero = numero,
               tipo_de_gol = stringr::str_trim(stringr::str_remove(accion, '\\(([^)]+)\\)')))]

    # Describe shots (not Goals)

    tabla[stringr::str_detect(accion, '\\bShot\\b|Penalty shot') &
            stringr::str_detect(accion, 'Goal', negate = TRUE) ,
          ':='(tiro_numero = numero,
               tipo_de_tiro = stringr::str_remove(accion, # Quizás se necesita un str_remove_all
                                                  paste0(jugadores$nombre_planilla, collapse = '|')))]

    desc_tiros <- handbaloner::descripcion_tiros

    tabla[, posicion_marco := stringr::str_extract(accion,
                                                   paste0(desc_tiros$posicion_marco[desc_tiros$posicion_marco != ''], collapse = '|'))]
    tabla[, posicion_tiro := stringr::str_extract(accion,
                                                  paste0(desc_tiros$posicion_tiro[desc_tiros$posicion_tiro != ''], collapse = '|'))]

    tabla[stringr::str_detect(accion, 'post'), post := 1]
    tabla[stringr::str_detect(accion, 'saved'), saved := 1]
    tabla[!is.na(tipo_de_gol), gol := 1]
    tabla[, gol := as.numeric(gol)]

    tabla[, ':='(posicion_marco_vertical = stringr::str_extract(posicion_marco,
                                                                'bottom|top|middle'),
                 posicion_marco_horizontal = stringr::str_extract(posicion_marco,
                                                                  'left|centre|right'))]


    tabla[stringr::str_detect(accion, '7m caused'), numero_causa_7m := numero]
    tabla[stringr::str_detect(accion, '7m received'), numero_recibe_7m := numero]


    tabla[stringr::str_detect(accion, 'Turnover'), turnover := numero]
    tabla[stringr::str_detect(accion, 'Steal'), robo := numero]
    tabla[stringr::str_detect(accion, 'Technical'), falta_tecnica := numero]
    tabla[stringr::str_detect(accion, two_min), suspension := numero]



    tabla[, tiempo_numerico := as.numeric(lubridate::ms(tiempo))]
    tabla[, es_casa := casa]
    tabla[, equipo := nombre_equipo]
    tabla[, id := numero_partido]


    tabla[, cantidad_jugadores_campo := 6]


    tabla[!is.na(suspension), inicia_suspension := tiempo_numerico]
    tabla[!is.na(suspension), termina_suspension := tiempo_numerico + 120]

    tabla[, no_jugada := 1:.N]
    if(nrow(tabla[!is.na(suspension)]) != 0){ # Hay equipos que no tienen suspensiones de 2 minutos en el partido

      auxiliar <- tabla[tabla, .(list(no_jugada)), on = .(tiempo_numerico > inicia_suspension, tiempo_numerico <= termina_suspension), by = .EACHI]

      cantidad_jugadores_menos <- (auxiliar[!is.na(V1)]$V1 %>% unlist() %>% data.table::data.table(no_jugada = .))[,.N,no_jugada]

      tabla[cantidad_jugadores_menos, cantidad_suspendidos := -i.N, on = 'no_jugada']
      tabla[is.na(cantidad_suspendidos), cantidad_suspendidos := 0]
    }else{
      tabla[, cantidad_suspendidos := 0]
    }
    tabla[, sin_portero := as.numeric(portero == 'Empty goal')]

    tabla[, cantidad_jugadores_campo_real := cantidad_jugadores_campo + cantidad_suspendidos + sin_portero]
    tabla[, cantidad_maxima_jugadores := cantidad_jugadores_campo + cantidad_suspendidos]
    tabla[, cantidad_jugadores_campo_real := pmin(cantidad_jugadores_campo_real, (cantidad_maxima_jugadores + 1))]
    tabla <- tabla[order(tiempo_numerico)]

    tabla[,cantidad_jugadores_campo := NULL]
    tabla[,cantidad_maxima_jugadores := NULL]
    return(tabla[])

  }

  casa <- func_tidy_pbp_por_equipo(tabla = pbpc, casa = TRUE, nombre_equipo = nombres_equipos[1])
  visita <- func_tidy_pbp_por_equipo(tabla = pbpv, casa = FALSE, nombre_equipo = nombres_equipos[2])

  casa[is.na(gol), gol := 0]
  visita[is.na(gol), gol := 0]


  casa[visita, portero_rival := i.portero, on = 'no_jugada']
  visita[casa, portero_rival := i.portero, on = 'no_jugada']

  casa[, acumulada_goles_casa := cumsum(gol)]
  visita[, acumulada_goles_visita := cumsum(gol)]

  casa[, acumulada_goles_visita := visita$acumulada_goles_visita]
  visita[, acumulada_goles_casa := casa$acumulada_goles_casa]

  casa[, marcador := paste(acumulada_goles_casa, acumulada_goles_visita, sep = ' - ')]
  visita[, marcador := paste(acumulada_goles_casa, acumulada_goles_visita, sep = ' - ')]


  final <- rbind(casa, visita)
  final[, diferencia := eval(parse(text = marcador)), 1:nrow(final)]

  final[, velocidad_tiro := as.numeric(stringr::str_extract(stringr::str_extract(accion, '\\d{1,3} km/h$'), '\\d{1,3}'))]
  final[is.na(gol), gol := 0]


  final <- final[order(mitad, tiempo_numerico, marcador)]

  final[, linea := 1:.N]

  pos <- final

  posible_cambio_posesion <- c('\\bGoal\\b', 'Technical', 'Turnover', 'missed', 'Shot', 'Steal', 'Block','saved')

  posible_cambio_posesion_para_secuencias <- c('\\bGoal\\b', 'Technical', 'Turnover', 'missed', 'Shot', 'saved')

  la_tiene <- c('\\bGoal\\b', 'Technical', 'Turnover', 'missed', 'Shot', '7m received', 'Team timeout', 'saved')

  no_la_tiene <- c('Steal', 'Block', '7m caused')


  pos[, lt := as.numeric(stringr::str_detect(accion, paste0(la_tiene, collapse = '|')))]

  pos[, nlt := as.numeric(stringr::str_detect(accion, paste0(no_la_tiene, collapse = '|')))]



  pos <- pos[accion != ''
  ][tiempo_numerico != 0
  ][!(tiempo_numerico == 1800 & stringr::str_detect(accion, 'Goalkeeper'))
  ][!(tiempo_numerico == 3600 & stringr::str_detect(accion, 'Goalkeeper'))
  ][!(tiempo_numerico == 4200 & stringr::str_detect(accion, 'Goalkeeper'))]



  equipos <- unique(pos$equipo)



  pos[, posesion := data.table::fifelse(lt == 1, equipo, setdiff(equipos, equipo)), 1:nrow(pos)]

  pos[lt == 0 & nlt == 0, posesion := NA]

  pos <- pos[!is.na(posesion)]

  pos[, numero_de_posesion := data.table::rleid(posesion, mitad)]


  pos[, fin_posesion := data.table::last(tiempo), .(posesion, numero_de_posesion)]

  pos[, numero_posesion_anterior := numero_de_posesion - 1]

  aux <- unique(pos, by = c('numero_de_posesion', 'fin_posesion'))


  pos[aux[aux, .(numero_de_posesion, inicio_posesion = fin_posesion),
          on = .(numero_de_posesion == numero_posesion_anterior)]
      , inicio_posesion := i.inicio_posesion, on = 'numero_de_posesion']


  pos[numero_de_posesion == 1, inicio_posesion := '0:00']
  pos[mitad == 1, fin_posesion := replace(fin_posesion, .N, '30:00')]

  numero_de_primera_posesion_segundo_tiempo <- pos[mitad == 2][1]$numero_de_posesion

  pos[numero_de_posesion == numero_de_primera_posesion_segundo_tiempo,
      inicio_posesion := '30:00']

  numero_de_primera_posesion_tercer_tiempo <- pos[mitad == 3][1]$numero_de_posesion

  pos[numero_de_posesion == numero_de_primera_posesion_tercer_tiempo,
      inicio_posesion := '60:00']

  numero_de_primera_posesion_cuarto_tiempo <- pos[mitad == 4][1]$numero_de_posesion

  pos[numero_de_posesion == numero_de_primera_posesion_cuarto_tiempo,
      inicio_posesion := '70:00']

  pos[, maxima_posesion_mitad := max(numero_de_posesion), mitad]

  pos[numero_de_posesion == maxima_posesion_mitad, fin_posesion :=
        data.table::fcase(mitad == 1, '30:00',
                          mitad == 2, '60:00',
                          mitad == 3, '70:00',
                          mitad == 4, '80:00')]

  # pos[numero_de_posesion == max(numero_de_posesion), fin_posesion :=
  #       data.table::fcase(max(mitad) == 2,'60:00',
  #                         max(mitad) == 3, '70:00',
  #                         max(mitad) == 4, '80:00')]

  pos[, c('lt', 'nlt', 'numero_posesion_anterior') := NULL]

  data.table::setcolorder(pos, colnames(pos)[c(1:8, 10, 9)])


  pos <- pos[,.(linea, posesion, numero_de_posesion, inicio_posesion, fin_posesion)]


  listo <- data.table::merge.data.table(final, pos, all.x = TRUE, by = 'linea')

  listo[, numero_de_posesion_preliminar := numero_de_posesion]

  primera_mitad <- listo[mitad == 1]
  segunda_mitad <- listo[mitad == 2]
  tercera_mitad <- listo[mitad == 3]
  cuarta_mitad <- listo[mitad == 4]

  purrr::walk(c('posesion', 'numero_de_posesion', 'inicio_posesion', 'fin_posesion'), ~ fill_nas(primera_mitad, .x))
  purrr::walk(c('posesion', 'numero_de_posesion', 'inicio_posesion', 'fin_posesion'), ~ fill_nas(segunda_mitad, .x))
  purrr::walk(c('posesion', 'numero_de_posesion', 'inicio_posesion', 'fin_posesion'), ~ fill_nas(tercera_mitad, .x))
  purrr::walk(c('posesion', 'numero_de_posesion', 'inicio_posesion', 'fin_posesion'), ~ fill_nas(cuarta_mitad, .x))

  listo <- rbind(primera_mitad, segunda_mitad, tercera_mitad, cuarta_mitad)

  # Quitar la información de posesiones en la información de quién es el portero

  listo[stringr::str_detect(tiempo, '0:00') & stringr::str_detect(accion, 'Goalkeeper'),
        ':='(inicio_posesion = NA, fin_posesion = NA,
             sin_portero = NA, cantidad_jugadores_campo_real = NA)]
  listo[stringr::str_detect(tiempo, '30:00') & stringr::str_detect(accion, 'Goalkeeper'),
        ':='(inicio_posesion = NA, fin_posesion = NA,
             sin_portero = NA, cantidad_jugadores_campo_real = NA)]

  listo[stringr::str_detect(tiempo, '60:00') & stringr::str_detect(accion, 'Goalkeeper'),
        ':='(inicio_posesion = NA, fin_posesion = NA,
             sin_portero = NA, cantidad_jugadores_campo_real = NA)]

  listo[stringr::str_detect(tiempo, '70:00') & stringr::str_detect(accion, 'Goalkeeper'),
        ':='(inicio_posesion = NA, fin_posesion = NA,
             sin_portero = NA, cantidad_jugadores_campo_real = NA)]

  resumen_equipos <- listo[,.N,.(equipo, es_casa)]

  equipo_casa <- resumen_equipos[es_casa == TRUE]$equipo
  equipo_visita <- resumen_equipos[es_casa == FALSE]$equipo

  listo[, equipos := paste(equipo_casa, equipo_visita, sep = " - ")]

  listo[, duracion_posesion := as.numeric(lubridate::ms(fin_posesion)) -
         as.numeric(lubridate::ms(inicio_posesion))]

  listo[, genero := gender]

  listo <- listo[accion != '', .(id_partido = id, equipos, genero, tiempo, tiempo_numerico, mitad, accion, numero, equipo,
                                 portero, portero_rival, asistencia_numero, gol_numero,
                                 tiro_numero, gol, velocidad_tiro, posicion_marco, posicion_tiro, post, saved,
                                 posicion_marco_vertical, posicion_marco_horizontal, numero_causa_7m,
                                 numero_recibe_7m, turnover, falta_tecnica, robo, suspension, es_casa, cantidad_suspendidos,
                                 sin_portero, cantidad_jugadores_campo = cantidad_jugadores_campo_real, posesion,
                                 numero_posesion = numero_de_posesion, inicio_posesion, fin_posesion, marcador, diferencia, duracion_posesion)]

  if(!columns_in_spanish) {

    colnames(listo) <- c("match_id", "teams", "gender","time", "numeric_time", "half", "action",
                         "number",  "team", "goalkeeper", "opponent_goalkeeper",
                         "assist_number", "goal_number", "shot_number", "goal",
                         "shot_speed", "in_goal_position", "shot_position",
                         "post", "saved", "vertical_goal_position",
                        "horizontal_goal_position", "causes_7m_number",
                        "receives_7m_number", "turnover", "technical_foul",
                        "steal", "suspension", "is_home",  "number_suspended",
                        "no_goalkeeper", "number_court_players", "possession",
                        "number_of_possession", "start_of_possession",
                        "end_of_possession", "score", "lead", "possession_length")
  }

  return(listo)
}


#' Players and coaches
#'
#' @param input Directory where the pbp is located
#'
#' @return A list with two tables: players and coaches
#' @export
#'
#' @examples players_and_coaches('01pbp.pdf')
players_and_coaches <- function(input, match_id_pattern = 'Match No: ', columns_in_spanish = FALSE){

  texto <- pdftools::pdf_text(input) %>%
    readr::read_lines()

  numero_partido_ext <- texto[stringr::str_detect(texto, match_id_pattern)][1] %>%
    stringr::str_extract(paste0(match_id_pattern,'\\d+'))  %>% # Esto es para asegurarnos que verdaderamente saquemos el número del partido y no otras cosas.
    stringr::str_extract('\\d+') %>%
    as.numeric()
  # 1.1 - Limpieza de jugadores ---------------------------------------------



  tables <- tabulizer::extract_tables(input, method = 'stream')


  equipos <- purrr::keep(tables, ~ .x[2,1] == '') %>%
    data.table::as.data.table()

  nombres_equipos <- unique(equipos$V1[equipos$V1 != ''])

  equipos[, V1 := V1[1L] , cumsum(V1 != '')]

  data.table::rbindlist(list(equipos[,.(V1, V2, V4, V6, V8)], equipos[,.(V1, V3, V5, V7, V9)]))

  tidy_equipo <- data.table::melt(equipos, id.vars = c('V1'),
                                  measure.vars = c('V2', 'V4', 'V6', 'V8'),
                                  value.name = 'numero',
                                  variable.name = 'columna_numero' ) %>%
    cbind(data.table::melt(equipos, id.vars = c('V1'),
                           measure.vars = c('V3', 'V5', 'V7', 'V9'),
                           value.name = 'nombre',
                           variable.name = 'columna_jugador' ))

  tidy_equipo[, V1 := NULL]
  tidy_equipo[, columna_numero := NULL]
  tidy_equipo[, columna_jugador := NULL]
  tidy_equipo <- tidy_equipo[numero != '']

  colnames(tidy_equipo) <- c('numero', 'equipo', 'nombre')
  data.table::setcolorder(tidy_equipo, c('equipo', 'numero', 'nombre'))

  cuerpo_tecnico <- tidy_equipo[numero %in% LETTERS][order(equipo, numero)]
  jugadores <- tidy_equipo[!numero %in% LETTERS][order(equipo, numero)]

  jugadores[, nombre_planilla := stringr::str_remove_all(nombre, '[a-z]')]


  jugadores[, numero_partido := numero_partido_ext]
  cuerpo_tecnico[, numero_partido := numero_partido_ext]

  if(!columns_in_spanish) {
    colnames(jugadores) <- c("team", "number", "name", "name_in_sheet", "game_number")
    colnames(cuerpo_tecnico) <- c("team", "number", "name",  "game_number")
  }

  return(list(jugadores, cuerpo_tecnico))
}
