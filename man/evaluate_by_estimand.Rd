\name{evaluate_by_estimand}
\alias{evaluate_by_estimand}
\title{Evaluate Models Based on Estimand}
\description{
Implements the estimand-based framework: evaluates model performance based on
what the researcher wants to estimate (probabilities, parameters, or substitution effects).
}
\usage{
evaluate_by_estimand(fitted_models, data, estimand = "all", dropout_alternative = NULL, true_params = NULL, verbose = TRUE, ...)
}
\arguments{
\item{fitted_models}{List of fitted model objects (e.g., list(mnl=mnl_fit, mnp=mnp_fit)).}
\item{data}{Data frame containing the variables.}
\item{estimand}{Character. What you want to estimate: "probabilities", "parameters",   "substitution", or "all". Default "all".}
\item{dropout_alternative}{Character. For substitution estimand, which alternative   to drop. If NULL, uses smallest group.}
\item{true_params}{Numeric vector. For parameter estimand, true parameter values   if known (from simulation). Default NULL.}
\item{verbose}{Logical. Print detailed results. Default TRUE.}
\item{...}{Additional arguments passed to evaluation functions.}
}
\details{
This function operationalizes the paper's key insight: model choice depends on
what you want to estimate (the estimand).

**Estimand types:**
\itemize{
  \item **probabilities**: Evaluates predicted choice probabilities (RMSE, Brier score)
  \item **parameters**: Evaluates coefficient estimates (bias, SE accuracy)
  \item **substitution**: Evaluates substitution pattern accuracy (dropout scenarios)
  \item **all**: Reports all three estimands
}

**Example output:**
- For probabilities: "MNL achieves RMSE=0.034 vs MNP=0.113"
- For substitution: "MNL error=5.2% vs MNP error=8.1%"

}
\value{
A list with components:
\describe{
  \item{estimand}{Which estimand was evaluated}
  \item{results}{Data frame with performance metrics for each model}
  \item{recommendation}{Which model performs best for this estimand}
  \item{reasoning}{Explanation of recommendation}

}
}
\examples{
\dontrun{
# Fit models
mnl_fit <- nnet::multinom(vote ~ ideology, data = mydata)
mnp_fit <- fit_mnp_safe(vote ~ ideology, data = mydata)

# Evaluate for different estimands
evaluate_by_estimand(
  list(mnl = mnl_fit, mnp = mnp_fit),
  data = mydata,
  estimand = "probabilities"
)

evaluate_by_estimand(
  list(mnl = mnl_fit, mnp = mnp_fit),
  data = mydata,
  estimand = "substitution",
  dropout_alternative = "Perot"
)
}

}
