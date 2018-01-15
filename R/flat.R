#' @method qread flat
#' @export
qread.flat <- function(file, type, header=FALSE, check.names=FALSE, quote="\"", ...) {
	read.table(file, header=header, sep="", quote=quote, check.names=check.names, ...)
}

# TODO Onus is on the user to ensure fields do not contain spaces!
#      There is no option to quote only space containing values
#' @method qwrite flat
#' @export
qwrite.flat <- function(x, file, type, header=FALSE, quote=FALSE, ...) {
	write.table(x, file,
		quote=quote, sep=" ", row.names=FALSE, col.names=header, ...)
}
