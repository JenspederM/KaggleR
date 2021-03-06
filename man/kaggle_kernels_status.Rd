% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Kernels.R
\name{kaggle_kernels_status}
\alias{kaggle_kernels_status}
\title{Get the Status of the Latest Kernel Run}
\usage{
kaggle_kernels_status(kernel)
}
\arguments{
\item{kernel}{Kernel URL suffix in format <owner>/<kernel-name> (use `kaggle_kernels_list()` to show options)}
}
\description{
Get the Status of the Latest Kernel Run
}
\examples{
kaggle_kernels_status(kernel = "mrisdal/exploring-survival-on-the-titanic")


}
