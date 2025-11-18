\name{sample_size_table}
\alias{sample_size_table}
\title{Quick Sample Size Lookup Table}
\description{
Provides a lookup table of sample sizes needed for different effect sizes
and power levels.
}
\usage{
sample_size_table(model = "MNL", n_alternatives = 3, print_table = TRUE)
}
\arguments{
\item{model}{Character. "MNL" or "MNP". Default "MNL".}
\item{n_alternatives}{Integer. Number of alternatives. Default 3.}
\item{print_table}{Logical. Print formatted table. Default TRUE.}
}
\value{
A data frame with sample size requirements.

}
