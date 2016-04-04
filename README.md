# README #

`io` is an R package for reading from, writing to, and plotting to files 
in a unified way:

- **One** function for reading from files: `qread`
- **One** function for writing to files: `qwrite`
- **One** function for plotting to screen or file: `qdraw`

Several file formats and data types can be read using `qread` and written using
`qwrite`. Through unit tests, we ensure that a file written by `qwrite` can be
read by `qread`; futher, a subsequent `qwrite` will produce an identical file
as the original.

File formats are automatically inferred from file extensions or R object
object types. `qread` handles `gzip`, `bzip2`, or `xz` compressed files and 
can iteratively read all files in a directory. `qwrite` creates directory structure for output files.

With the `filenamer` package, output filenames (of the `filename` class) can
also be automatically organized into directories with time stamps and
symbolically linked to the base directory (see the `filenamer` package for
details).

Say *no* to generic file extensions. Say *yes* to standardized file formats.

### Dependencies ###

* R (>= 3.0)
* roxygen2 (>= 4.0, for building only)

### Build ###

Clone the repository, build the documentation with `roxygen2`, then install.

    $ git clone https://bitbucket.org/djhshih/io.git
    $ cd io
    $ R

    R> library(roxygen2)
    R> roxygenize()
    R> quit()

    $ R CMD INSTALL .

### Usage ###

Load the library and use `qwrite` to write data and `qread` to read data.
Output type is inferred automatically from the file extension.

    library(io)
    data(cars)

    qwrite(cars, "cars.rds")
    qwrite(cars, "cars.csv")
    
Input type is also inferred automatically.

    cars_rds <- qread("cars.rds")
    cars_csv <- qread("cars.csv")
    
The RDS format preserves the R object.

    identical(cars_rds, cars)
    ## TRUE
    
The CSV format does not preserve the R object (but it may be more easily 
read by an external programs).

    identical(cars_csv, cars)
    ## FALSE
    
In `cars_csv`, the data is read in as integer instead of numeric by the 
underlying `read.table` function.

    str(cars_csv)

To share data with other programs, consider using HDF5 (binary) or YAML
(text) format. For the HDF5 format, attributes are normally stripped from
R objects. `qwrite` ensures that `names` and `dimnames` are saved to and loaded 
from HDF5 files. To avoid data loss, you should export only objects of 
`vector`, `matrix`, `data.frame` or `array` without additional attributes.
    
Supports for other formats are available via optional dependencies:

    io_supported(c("xml", "yaml", "json", "hdf5"))

Plotting in multiple file formats is easy with `qdraw`.
By default, plots are drawn to screen and then printed to file (in the
the specified format).

    plot_cars <- function() plot(dist ~ speed, cars)
    qdraw(plot_cars())
    qdraw(plot_cars(), "cars.pdf")
    qdraw(plot_cars(), "cars.png")
    qdraw(plot_cars(), "cars.svg")

As shown, we change the output format by simply changing the extension.
We no longer manually call initilization or finalization functions,
nor do we worry about the possibility of extension and format mismatch for 
our output files.

See `?io`.

### Extension ###

Owing to R's S3 class system, it is trivial to extend `io` with
read and write functions for additional formats, *without modifying the
package itself*. Simply fill in the blank:

    qread.EXTENSION <- function(file, type, ...) {
      ## BLANK: read data from `file` to `x`
	    x
    }

    qwrite.EXTENSION <- function(x, file, type, ...) {
      ## BLANK: write data from `x` to `file`
    }

Replace `EXTENSION` with the file extension of the new format, and complete
the implementation details. Then, you use `qread` and `qwrite` just as you
would any currently supported format and benefit from the features of
`io` and `filenamer`.

And if you have not done your good deed of the day yet, write a test file
using `qwrite`, read the data back in using `qread`, ensure the new file
outputted by another `qwrite` is the same as the original test file, and kindly
send us a pull request to contribute to the package.

