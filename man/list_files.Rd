% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/directory.R
\name{list_files}
\alias{list_files}
\title{List the files in a directory.}
\usage{
list_files(path = ".", full.names = FALSE, ...)
}
\arguments{
\item{path}{a character vector of path names}

\item{full.names}{whether to return absolute paths}

\item{...}{other arguments passed to \code{\link{list.files}}}
}
\value{
a \code{character} vector of only names of files
}
\description{
This function extends \code{\link{list.files}} 
by excluding the listing of directories.
}
\examples{
list.files(R.home())
list_files(R.home())

}
