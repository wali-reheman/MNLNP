\name{recommend_model}
\alias{recommend_model}
\title{Recommend MNL or MNP Based on Empirical Evidence}
\description{
Provides evidence-based recommendations for choosing between Multinomial Logit (MNL)
and Multinomial Probit (MNP) models based on systematic Monte Carlo simulations.
}
\usage{
recommend_model(n, correlation = NULL, functional_form = "linear", verbose = TRUE)
}
\arguments{
\item{n}{Integer. Sample size of your dataset.}
\item{correlation}{Numeric. Expected correlation between error terms (0 to 1).   If NULL, recommendation is based on sample size only.}
\item{functional_form}{Character. Expected functional form: "linear", "quadratic", or "log".   Default is "linear".}
\item{verbose}{Logical. If TRUE, prints detailed reasoning. Default is TRUE.}
}
\details{
Recommendations are based on Monte Carlo simulations with 3,000+ replications
showing empirical convergence rates and performance metrics (RMSE, Brier score).

Key findings:
\itemize{
  \item n < 100: Always use MNL (MNP convergence ~2%)
  \item n = 100-250: MNL preferred (MNP convergence ~74%, but worse RMSE)
  \item n > 500: Either acceptable (MNP convergence ~90%+)
  \item High correlation (r > 0.5): Slight MNP advantage if it converges
  \item Quadratic functional form: Consider quadratic MNL specification
}

}
\value{
A list with components:
\describe{
  \item{recommendation}{Character: "MNL", "MNP", or "Either"}
  \item{confidence}{Character: "High", "Medium", or "Low"}
  \item{reason}{Character: Explanation for the recommendation}
  \item{expected_mnp_convergence}{Numeric: Expected MNP convergence rate}
  \item{expected_mnl_win_rate}{Numeric: Expected probability MNL outperforms MNP}

}
}
\examples{
# Small sample recommendation
recommend_model(n = 100)

# Medium sample with expected correlation
recommend_model(n = 250, correlation = 0.5)

# Large sample
recommend_model(n = 1000, correlation = 0.3)

# Quadratic functional form
recommend_model(n = 250, functional_form = "quadratic")

}
