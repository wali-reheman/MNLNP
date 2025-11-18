\name{model_summary_comparison}
\alias{model_summary_comparison}
\title{Model Summary Comparison}
\description{
Provides a side-by-side summary of MNL and MNP model fits.
}
\usage{
model_summary_comparison(mnl_fit, mnp_fit = NULL, print_summary = TRUE)
}
\arguments{
\item{mnl_fit}{Fitted MNL model.}
\item{mnp_fit}{Fitted MNP model (can be NULL if failed).}
\item{print_summary}{Logical. Print summary. Default TRUE.}
}
\value{
A list with summary statistics for both models.

}
