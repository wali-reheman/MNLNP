\name{plot_convergence_rates}
\alias{plot_convergence_rates}
\title{Plot MNP Convergence Rates by Sample Size}
\description{
Creates a visualization showing how MNP convergence rates vary with sample size.
}
\usage{
plot_convergence_rates(sample_sizes = NULL, correlation = 0, add_benchmark = TRUE, ...)
}
\arguments{
\item{sample_sizes}{Vector of sample sizes to plot. If NULL, uses benchmark data.}
\item{correlation}{Numeric. Correlation level to plot (if using simulated data).}
\item{add_benchmark}{Logical. Add empirical benchmark points. Default TRUE.}
\item{...}{Additional arguments passed to plot().}
}
\value{
A plot showing convergence rates.

}
\examples{
\dontrun{
# Plot convergence rates
plot_convergence_rates()

# Plot for specific sample sizes
plot_convergence_rates(sample_sizes = c(50, 100, 250, 500, 1000))
}

}
