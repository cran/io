#' @method qread matrix
#' @export
qread.matrix <- function(
	file, type, header=TRUE, sep="\t", row.names=1, comment.char="",
	check.names=FALSE, dup.rm=FALSE, ...
) {
	if (dup.rm && !is.null(row.names)) {
		x <- read.table(file,
			header=header, sep=sep, comment.char=comment.char,
			check.names=check.names, ...);
		r <- x[,row.names];
		idx <- !duplicated(r);
		x <- as.matrix(x[idx, 2:ncol(x)]);
		rownames(x) <- r[idx];
		x
	} else {
		as.matrix(read.table(file,
			header=header, sep=sep, row.names=row.names, comment.char=comment.char,
			check.names=check.names, ...))
	}
}

#' @method qwrite matrix
#' @export
qwrite.matrix <- function(
	x, file, type, quote=FALSE, sep="\t", row.names=TRUE, col.names=NA, ...
) {
	write.table(x, file,
		quote=quote, sep=sep, row.names=row.names, col.names=col.names, ...)
}

#' @method qread mtx
#' @export
qread.mtx <- function(file, type, ...) {
	qread.matrix(file)
}

#' @method qwrite mtx
#' @export
qwrite.mtx <- function(x, file, type, ...) {
	qwrite.matrix(x, file)
}
