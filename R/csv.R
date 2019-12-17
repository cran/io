#' @method qread csv
#' @export
qread.csv <- function(file, type, check.names=FALSE, quote="\"", ...) {
	read.table(file, header=TRUE, sep=",", quote=quote, check.names=check.names, ...)
}

#' @method qwrite csv
#' @export
qwrite.csv <- function(x, file, type, quote=TRUE, ...) {
	write.table(x, file,
		quote=quote, sep=",", row.names=FALSE, col.names=TRUE, ...)
}
