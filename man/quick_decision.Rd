\name{quick_decision}
\alias{quick_decision}
\title{Quick Decision Rule for Model Selection}
\description{
Provides instant MNL vs MNP recommendation without fitting models,
based on sample size and data characteristics.
}
\usage{
quick_decision(n, n_predictors, n_alternatives = 3, has_correlation = "unknown", computational_constraint = FALSE, verbose = FALSE)
}
\arguments{
\item{n}{Sample size.}
\item{n_predictors}{Number of predictor variables.}
\item{n_alternatives}{Number of choice alternatives. Default 3.}
\item{has_correlation}{Character: "yes", "no", or "unknown". Default "unknown".}
\item{computational_constraint}{Logical. Are you limited by computation time? Default FALSE.}
\item{verbose}{Logical. Print decision details. Default FALSE.}
}
\details{
This is a rule-of-thumb decision tool based on:
\itemize{
  \item Sample size requirements for MNP convergence
  \item Computational feasibility
  \item IIA assumption plausibility
}

**Use this when you need a quick decision before running full comparison.**

}
\value{
A list with components:
\describe{
  \item{model}{Character: "MNL", "MNP", or "Either"}
  \item{recommendation}{Character: "MNL", "MNP", or "Either" (same as model)}
  \item{confidence}{Character: "High", "Medium", or "Low"}
  \item{reason}{Explanation of recommendation}
  \item{reasoning}{Explanation of recommendation (same as reason)}
  \item{next_steps}{Suggested actions}

}
}
\examples{
# Small sample
quick_decision(n = 150, n_predictors = 3)
# -> Recommends MNL

# Large sample with known correlation
quick_decision(n = 800, n_predictors = 5, has_correlation = "yes")
# -> Recommends MNP

# Computational constraints
quick_decision(n = 1000, n_predictors = 10, computational_constraint = TRUE)
# -> Recommends MNL (MNP too slow)

}
