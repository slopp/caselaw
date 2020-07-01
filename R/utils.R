compact <- function (x){
  empty <- vapply(x, is_empty, logical(1))
  x[!empty]
}


is_empty <- function(x) {length(x) == 0}
