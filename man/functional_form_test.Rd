\name{functional_form_test}
\alias{functional_form_test}
\title{Test Multiple Functional Forms and Recommend Best}
\description{
Systematically tests multiple functional forms for predictors and recommends
the best specification based on cross-validation or information criteria.
}
\usage{
functional_form_test(formula, data, test_forms = c("linear", "quadratic", "log"), metric = "RMSE", cross_validate = TRUE, n_folds = 5, verbose = TRUE, ...)
}
\arguments{
\item{formula}{Base formula (e.g., y ~ x1 + x2).}
\item{data}{Data frame containing the variables.}
\item{test_forms}{Character vector. Forms to test: "linear", "quadratic", "log",   "sqrt", "inverse", "interactions". Default c("linear", "quadratic", "log").}
\item{metric}{Character. Selection criterion: "RMSE", "Brier", "AIC", "BIC". Default "RMSE".}
\item{cross_validate}{Logical. Use cross-validation. Default TRUE.}
\item{n_folds}{Integer. Number of CV folds. Default 5.}
\item{verbose}{Logical. Print results. Default TRUE.}
\item{...}{Additional arguments passed to fitting function.}
}
\details{
This function implements the paper's finding that functional form specification
matters more than choice between MNL and MNP.

**Functional forms tested:**
\itemize{
  \item linear: y ~ x
  \item quadratic: y ~ x + x^2
  \item log: y ~ log(x) (positive variables only)
  \item sqrt: y ~ sqrt(x) (non-negative variables only)
  \item inverse: y ~ 1/x (positive variables only)
  \item interactions: y ~ x1 * x2
}

}
\value{
A list with components:
\describe{
  \item{best_form}{Character: winning functional form}
  \item{best_model}{Fitted model with best form}
  \item{ranked_results}{Data frame with all forms ranked by performance}
  \item{improvement}{Percentage improvement over linear baseline}
  \item{recommendation}{Text recommendation}

}
}
\examples{
\dontrun{
result <- functional_form_test(
  vote ~ ideology + income,
  data = election_data,
  test_forms = c("linear", "quadratic", "log")
)

print(result$ranked_results)
}

}
