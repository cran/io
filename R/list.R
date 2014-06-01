#' @method qread list
#' @export
qread.list <- function(file, type, ...) {
	d <- read.table(file, header=FALSE, sep="=", strip.white=TRUE, ...);
	if (ncol(d) != 2) {
		stop("File is not in list format (key=value)")
	}
	x <- .df_to_list(d);

	x
}

#' @method qwrite list
#' @export
qwrite.list <- function(x, file, type, ...) {
	# Convert `x` to key-value data.frame suitable for writing to file
	valid <- FALSE;
	if (is.list(x)) {
		if (!is.null(names(x))) {
			x <- .named_list_to_kvdf(x);
			valid <- TRUE;
		}
	} else {
		if (is.data.frame(x)) {
			if (ncol(x) == 2) {
				# no conversion needed
				valid <- TRUE;
			}
		} else if (is.matrix(x)) {
			if (ncol(x) == 1 && !is.null(rownames(x))) {
				x <- .named_matrix_to_kvdf(x);
				valid <- TRUE;
			}
		}
	}

	if (!valid) {
		# `x` could not be converted to a key-value data.frame
		stop("`x` is not a named list, a key-value data.frame, or a named single-column matrix");
	}
	
	# use quotes only on the values that are characters or factors
	write.table(x, file,
		quote=2, sep="=", row.names=FALSE, col.names=FALSE, ...)
}

#' @method qread lst
#' @export
qread.lst <- function(file, type, ...) {
	qread.list(file)
}

#' @method qwrite lst
#' @export
qwrite.lst <- function(x, file, type, ...) {
	qwrite.list(x, file)
}

.df_to_list <- function(d) {
	x <- d[,2];
	names(x) <- d[,1];

	x
}

.named_matrix_to_kvdf <- function(x) {
	data.frame(key=rownames(x), value=x[,1], stringsAsFactors=FALSE)
}

.named_list_to_kvdf <- function(x) {
	data.frame(key=names(x), value=unlist(x), stringsAsFactors=FALSE)
}
