#' @method qread bed
#' @export
# @param base  convert the coordinate system to a specified base: 0 or 1
qread.bed <- function(file, type, base=1, ...) {

	# Required fields:
	#
	# chrom
	# chromStart - 0-based, half-open
	# chromEnd
	#
	# Optional fields:
	#
	# name
	# score - A score between 0 and 1000
	# strand - Either '+' or '-'
	# thickStart 
	# thickEnd 
	# itemRgb - An RGB value of the form R,G,B (e.g. 255,0,0)
	# blockCount
	# blockSizes - A comma-separated list of the block sizes
	# blockStarts - A comma-separated list of block starts

	x <- read.table(file, sep="\t", header=FALSE, na.strings=".",
		as.is = TRUE);

	fields <- c("chrom", "chromStart", "chromEnd", "name", "score", "strand",
		"thickStart", "thickEnd", "itemRgb", "blockCount", "blockSizes",
		"blockStarts");

	colnames(x) <- fields[1:ncol(x)];

	x$chromStart <- as.integer(x$chromStart);
	x$chromEnd <- as.integer(x$chromEnd);


	if ("name" %in% colnames(x)) {
		x$name <- factor(x$name);
	}

	if ("score" %in% colnames(x)) {
		x$score <- as.numeric(x$score);
	}

	if ("strand" %in% colnames(x)) {
		x$strand <- factor(x$strand, c("+", "-"));
	}

	if ("thickStart" %in% colnames(x)) {
		x$thickStart <- as.integer(x$thickStart);
	}

	if ("thickEnd" %in% colnames(x)) {
		x$thickEnd <- as.integer(x$thickEnd);
	}

	if ("itemRgb" %in% colnames(x)) {
		tuple2rgb <- function(x) {
			# TODO	
		}
		# TODO
	}

	if ("blockCount" %in% colnames(x)) {
		x$blockCount <- as.integer(x$blockCount);
	}

	if ("blockSizes" %in% colnames(x)) {
		x$blockSizes <- strsplit(x$blockSizes, ",", fixed=TRUE);
	}

	if ("blockStarts" %in% colnames(x)) {
		x$blockStarts <- strsplit(x$blockStarts, ",", fixed=TRUE);
	}


	if (base == 1) {
		# BED coordinate is 0-based, half-open
		x$chromStart <- x$chromStart + 1;
	}
	attr(x, "base") <- base;

	x
}

#' @method qwrite bed
#' @export
# attribute base: coordinate system used in \code{x}: 0 or 1
qwrite.bed <- function(x, file, type, ...) {
	stopifnot(attr(x, "base") != NULL);
	if (attr(x, "base") == 1) {
		# current coordinate is 1-based, convert to 0-based, as per 
		# BED format specification
		x$chromStart <- x$chromStart - 1;
	}
	if ("blockSizes" %in% colnames(x)) {
		x$blockSizes <- lapply(x$blockSizes, paste, sep=",");
	}

	if ("blockStarts" %in% colnames(x)) {
		x$blockStarts <- lapply(x$blockStarts, paste, sep=",");
	}
	write.table(x, file, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE, na=".")
}
