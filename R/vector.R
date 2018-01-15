#' @method qread numeric
#' @export
qread.vector <- function(
	file, type, class=NA, ...
) {
	x <- readLines(file, ...);

	if (is.na(class)) {
		# set as.is=TRUE to disable character to factor conversion
		utils::type.convert(x, as.is=TRUE, ...)
	} else if (class == "numeric") {
		as.numeric(x)
	} else if (class == "integer") {
		as.integer(x)
	} else if (class == "logical") {
		as.logical(x)
	} else if (class == "complex") {
		as.complex(x)
	}
}

#' @method qwrite numeric
#' @export
qwrite.numeric <- qwrite.character <- qwrite.vector <- function(
	x, file, type, column=1, ...
) {
	# Select column of matrix or data.frame if x is either of these types
	if (!is.null(ncol(x))) {
		x <- x[,column];
	}
	# Verify that x is now a vector
	if (!is.vector(x)) {
		stop("`x` must be a vector, matrix, data.frame, or a column-subsettable data type")
	}
	write.table(x, file, quote=FALSE, row.names=FALSE, col.names=FALSE)
}

#' @method qread vtr
#' @export
qread.vtr <- function(file, type, ...) {
	qread.vector(file, ...)
}

#' @method qwrite vtr
#' @export
qwrite.vtr <- function(x, file, type, ...) {
	qwrite.vector(x, file)
}

#' @method qread numeric
#' @export
qread.numeric <- function(file, type, class="numeric", ...) {
	qread.vector(file, type, class=class, ...)
}

#' @method qwrite numeric
#' @export
qwrite.numeric <- qwrite.vector;

#' @method qread integer
#' @export
qread.integer <- qread.vector;

#' @method qwrite integer
#' @export
qwrite.integer <- qwrite.vector;

#' @method qread single
#' @export
qread.single <- qread.vector;

#' @method qwrite single
#' @export
qwrite.single <- qwrite.vector;

#' @method qread double
#' @export
qread.double <- qread.vector;

#' @method qwrite double
#' @export
qwrite.double <- qwrite.vector;

#' @method qread character
#' @export
qread.character <- function(file, type, class="character", ...) {
	qread.vector(file, type, class=class, ...)
}

#' @method qwrite character
#' @export
qwrite.character <- qwrite.vector;

