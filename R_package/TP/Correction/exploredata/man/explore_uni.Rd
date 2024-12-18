% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/explore_uni.R
\name{explore_uni}
\alias{explore_uni}
\alias{explore_uni.character}
\alias{explore_uni.factor}
\alias{explore_uni.numeric}
\alias{explore_uni.integer}
\alias{explore_uni.logical}
\title{Univariate variable representation}
\usage{
explore_uni(x, ...)

\method{explore_uni}{character}(x, ...)

\method{explore_uni}{factor}(x, ...)

\method{explore_uni}{numeric}(x, ...)

\method{explore_uni}{integer}(x, ...)

\method{explore_uni}{logical}(x, ...)
}
\arguments{
\item{x}{: variable to show}

\item{...}{: option to developp...!}
}
\value{
a \code{ggplot2} object
}
\description{
Univariate variable representation
}
\examples{

data("exploredata_ex")
explore_uni(exploredata_ex$value)
explore_uni(exploredata_ex$group)

}
