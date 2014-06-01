.onLoad <- function(libname, pkgname) {

	# plotting options
	opts <- list(
		width = 5,
		height = 5,
		res = 300,
		units = "in"
	);
	options(plot=opts);
	options(plot.device=NA);

}
