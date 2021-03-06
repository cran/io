.infer_file_type <- function(filename) {
	type <- NULL;
	if (is.character(filename)) {
		filename <- as.filename(filename);
	}
	if (is.filename(filename)) {
		if (is.null(filename$ext) || filename$ext == "") {
			# filename has no period: assume it points to a directory
			type <- "directory";
		} else {
			type <- filename$ext[length(filename$ext)];
		}
	}
	# `type` may remain NULL if extension is not available
	# or filename actually points to an open connection

	if (is.null(type)) NULL else tolower(type)
}

.qio_error <- function(file, type) {
	if (missing(type)) {
		stop("File type is not specified and could not be inferred from file: ",
			as.character(file));
	} else {
		stop(sprintf("File type `%s` is not supported", type));
	}
}

.check_package <- function(pkg) {
	if (requireNamespace(pkg, quietly=TRUE)) {
		library(pkg, character.only=TRUE, quietly=TRUE);
	} else {
		stop("Please install ", pkg, " or use another file format", call. = FALSE);
	}
}
