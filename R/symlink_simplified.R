# Create symlink to file with a simplified filename
# @param file  a \code{filename} object
.symlink_simplified <- function(file) {
	if (is.filename(file)) {
		x <- as.character(file, simplify=FALSE);
		y <- as.character(file, simplify=TRUE);
		if (x != y) {
			info <- Sys.readlink(y);
			if (is.na(info)) {
				# target does not exist: no preparation needed
				file.symlink(x, y);
			} else if (info == "") {
				# target exists and it is not a symbolic link
				warning("Cannot symlink ", x, " to ", y,
					", because a file exists with the same name.");
			} else {
				# target exists as a symlink: remove it
				file.remove(y);
				file.symlink(x, y);
			}
		}
	}
}
