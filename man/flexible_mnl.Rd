\name{flexible_mnl}
\alias{flexible_mnl}
\title{Flexible MNL with Automatic Functional Form Selection}
\description{
Implements the paper's finding that functional form matters MORE than relaxing IIA.
Automatically tries multiple MNL specifications and returns the best-performing one.
}
\usage{
flexible_mnl(formula, data, forms = c("linear", "quadratic"), selection_criterion = "RMSE", cross_validate = TRUE, n_folds = 5, verbose = TRUE, ...)
}
\arguments{
\item{formula}{Base formula (e.g., vote ~ ideology + income).}
\item{data}{Data frame containing the variables.}
\item{forms}{Character vector. Functional forms to test: "linear", "quadratic",   "log", "interactions", or "all". Default c("linear", "quadratic").}
\item{selection_criterion}{Character. How to select best model: "RMSE", "Brier",   "AIC", "BIC", or "CV" (cross-validation). Default "RMSE".}
\item{cross_validate}{Logical. Use k-fold cross-validation. Default TRUE.}
\item{n_folds}{Integer. Number of CV folds. Default 5.}
\item{verbose}{Logical. Print progress and results. Default TRUE.}
\item{...}{Additional arguments passed to nnet::multinom().}
}
\details{
This function operationalizes the paper's key finding: **flexible MNL often beats
inflexible MNP**.

**Functional forms tested:**
\itemize{
  \item **linear**: y ~ x
  \item **quadratic**: y ~ x + I(x^2)
  \item **log**: y ~ log(x) (for positive variables only)
  \item **interactions**: y ~ x1 * x2 (all two-way interactions)
  \item **all**: Tries all above combinations
}

**Selection criteria:**
\itemize{
  \item RMSE: Root mean squared error (lower is better)
  \item Brier: Brier score (lower is better)
  \item AIC: Akaike Information Criterion (lower is better)
  \item BIC: Bayesian Information Criterion (lower is better)
  \item CV: Cross-validated prediction error
}

}
\value{
A list with components:
\describe{
  \item{best_model}{Fitted model object with best performance}
  \item{best_form}{Character: which functional form won}
  \item{comparison_table}{Data frame comparing all specifications}
  \item{recommendation}{Text recommendation}
  \item{all_models}{List of all fitted models}
  \item{formulas}{List of formulas tested}

}
}
\examples{
\dontrun{
# Automatic functional form selection
result <- flexible_mnl(
  vote ~ ideology + income,
  data = election_data,
  forms = c("linear", "quadratic", "log")
)

# View comparison
print(result$comparison_table)

# Use best model
best_fit <- result$best_model
summary(best_fit)
}

}
