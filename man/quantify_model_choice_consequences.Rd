\name{quantify_model_choice_consequences}
\alias{quantify_model_choice_consequences}
\title{Quantify Consequences of Model Choice}
\description{
Simulates the consequences of choosing MNL vs MNP under different true data
generating processes. Shows bias, efficiency loss, and when the choice matters.
}
\usage{
quantify_model_choice_consequences(n, n_alternatives = 3, n_vars = 2, formula = NULL, true_correlation = 0, n_sims = 100, seed = NULL, verbose = TRUE)
}
\arguments{
\item{n}{Sample size for simulation.}
\item{n_alternatives}{Number of choice alternatives. Default 3.}
\item{n_vars}{Number of predictor variables. Default 2.}
\item{formula}{Optional formula. If NULL, uses dynamic formula based on n_vars.}
\item{true_correlation}{True error correlation (0 = IIA holds, >0 = IIA violated).}
\item{n_sims}{Number of simulation replications. Default 100.}
\item{seed}{Random seed for reproducibility.}
\item{verbose}{Logical. Print progress. Default TRUE.}
}
\details{
This function answers: "What happens if I choose the wrong model?"

It generates data under a known DGP and compares:
\itemize{
  \item Coefficient bias (how far off are estimates?)
  \item Prediction RMSE (how bad are predictions?)
  \item Coverage rates (do confidence intervals contain truth?)
}

A "safe zone" exists when both models perform similarly - choice doesn't matter much.

}
\value{
A list with components:
\describe{
  \item{summary}{Data frame summarizing bias and RMSE for both models}
  \item{safe_zone}{Logical: Is the model choice inconsequential?}
  \item{recommendation}{Which model to prefer given the consequences}
  \item{bias_ratio}{Ratio of MNP bias to MNL bias}
  \item{rmse_ratio}{Ratio of MNP RMSE to MNL RMSE}

}
}
\examples{
\dontrun{
# What happens with n=250 and moderate correlation?
consequences <- quantify_model_choice_consequences(
  n = 250,
  true_correlation = 0.4,
  n_sims = 100
)

print(consequences$summary)
print(consequences$recommendation)
}

}
