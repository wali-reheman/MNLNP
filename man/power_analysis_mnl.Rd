\name{power_analysis_mnl}
\alias{power_analysis_mnl}
\title{Power Analysis for Multinomial Choice Models}
\description{
Conducts power analysis via simulation to determine sample size requirements
for detecting effects of a given size.
}
\usage{
power_analysis_mnl(effect_size, alpha = 0.05, power = 0.80, n_alternatives = 3, model = "MNL", n_sims = 100, n_range = NULL, verbose = TRUE)
}
\arguments{
\item{effect_size}{Numeric. Standardized effect size (coefficient / SE).}
\item{alpha}{Numeric. Significance level. Default 0.05.}
\item{power}{Numeric. Desired power. Default 0.80.}
\item{n_alternatives}{Integer. Number of choice alternatives. Default 3.}
\item{model}{Character. "MNL" or "MNP". Default "MNL".}
\item{n_sims}{Integer. Number of simulations. Default 100.}
\item{n_range}{Vector. Range of sample sizes to test. If NULL, uses default range.}
\item{verbose}{Logical. Print progress. Default TRUE.}
}
\details{
Uses simulation to estimate power: generates data with specified effect size,
fits the model, and checks if the effect is statistically significant.
Repeats this process for different sample sizes to build a power curve.

}
\value{
A list with:
\describe{
  \item{required_n}{Estimated sample size needed for desired power}
  \item{power_curve}{Data frame with n and power estimates}
  \item{plot}{Power curve plot}

}
}
\examples{
\dontrun{
# How many observations needed to detect moderate effect with 80% power?
power_result <- power_analysis_mnl(effect_size = 0.5, power = 0.80)
print(power_result$required_n)
plot(power_result$power_curve)
}

}
