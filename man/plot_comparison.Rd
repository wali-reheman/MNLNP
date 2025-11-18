\name{plot_comparison}
\alias{plot_comparison}
\title{Plot Model Comparison Results}
\description{
Visualizes the results of MNL vs MNP comparison.
}
\usage{
plot_comparison(comparison_results, metric = NULL, ...)
}
\arguments{
\item{comparison_results}{Results from compare_mnl_mnp().}
\item{metric}{Character. Which metric to focus on: "RMSE", "Brier", "AIC", etc.}
\item{...}{Additional arguments passed to barplot().}
}
\value{
A comparison plot.

}
\examples{
\dontrun{
# Simulate data and compare models
dat <- generate_choice_data(n = 250, seed = 123)
comp <- compare_mnl_mnp(choice ~ x1 + x2, data = dat$data)
plot_comparison(comp)
}

}
