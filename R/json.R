#' @method qread json
#' @export
qread.json <- function(file, type, ...) {
	require(jsonlite);

	jsonlite::unserializeJSON(paste(readLines(file), collapse="\n"), ...)
}

#' @method qwrite json
#' @export
qwrite.json <- function(x, file, type, append=FALSE, ...) {
	require(jsonlite);

	cat(jsonlite::serializeJSON(x, ...), sep="", file=file, append=append)
}
