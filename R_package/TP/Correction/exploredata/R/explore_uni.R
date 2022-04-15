#' Univariate variable representation
#'
#' @param x : variable to show
#' @param ... : option to developp...!
#'
#' @return a \code{ggplot2} object
#'
#' @export
#'
#' @examples
#'
#' data("exploredata_ex")
#' explore_uni(exploredata_ex$value)
#' explore_uni(exploredata_ex$group)
#'
#' @rdname explore_uni
explore_uni <- function (x, ...) {
  UseMethod("explore_uni", x)
}

#' @rdname explore_uni
#' @export
explore_uni.character <- function(x, ...){
  .explore_uni_quali(x)
}

#' @rdname explore_uni
#' @export
explore_uni.factor <- function(x, ...){
  .explore_uni_quali(x)
}

#' @rdname explore_uni
#' @export
explore_uni.numeric <- function(x, ...){
  .explore_uni_quanti(x)
}

#' @rdname explore_uni
#' @export
explore_uni.integer <- function(x, ...){
  .explore_uni_quanti(x)
}

#' @rdname explore_uni
#' @export
explore_uni.logical <- function(x, ...){
  .explore_uni_quali(x)
}

#' Quantitative variable representation
#'
#' @param x : \code{numeric/vector}, variable to show
#'
#' @return a \code{ggplot2} object
#'
#'
#' @import ggplot2
#'
.explore_uni_quanti <- function(x){


  stopifnot(any(class(x) %in% c("numeric", "integer")))

  ggplot2::ggplot() +
    ggplot2::aes(x = "", y = x) +
    ggplot2::geom_violin(adjust = 0.4, scale = "area", fill = "#08519c") +
    ggplot2::theme_minimal()
}


#' Qualitative variable representation
#'
#' @param x :\code{character/vector}, variable to show
#'
#' @return a \code{ggplot2} object
#'
#'
#' @import ggplot2
#'
.explore_uni_quali <- function(x){

  if(!any(class(x) %in% c("character", "factor"))){
    stop("x must be a character/factor vector")
  }

  ggplot2::ggplot() +
    ggplot2::aes(x = x) +
    ggplot2::geom_bar(fill = "#0c4c8a") +
    ggplot2::theme_minimal()
}
