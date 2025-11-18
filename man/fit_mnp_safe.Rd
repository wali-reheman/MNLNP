\name{fit_mnp_safe}
\alias{fit_mnp_safe}
\title{Safely Fit Multinomial Probit with Error Handling}
\description{
Wrapper around MNP::mnp() that handles common convergence failures gracefully
with automatic fallback options and multiple retry attempts.
}
\usage{
fit_mnp_safe(formula, data, fallback = "MNL", max_attempts = 3, verbose = TRUE, ...)
}
\arguments{
\item{formula}{Formula object specifying the model.}
\item{data}{Data frame containing the variables.}
\item{fallback}{Character. What to do if MNP fails: "MNL" (fit MNL instead),   "error" (throw error), or "NULL" (return NULL). Default is "MNL".}
\item{max_attempts}{Integer. Number of times to retry MNP with different   starting values. Default is 3.}
\item{verbose}{Logical. Print convergence status messages. Default is TRUE.}
\item{...}{Additional arguments passed to MNP::mnp() or nnet::multinom().}
}
\details{
Common MNP convergence errors handled:
\itemize{
  \item "TruncNorm: lower bound > upper bound" - Numerical instability
  \item MCMC convergence failures - Poor mixing or non-convergence
  \item Starting value issues - Improper initialization
}

The function tries multiple random seeds for starting values if initial
attempts fail. If all attempts fail and fallback="MNL", fits standard
multinomial logit using nnet::multinom() instead.

}
\value{
A fitted model object (class "mnp" or "multinom") or NULL if fallback="NULL"
  and all attempts fail. Includes additional attribute "model_type" indicating
  which model was actually fit.

}
\examples{
\dontrun{
# Simulate some data
set.seed(123)
n <- 100
x1 <- rnorm(n)
x2 <- rnorm(n)
y <- sample(1:3, n, replace = TRUE)
dat <- data.frame(y = factor(y), x1, x2)

# Try to fit MNP, fallback to MNL if it fails
fit <- fit_mnp_safe(y ~ x1 + x2, data = dat, fallback = "MNL")

# Check which model was actually fit
attr(fit, "model_type")
}

}
