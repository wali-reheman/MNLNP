\name{compare_mnl_mnp}
\alias{compare_mnl_mnp}
\title{Compare MNL and MNP Model Performance}
\description{
Fits both Multinomial Logit and Multinomial Probit models on the same data
and compares their performance using multiple metrics.
}
\usage{
compare_mnl_mnp(formula, data, metrics = c("RMSE", "Brier", "AIC"), cross_validate = FALSE, n_folds = 5, verbose = TRUE, ...)
}
\arguments{
\item{formula}{Formula object specifying the model.}
\item{data}{Data frame containing the variables.}
\item{metrics}{Character vector. Metrics to compute: "RMSE", "Brier", "AIC",   "BIC", "LogLik". Default is c("RMSE", "Brier", "AIC").}
\item{cross_validate}{Logical. Use k-fold cross-validation for RMSE and Brier.   Default is FALSE (uses in-sample fit).}
\item{n_folds}{Integer. Number of folds for cross-validation. Default is 5.}
\item{verbose}{Logical. Print progress messages. Default is TRUE.}
\item{...}{Additional arguments passed to fitting functions.}
}
\details{
This function provides a head-to-head comparison of MNL vs MNP on the same
dataset. It handles MNP convergence failures gracefully and provides clear
guidance about which model performed better.

Performance metrics:
\itemize{
  \item RMSE - Root Mean Squared Error of predicted probabilities
  \item Brier - Brier score for probabilistic predictions
  \item AIC - Akaike Information Criterion (lower is better)
  \item BIC - Bayesian Information Criterion (lower is better)
  \item LogLik - Log-likelihood (higher is better)
}

}
\value{
A list with components:
\describe{
  \item{results}{Data frame with performance metrics for each model}
  \item{winner}{Character vector indicating which model won on each metric}
  \item{recommendation}{Overall recommendation based on results}
  \item{mnl_fit}{Fitted MNL model (if successful)}
  \item{mnp_fit}{Fitted MNP model (if successful, NULL otherwise)}
  \item{converged}{Named logical vector indicating convergence status}

}
}
\examples{
\dontrun{
# Simulate data
set.seed(123)
n <- 250
x1 <- rnorm(n)
x2 <- rnorm(n)
# True probabilities
z1 <- 0.5 * x1 + 0.3 * x2
z2 <- -0.3 * x1 + 0.5 * x2
probs <- cbind(1, exp(z1), exp(z2))
probs <- probs / rowSums(probs)
y <- apply(probs, 1, function(p) sample(1:3, 1, prob = p))
dat <- data.frame(y = factor(y), x1, x2)

# Compare models
comparison <- compare_mnl_mnp(y ~ x1 + x2, data = dat)
print(comparison$results)
print(comparison$recommendation)
}

}
