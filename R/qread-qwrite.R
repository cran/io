#' Data input
#'
#' This function reads a file in a specified format.
#'
#' If \code{type} is \code{NULL}, the file type is inferred from 
#' the file extension.
#' Use \code{\link{io_supported}} to check support for a file or data type.
#' 
#' @param file  filename (character or \code{filename::filename}),
#'              a readable text-mode connection (for some types),
#'              or path to existing directory
#' @param type  data or file type
#' @param ...   other arguments passed to the underlying function
#' @return a data object (type depends on the underlying function)
#' @export
#'
#' @examples
#' \dontrun{
#' data(cars)
#'
#' # write data to an RDS file
#' qwrite(cars, "cars.rds")
#' # infer output type based on the class of the cars object
#' qwrite(cars, "cars.dfm", type=NA)
#'
#' # read data back in
#' x1 <- qread("cars.rds")
#' # specify the type explicitly
#' x3 <- qread("cars.dfm", type="data.frame")
#' 
#' # read all files (with extension) in current directory
#' xs <- qread(".", pattern="cars")
#' }
#'
qread <- function(file, type=NULL, ...) {
	.qread(
		if (inherits(file, "filename")) as.character(file) else file,
		if (is.null(type)) .infer_file_type(file) else type,
		...
	)
}

.qread <- function(file, type, ...) {
	# Create a stub variable with the appropriate type
	z <- NA;
	class(z) <- type;
	
	UseMethod("qread", z)
}

#' Data output
#'
#' This function writes an object to file in a specified format.
#'
#' If \code{type} is \code{NULL}, the file type is inferred from 
#' the file extension. If \code{type} is \code{NA} or if the file extension is
#' unavailable or unknown, \code{type} is inferred from \code{class(x)}.
#' Use \code{\link{io_supported}} to check support for a file or data type.
#' 
#' @param x     data object to write
#' @param file  filename (character or \code{filename::filename}),
#'              a readable text-mode connection (for some types),
#'              or path to existing directory
#' @param type  data or file type
#' @param ...   other arguments passed to the underlying function
#' @return a data object (object type depends on the underlying function)
#' @export
#'
#' @examples
#' \dontrun{
#' data(cars)
#'
#' # write data to a TSV file
#' qwrite(cars, "cars.tsv")
#' # infer output type based on the class of the cars object
#' qwrite(as.matrix(cars), "cars.mtx", type=NA)
#' }
#'
qwrite <- function(x, file, type=NULL, ...) {
	.qwrite(
		x,
		if (inherits(file, "filename")) as.character(file) else file,
		if (is.null(type)) .infer_file_type(file) else type,
		...
	)
}

.qwrite <- function(x, file, type, ...) {
	# Create a stub variable with the appropriate type
	# prioritize the class of the object to be written
	z <- NA;
	if (is.null(type) || is.na(type)) {
		class(z) <- class(x);
	} else {
		# use specified/inferred type, with `class(x)` as fallback
		# this allows one to write object in its native text format while
		# using a generic extension (e.g. txt)
		class(z) <- c(type, class(x));
	}

	UseMethod("qwrite", z)
}

#' @method qread default
#' @export
qread.default <- function(file, type, ...) {
	.qio_error(file, type)
}

#' @method qwrite default
#' @export
qwrite.default <- function(x, file, type, ...) {
	.qio_error(file, type)
}

#' Determine input-output support for data or file type
#'
#' This function returns whether a type is supported by
#' \code{\link{qread}} or \code{\link{qwrite}}.
#'
#' @param type  data or file type
#' @return a \code{data.frame} with logical entries;
#'         \code{TRUE} if type is supported, \code{FALSE} otherwise
#' @export
#'
#' @examples
#' io_supported("rds")
#'
io_supported <- function(type) {
	type <- tolower(type);
	data.frame(
		qread = type %in% sub("^qread\\.", "", as.character(methods(qread))),
		qwrite = type %in% sub("^qwrite\\.", "", as.character(methods(qwrite))),
		row.names=type
	)
}

.qio_error <- function(file, type) {
	if (missing(type)) {
		stop("File type is not specified and could not be inferred from file: ",
			as.character(file));
	} else {
		stop(sprintf("File type `%s` is not supported", type));
	}
}

