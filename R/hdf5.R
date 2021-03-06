#' @method qread hdf5
#' @export
qread.hdf5 <- function(file, type, ...) {
	.check_package("rhdf5")

	if (!is.character(file)) stop("file must be a filename [character vector]");

	opt <- setup();	

	vars <- trimws(rhdf5::h5ls(file)$name);
	if (
		! "author" %in% vars ||
		! "io::qwrite" %in% rhdf5::h5read(file, name="author")
	) {
		# file not written by qwrite: just read it as a flat list
		# TODO reconstruct group hierarchy
		x <- lapply(vars,
			function(name) {
				rhdf5::h5read(file, name=name, ...)
			}
		);
		names(x) <- vars;
	} else {
		if (!all(c("type", "data") %in% vars)) {
			stop("HDF5 file is incomplete", call.=FALSE);
		}

		# read the string value stored in the `type` attribute of the h5 file
		type <- rhdf5::h5read(file, name="type", ...);

		if (type == "vector") {
			x <- .read_hdf5_vector(file, vars);
		} else if (type == "matrix" || type == "array") {
			x <- .read_hdf5_matrix(file, vars);
		} else if (type == "data.frame") {
			x <- .read_hdf5_data.frame(file, vars);
		}
	}

	teardown(opt);

	x
}

.read_hdf5_vector <- function(file, vars) {
	x <- rhdf5::h5read(file, name="data");
	if ("names" %in% vars) {
		names(x) <- rhdf5::h5read(file, name="names");
	}
	# use c() to return a vector (instead of an array)
	c(x)
}

.read_hdf5_matrix <- function(file, vars) {
	x <- rhdf5::h5read(file, name="data");
	if ("dimnames" %in% vars) {
		dimnames(x) <- rhdf5::h5read(file, name="dimnames");
	}
	x
}

.read_hdf5_data.frame <- function(file, vars) {
	x <- rhdf5::h5read(file, name="data");
	if ("dimnames" %in% vars) {
		dimnames(x) <- rhdf5::h5read(file, name="dimnames");
	}
	if ("factors" %in% vars) {
		factors <- rhdf5::h5read(file, name="factors");
		for (fa in factors) {
			lev <- rhdf5::h5read(file, name=paste("levels", fa, sep="_"));
			x[, fa] <- factor(x[, fa], labels=lev);
		}
	}
	x	
}

#' @method qwrite hdf5
#' @export
qwrite.hdf5 <- function(x, file, type, force=FALSE, ...) {
	.check_package("rhdf5");

	if (!is.character(file)) stop("file must be a file name [character vector]");

	opt <- setup();	

	if (file.exists(file)) {
		file.remove(file);
	}
	rhdf5::h5createFile(file);

	type.i <- which(unlist(lapply(hdf5.supported.types, function(type) inherits(x, type))));
	# use only the first supported type
	# this is alright we keep the supported type vector in a sane order
	if (length(type.i) > 1) {
		type.i <- type.i[1];
	}
	# handle the special case for vectors
	# is.vector and inherits(x, "vector") are both uninformative
	# because vector of different modes are considered types
	# (e.g. logical and numeric are both functionally vectors 
	# but they do not have the vector class)
	if (is.atomic(x) && length(type.i) == 0) {
		type.i <- match("vector", hdf5.supported.types);
	}
	if (length(type.i) == 0) {
		if (force) {
			rhdf5::h5save(x, file=file);
		} else {
			stop("Writting ", class(x), " to HDF5 format is not supported; ",
				"set force=TRUE to write to HDF5 format anyway ",
				"(data attributes may be lost or transformed)", call.=FALSE);
		}
	} else {
		type <- hdf5.supported.types[type.i];
		if (type == "vector") {
			.write_hdf5_vector(x, file);
		} else if (type == "matrix") {
			.write_hdf5_matrix(x, file);
		} else if (type == "array") {
			.write_hdf5_array(x, file);
		} else if (type == "data.frame") {
			.write_hdf5_data.frame(x, file);
		}
		rhdf5::h5write("io::qwrite", file, "author");
	}

	teardown(opt);

}

# order of supported types is from most specific to most general
hdf5.supported.types <- c("data.frame", "matrix", "array", "vector");

.write_hdf5_vector <- function(x, file) {
	rhdf5::h5write("vector", file, "type");
	rhdf5::h5write(x, file, "data");
	if (!is.null(names(x))) {
		rhdf5::h5write(names(x), file, "names");
	}
}

.write_hdf5_matrix <- function(x, file) {
	rhdf5::h5write("matrix", file, "type");
	rhdf5::h5write(x, file, "data");
	if (!is.null(dimnames(x))) {
		rhdf5::h5write(dimnames(x), file, "dimnames");
	}
}

.write_hdf5_array <- function(x, file) {
	rhdf5::h5write("array", file, "type");
	rhdf5::h5write(x, file, "data");
	if (!is.null(dimnames(x))) {
		rhdf5::h5write(dimnames(x), file, "dimnames");
	}
}

.write_hdf5_data.frame <- function(x, file) {
	rhdf5::h5write("data.frame", file, "type");
	rhdf5::h5write(x, file, "data");
	if (!is.null(dimnames(x))) {
		rhdf5::h5write(dimnames(x), file, "dimnames");
	}
	vars <- colnames(x);
	factors <- NULL;
	for (v in vars) {
		if (is.factor(x[, v])) {
			factors <- c(factors, v);
			rhdf5::h5write(levels(x[, v]), file, paste("levels", v, sep="_"));
		}
	}
	rhdf5::h5write(factors, file, "factors");
}


#' @method qread h5
#' @export
qread.h5 <- qread.hdf5;

#' @method qwrite h5
#' @export
qwrite.h5 <- qwrite.hdf5;

# probably only needed for Solaris
setup <- function() {
	# Test for HDF5 file locking, record, & disable
	if (exists("rhdf5::h5testFileLocking") && !rhdf5::h5testFileLocking( tempdir() )) {
		opt <- Sys.getenv("HDF5_USE_FILE_LOCKING");
		rhdf5::h5disableFileLocking();
		opt
	} else {
		NULL	
	}
}

# probably only needed for Solaris
teardown <- function(opt=NULL) {
	# Restore previous file locking status
	if (!is.null(opt) && opt != "FALSE") {
		rhdf5::h5enableFileLocking()
	}
}

