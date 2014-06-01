.infer_file_type <- function(filename) {
	type <- NULL;
	if (inherits(filename, "filename")) {
		if (!is.null(filename$ext)) {
			type <- filename$ext[length(filename$ext)];
		}
	} else if (is.character(filename)) {
		# Strip possible leading periods
		path <- sub("^\\.+", "", filename);
		# Determine type from file extension
		parts <- strsplit(path, ".", fixed=TRUE)[[1]];
		if (length(parts) > 1) {
			type <- parts[length(parts)];
		} else {
			# filename has no period: assume it points to a directory
			type <- "directory";
		}
	}
	# `type` may remain NULL if extension is not available
	# or filename actually points to an open connection

	if (is.null(type)) NULL else tolower(type)
}
