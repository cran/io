char_to_list_int <- function(x, sep=",") {
	lapply(strsplit(x, sep, fixed=TRUE), as.integer)
}

char_to_list_numeric <- function(x, sep=",") {
	lapply(strsplit(x, sep, fixed=TRUE), as.numeric)
}

char_to_list <- function(x, sep=",") {
	strsplit(x, sep, fixed=TRUE)
}

list_to_char <- function(x, sep=",") {
	unlist(lapply(x, paste, collapse=sep));
}
