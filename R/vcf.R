#' @method qread vcf
#' @export
qread.vcf <- function(file, type, single.sample=FALSE, ...) {

	#warn.old <- getOption("warn");
	#options(warn=2);

	sample.col <- 10;

	# x must be a singleton
	parse_value <- function(x) {
		xs <- strsplit(x, ",", fixed=TRUE)[[1]];
		utils::type.convert(xs, na.strings=".", as.is=TRUE)
	}

	parse_info <- function(info) {
		lapply(
			strsplit(info, ";", fixed=TRUE),
			function(y) {
				z <- strsplit(y, "=", fixed=TRUE);
				keys <- unlist(lapply(z, function(i) i[1]));
				values <- lapply(z, function(i) parse_value(i[2]));
				names(values) <- keys;
				values
			}
		);
	}

	parse_variant <- function(variant, format) {
		keyss <- strsplit(format, ":", fixed=TRUE);
		valuess <- lapply(
			strsplit(variant, ":", fixed=TRUE),
			function(y) {
				lapply(y, parse_value)
			}
		);
		mapply(
			function(keys, values) {
				names(values) <- keys;
				values
			},
			keyss,
			valuess
		)
	}

	read_line <- function(f) {
		scan(f, "character", nlines=1, sep="\n", quiet=TRUE)
	}

	meta <- list();

	if (is.character(file)) {
		f <- base::file(file, open="rt");
	} else {
		f <- file;
	}

	# read first line

	line <- read_line(f);
	meta <- c(meta, line);

	stopifnot(line == "##fileformat=VCFv4.2" || line == "##fileformat=VCFv4.1");

	# read meta data

	while (TRUE) {
		line <- read_line(f);
		if (grepl("^##", line)) {
			meta <- c(meta, line);
		} else {
			break;
		}
	}

	# current line should be the header
	stopifnot(grepl("^#CHROM", line));
	header <- strsplit(substr(line, 2, nchar(line)), "\t", fixed=TRUE)[[1]];

	# read data

	x <- read.table(f, sep="\t", comment.char="", header=FALSE,
		stringsAsFactors=FALSE, na.strings=".");

	if (is.character(file)) close(f);

	colnames(x)[1:9] <- tolower(header)[1:(sample.col-1)];

	sample.cols <- sample.col:ncol(x);

	if (single.sample && ncol(x) == sample.col) {
		colnames(x)[sample.col] <- "genotype";
	} else {
		colnames(x)[sample.cols] <- header[sample.cols];
	}

	x$info <- parse_info(x$info);

	for (i in sample.cols) {
		x[[i]] <- parse_variant(x[[i]], x$format)
	}

	attr(x, "format") <- "vcf";
	attr(x, "version") <- sub(meta[1], "fileformat=VCFv([0-9]+.[0-9]+)", "\\1");
	attr(x, "meta") <- meta;

	#options(warn=warn.old);

	x
}

#' @method qwrite vcf
#' @export
qwrite.vcf <- function(x, file, type, ...) {
	stop("Unsupported")
}
