#' @method qread tsv
#' @export
qread.tsv <- function(file, type, check.names=FALSE, quote="\"", ...) {
	read.table(file, header=TRUE, sep="\t", quote=quote, check.names=check.names, ...)
}

#' @method qwrite tsv
#' @export
qwrite.tsv <- function(x, file, type, quote=FALSE, ...) {
	write.table(x, file,
		quote=quote, sep="\t", row.names=FALSE, col.names=TRUE, ...)
}
