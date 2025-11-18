\name{compare_mnl_mnp_cv}
\alias{compare_mnl_mnp_cv}
\title{Compare MNL and MNP with Cross-Validation (Improved)}
\description{
Enhanced version with actual cross-validation implementation.
}
\usage{
compare_mnl_mnp_cv(formula, data, metrics = c("RMSE", "Brier", "Accuracy"), cross_validate = TRUE, n_folds = 5, verbose = TRUE, ...)
}
\arguments{
\item{formula}{Formula object specifying the model.}
\item{data}{Data frame containing the variables.}
\item{metrics}{Character vector. Metrics to compute.}
\item{cross_validate}{Logical. Use k-fold cross-validation. Default FALSE.}
\item{n_folds}{Integer. Number of folds for cross-validation. Default 5.}
\item{verbose}{Logical. Print progress messages. Default TRUE.}
\item{...}{Additional arguments passed to fitting functions.}
}
\value{
A list with comparison results.

}
