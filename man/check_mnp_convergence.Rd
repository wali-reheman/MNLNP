\name{check_mnp_convergence}
\alias{check_mnp_convergence}
\title{Check MNP Convergence Diagnostics}
\description{
Performs comprehensive MCMC convergence diagnostics for MNP models.
}
\usage{
check_mnp_convergence(mnp_fit, diagnostic_plots = TRUE, geweke_threshold = 2,
                      ess_threshold = 0.10)
}
\arguments{
\item{mnp_fit}{A fitted MNP model object.}
\item{diagnostic_plots}{Logical. Create diagnostic plots. Default TRUE.}
\item{geweke_threshold}{Numeric. Threshold for Geweke z-statistic. Default 2.}
\item{ess_threshold}{Numeric. Minimum effective sample size as proportion. Default 0.10 (10\% of total draws).}
}
\details{
Implements standard MCMC diagnostics:
\itemize{
  \item Geweke diagnostic - compares means of first 10\% and last 50\% of chain
  \item Effective sample size - accounts for autocorrelation
  \item Visual diagnostics - trace plots, autocorrelation plots
}

A model is considered "converged" if:
\itemize{
  \item All Geweke z-statistics < threshold
  \item Effective sample size > threshold proportion
  \item No obvious patterns in trace plots
}
}
\value{
A list with components:
\describe{
  \item{converged}{Logical: Overall convergence assessment}
  \item{geweke_test}{Geweke convergence diagnostic results}
  \item{effective_sample_size}{Effective sample size for each parameter}
  \item{acceptance_rate}{Acceptance rate (if available)}
  \item{warnings}{Character vector of warnings}
}
}
\examples{
\dontrun{
# Fit MNP model
fit <- fit_mnp_safe(choice ~ x1 + x2, data = mydata, fallback = "NULL")

if (!is.null(fit) && attr(fit, "model_type") == "MNP") {
  # Check convergence
  diagnostics <- check_mnp_convergence(fit)
  print(diagnostics$converged)
}
}
}
