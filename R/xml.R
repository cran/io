#' @method qread xml
#' @export
qread.xml <- function(file, type, ...) {
	require(XML);
	xmlParse(file, ...)
}

#' @method qwrite xml
#' @export
qwrite.xml <- function(x, file, type, ...) {
	require(XML);
	saveXML(x, file, ...)
}
