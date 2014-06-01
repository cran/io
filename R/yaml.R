#' @method qread yaml
#' @export
qread.yaml <- function(file, type, ...) {
	require(yaml);

	yaml.load_file(file, ...)
}

#' @method qwrite yaml
#' @export
qwrite.yaml <- function(x, file, type, append=FALSE, ...) {
	require(yaml);

	cat(as.yaml(x, ...), sep="", file=file, append=append)
}
