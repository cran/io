# README #

`io` is an R package for reading from, writing to, and plotting to files 
in a simple, unified way.
A number of file and data types can be read using `qread` and written using
`qwrite`.
Plots be drawn on screen or printed to file using `qdraw`.
File formats are automatically inferred from filename extensions.

### Dependencies ###

* R (>= 3.0)
* roxygen2 (>= 4.0, for building only)

### Build ###

Clone the repository, build the documentation with roxygen2, then install.

    $ git clone https://bitbucket.org/dshih/io.git
    $ cd io
    $ R

    R> library(roxygen2)
    R> roxygenize()
    R> quit()

    $ R CMD INSTALL .

### Usage ###

Load the library and use `qwrite` to write data and `qread` to read data.

    library(io)
    data(cars)
    
Output type is inferred automatically from the file extension.

    qwrite(cars, "cars.rds")
    qwrite(cars, "cars.csv")
    
Input type is also inferred automatically.

    cars_rds <- qread("cars.rds")
    cars_csv <- qread("cars.csv")
    
RDS format preserves the R object.

    identical(cars_rds, cars)
    ## TRUE
    
CSV format does not preserve the R object (but it may be more easily read by 
other programs).

    identical(cars_csv, cars)
    ## FALSE
    
In `cars_csv`, the data is read in as integer instead of numeric by the 
underlying `read.table` function.

    str(cars_csv)
    
Supports for other formats are available via optional dependencies

    io_supported(c("xml", "yaml", "json", "hdf5"))

Plotting in multiple file formats is easy with `qdraw`.
By default, plots are drawn to screen and then printed to file (if specified).

    plot_cars <- function() plot(dist ~ speed, cars)
    qdraw(plot_cars())
    qdraw(plot_cars(), "cars.pdf")
    qdraw(plot_cars(), "cars.png")
    qdraw(plot_cars(), "cars.svg")

See `?io`.
