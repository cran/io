#' @method qread psl
#' @export
# @param base  convert the coordinate system to a specified base: 0 or 1
qread.psl <- function(file, type, base=1, ...) {

	if (is.character(file) || is.filename(file)) {
		close.file <- TRUE;
		file <- base::file(file, "r");
	} else {
		# do not close file if it is a connection object
		close.file <- FALSE;
	}

	l <- readLines(file, n=1);
	if (l != "psLayout version 3") {
		if (close.file) close(file);
		stop("Format is not psLayout version 3");
	}

	headers <- readLines(file, n=4);

	# check separator is detected properly
	separator <- headers[4];

	if (any(separator != paste0(rep("-", nchar(separator)), collapse=""))) {
		if (close.file) close(file);
		stop("File is mal-formed: separator line not recognized properly");
	}

	# read rest of file as normal table
	x <- read.table(file, header=FALSE, sep="\t",
		colClasses=c(rep("integer", 8), rep("character", 2), rep("integer", 3), "character", rep("integer", 4), rep("character", 3)));
	if (close.file) close(file);

	colnames(x) <- c(
		"matches",
		"misMatches",
		"repMatches",
		"nCount",
		"qNumInsert",
		"qBaseInsert",
		"tNumInsert",
		"tBaseInsert",
		"strand",
		"qName",
		"qSize",
		"qStart",
		"qEnd",
		"tName",
		"tSize",
		"tStart",
		"tEnd",
		"blockCount",
		"blockSizes",
		"qStarts",
		"tStarts"
	);

	# convert to list of integers
	x$blockSizes <- char_to_list_int(x$blockSizes);
	x$qStarts <- char_to_list_int(x$qStarts);
	x$tStarts <- char_to_list_int(x$tStarts);

	if (base == 1) {
		# PSL coordinates are 0-based, half-open
		# convert to 1-based, closed
		x$qStart <- x$qStart + 1;
		x$tStart <- x$tStart + 1;
		x$qStarts <- lapply(x$qStarts, function(x) x + 1);
		x$tStarts <- lapply(x$tStarts, function(x) x + 1);
	}
	attr(x, "base") <- base;

	x
}

#' @method qwrite psl
#' @export
# attribute base: coordinate system used in \code{x}: 0 or 1
qwrite.psl <- function(x, file, type, ...) {
	stopifnot(attr(x, "base") != NULL);
	if (attr(x, "base") == 1) {
		# current coordinate is 1-based, convert to 0-based, as per
		# PSL format specification
		x$qStart <- x$qStart - 1;
		x$tStart <- x$tStart - 1;
		x$qStarts <- lapply(x$qStarts, function(x) x - 1);
		x$tStarts <- lapply(x$tStarts, function(x) x - 1);
	}

	# convert to characters
	x$blockSizes <- list_to_char(x$blockSizes);
	x$qStarts <- list_to_char(x$qStarts);
	x$tStarts <- list_to_char(x$tStarts);

	cat(
		"psLayout version 3\n",
		"\n",
		"match	mis- 	rep. 	N's	Q gap	Q gap	T gap	T gap	strand	Q        	Q   	Q    	Q  	T        	T   	T    	T  	block	blockSizes 	qStarts	 tStarts\n",
		"     	match	match	   	count	bases	count	bases	      	name     	size	start	end	name     	size	start	end	count\n",
		"---------------------------------------------------------------------------------------------------------------------------------------------------------------\n",
		file = file, sep =""
	);

	suppressWarnings(
		write.table(x, file, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE, na=".", append=TRUE)
	)
}
