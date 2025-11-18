\name{required_sample_size}
\alias{required_sample_size}
\title{Calculate Required Sample Size for Reliable Model Convergence}
\description{
Determines the minimum sample size needed for reliable MNP convergence based
on empirical Monte Carlo results.
}
\usage{
required_sample_size(model = "MNP", target_convergence = 0.90, correlation = 0)
}
\arguments{
\item{model}{Character. "MNL" or "MNP". Default is "MNP".}
\item{target_convergence}{Numeric. Desired convergence probability (0 to 1). Default is 0.90 (90\%).}
\item{correlation}{Numeric. Expected error correlation. Currently not used in calculations but reserved for future versions.}
}
\details{
Based on empirical convergence rates:
\itemize{
  \item n=100 -> 2\% convergence
  \item n=250 -> 74\% convergence
  \item n=500 -> ~90\% convergence
  \item n=1000 -> ~95\% convergence
}

MNL always converges, so this function mainly applies to MNP.
}
\value{
A list with components:
\describe{
  \item{minimum_n}{Integer: Recommended minimum sample size}
  \item{convergence_at_n}{Numeric: Expected convergence rate at that n}
  \item{warning}{Character: Warning message if applicable}
}
}
\examples{
# Minimum n for 90\% MNP convergence
required_sample_size(model = "MNP", target_convergence = 0.90)

# Minimum n for 95\% MNP convergence
required_sample_size(model = "MNP", target_convergence = 0.95)
}
