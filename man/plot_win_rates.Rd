\name{plot_win_rates}
\alias{plot_win_rates}
\title{Plot Win Rate by Sample Size}
\description{
Shows how often MNL outperforms MNP across different sample sizes.
}
\usage{
plot_win_rates(sample_sizes = NULL, win_rates = NULL, correlation = 0, ...)
}
\arguments{
\item{sample_sizes}{Vector of sample sizes.}
\item{win_rates}{Vector of MNL win rates (proportion). If NULL, uses benchmark.}
\item{correlation}{Numeric. Correlation level to show.}
\item{...}{Additional arguments passed to plot().}
}
\value{
A plot showing win rates.

}
\examples{
\dontrun{
plot_win_rates()
}

}
