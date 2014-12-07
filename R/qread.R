#' Data input
#'
#' This function reads a file in a specified format.
#'
#' If \code{type} is \code{NULL}, the file type is inferred from 
#' the file extension.
#' Use \code{\link{io_supported}} to check support for a file or data type.
#' 
#' @param file  file name (character or \code{filenamer::filename}),
#'              a readable text-mode connection (for some types),
#'              or path to existing directory
#' @param type  data or file type
#' @param ...   other arguments passed to the underlying function
#' @return a data object (type depends on the underlying function)
#' @export
#' @import filenamer
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
		if (is.filename(file)) as.character(file) else file,
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

#' @method qread default
#' @export
qread.default <- function(file, type, ...) {
	.qio_error(file, type)
}
