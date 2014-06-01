#' @method qread hdf5
#' @export
qread.hdf5 <- function(file, type, name="data", ...) {
	require(rhdf5);

	h5read(file, name, ...)	
}

#' @method qwrite hdf5
#' @export
qwrite.hdf5 <- function(x, file, type, name="data", ...) {
	require(rhdf5);

	if (is.character(file) && !file.exists(file)) {
		h5createFile(file);
	}

	h5write(x, file, name, ...)	
}

#' @method qread h5
#' @export
qread.h5 <- qread.hdf5;

#' @method qwrite h5
#' @export
qwrite.h5 <- qwrite.hdf5;
