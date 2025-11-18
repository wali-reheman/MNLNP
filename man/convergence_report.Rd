\name{convergence_report}
\alias{convergence_report}
\title{Comprehensive MNP Convergence Diagnostics}
\description{
Enhanced version of check_mnp_convergence() with detailed diagnostics beyond
basic convergence checking. Provides comprehensive MCMC diagnostics including
Gelman-Rubin statistics, effective sample sizes, trace plots, and autocorrelation.
}
\usage{
convergence_report(mnp_fit, n_draws = NULL, plot = TRUE, verbose = TRUE)
}
\arguments{
\item{mnp_fit}{Fitted MNP model object from MNP::mnp().}
\item{n_draws}{Integer. Number of draws used (for context). If NULL, extracted from fit.}
\item{plot}{Logical. Create diagnostic plots. Default TRUE.}
\item{verbose}{Logical. Print detailed report. Default TRUE.}
}
\details{
This function provides comprehensive MCMC diagnostics for MNP models, going
beyond the basic check in check_mnp_convergence().

**Diagnostics included:**
\itemize{
  \item **Geweke test**: Compares first 10% and last 50% of chain
  \item **Effective sample size**: How many independent draws (target: >1000)
  \item **Autocorrelation**: Correlation between successive draws
  \item **Trace plots**: Visual assessment of mixing
  \item **Boundary warnings**: Correlation parameters near +/-1
}

**Convergence criteria:**
- Geweke z-scores < 2 (in absolute value)
- ESS > 1000 for all parameters
- No extreme autocorrelation (lag-1 < 0.9)
- No correlation estimates at boundaries

**Comparison to literature:**
The function also compares convergence rates to published benchmarks.

}
\value{
A list with components:
\describe{
  \item{converged}{Logical: Overall convergence assessment}
  \item{gelman_rubin}{Gelman-Rubin statistics for all parameters}
  \item{effective_sample_size}{Effective sample sizes}
  \item{geweke_test}{Geweke convergence diagnostics}
  \item{autocorrelation}{Autocorrelation at various lags}
  \item{correlation_warnings}{Warnings if correlation estimates near boundaries}
  \item{summary_table}{Data frame with all diagnostics}
  \item{recommendation}{What to do based on diagnostics}

}
}
\examples{
\dontrun{
# Fit MNP model
mnp_fit <- MNP::mnp(choice ~ x1 + x2, data = mydata,
                    n.draws = 5000, burnin = 1000)

# Comprehensive diagnostics
report <- convergence_report(mnp_fit)

# Check specific issues
if (!report$converged) {
  print(report$recommendation)
}
}

}
