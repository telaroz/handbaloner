#' Genera las líneas necesarias para los plots
#'
#' @return
#' @export
lines_generator <- function(){
  lines <- list()


  lines$side_and_goal_lines <-
    data.frame(x = c(-20, 20, 20, -20, -20),
               y = c(-10, -10, 10, 10, -10))

  lines$center_line <-
    data.frame(x = c(0, 0),
               y = c(-10, 10))

  lines$goal1 <-
    data.frame(x = c(-20, -20),
               y = c(-1.5, 1.5))

  lines$goal2 <-
    data.frame(x = c(20, 20),
               y = c(-1.5, 1.5))


  lines$front6_1 <-
    data.frame(x = c(-14, -14),
               y = c(-1.5, 1.5))

  lines$front6_2 <-
    data.frame(x = c(14, 14),
               y = c(-1.5, 1.5))


  lines$quart_circle6_1_1 <-
    draw_circle(center = c(-20, -1.5),
                diameter = 12,
                start = 1.5, end = 2)

  lines$quart_circle6_1_2 <-
    draw_circle(center = c(-20, 1.5),
                diameter = 12,
                start = 0, end = 0.5)

  lines$quart_circle6_2_1 <-
    draw_circle(center = c(20, -1.5),
                diameter = 12,
                start = 1, end = 1.5)

  lines$quart_circle6_2_2 <-
    draw_circle(center = c(20, 1.5),
                diameter = 12,
                start = 0.5, end = 1)


  # Both 9m circles will be linked by a straight 3m line

  lines$free_thr9_1_1 <-
    draw_circle(center = c(-20, -1.5),
                diameter = 18,
                start = 1.62, end = 2)

  lines$free_thr9_1_2 <-
    draw_circle(center = c(-20, 1.5),
                diameter = 18,
                start = 0, end = 0.38)

  lines$free_thr_compl1 <- rbind(lines$free_thr9_1_1, lines$free_thr9_1_2)


  # Both 9m circles will be linked by a straight 3m line

  lines$free_thr9_2_1 <-
    draw_circle(center = c(20, -1.5),
                diameter = 18,
                start = 1, end = 1.38)

  lines$free_thr9_2_2 <-
    draw_circle(center = c(20, 1.5),
                diameter = 18,
                start = 0.62, end = 1)

  lines$free_thr_compl2 <- rbind(lines$free_thr9_2_2, lines$free_thr9_2_1)



  lines$goal_restr_1 <-
    data.frame(x = c(-16, -16),
               y = c(-0.075, 0.075))

  lines$goal_restr_2 <-
    data.frame(x = c(16, 16),
               y = c(-0.075, 0.075))

  lines$sevenm_1 <-
    data.frame(x = c(-13, -13),
               y = c(-0.5, 0.5))

  lines$sevenm_2 <-
    data.frame(x = c(13, 13),
               y = c(-0.5, 0.5))

  lines$substitution_1 <-
    data.frame(x = c(-4.5, -4.5),
               y = c(-10.15, -9.85))

  lines$substitution_2 <-
    data.frame(x = c(4.5, 4.5),
               y = c(-10.15, -9.85))

  lines$side_and_goal_lines_half <-
    data.frame(x = c(5, 20, 20, 5, 5),
               y = c(-10, -10, 10, 10, -10))

  lines$six_m1 <- rbind(lines$quart_circle6_1_1, lines$quart_circle6_1_2)

  lines$six_m2 <- rbind(lines$quart_circle6_2_1, lines$quart_circle6_2_2)


  return(lines)
}
