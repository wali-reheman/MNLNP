\name{sample_size_calculator}
\alias{sample_size_calculator}
\title{Enhanced Sample Size Calculator with Power Analysis}
\description{
More sophisticated version of required_sample_size() that calculates minimum
sample size based on desired estimand, target accuracy, and expected parameters.
Includes power calculations and tradeoff visualization.
}
\usage{
sample_size_calculator(desired_estimand = "probabilities", target_accuracy = NULL, n_alternatives = 3, n_predictors = NULL, expected_correlation = NULL, model = "MNP", power = 0.80, effect_size = 0.3, confidence_level = 0.95, verbose = TRUE)
}
\arguments{
\item{desired_estimand}{Character. What you want to estimate: "probabilities",   "parameters", "substitution", or "convergence". Default "probabilities".}
\item{target_accuracy}{Numeric. Desired accuracy level. For probabilities,   target RMSE; for convergence, target probability. Default NULL (uses standard).}
\item{n_alternatives}{Integer. Number of choice alternatives. Default 3.}
\item{n_predictors}{Integer. Number of predictor variables. Default NULL.}
\item{expected_correlation}{Numeric. Expected error correlation (0-1). Default NULL.}
\item{model}{Character. "MNL" or "MNP". Default "MNP" (more conservative).}
\item{power}{Numeric. Desired power for parameter detection (0-1). Default 0.80.}
\item{effect_size}{Numeric. Standardized effect size to detect. Default 0.3 (medium).}
\item{confidence_level}{Numeric. Confidence level for intervals. Default 0.95.}
\item{verbose}{Logical. Print detailed results. Default TRUE.}
}
\details{
This function provides sophisticated sample size guidance based on:

**For probabilities:**
- Target RMSE (e.g., 0.05 for 5% average error)
- Based on empirical simulation results

**For parameters:**
- Power to detect effect of given size
- Standard errors relative to coefficient magnitude

**For substitution:**
- Power to detect substitution patterns
- Based on dropout scenario accuracy

**For convergence:**
- MNP convergence probability
- Based on empirical convergence rates

}
\value{
A list with components:
\describe{
  \item{recommended_n}{Recommended minimum sample size}
  \item{conservative_n}{Conservative estimate (safety margin)}
  \item{rationale}{Explanation of calculation}
  \item{expected_performance}{Expected accuracy at recommended n}
  \item{power_curve}{Data frame for power at different sample sizes}
  \item{tradeoff_table}{Table showing n vs accuracy tradeoffs}

}
}
\examples{
\dontrun{
# Minimum n for 90% MNP convergence
calc <- sample_size_calculator(
  desired_estimand = "convergence",
  target_accuracy = 0.90,
  model = "MNP"
)

# Minimum n for RMSE < 0.05
calc <- sample_size_calculator(
  desired_estimand = "probabilities",
  target_accuracy = 0.05,
  n_alternatives = 4
)

# View tradeoff curve
print(calc$tradeoff_table)
}

}
