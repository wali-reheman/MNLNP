\name{evaluate_performance}
\alias{evaluate_performance}
\title{Evaluate Prediction Performance}
\description{
Calculates performance metrics comparing predicted to true probabilities.
}
\usage{
evaluate_performance(predicted_probs, true_probs = NULL, actual_choices = NULL, metrics = c("RMSE", "Brier", "LogLoss", "Accuracy"))
}
\arguments{
\item{predicted_probs}{Matrix of predicted choice probabilities (n x J).}
\item{true_probs}{Matrix of true choice probabilities (n x J).}
\item{actual_choices}{Vector of actual choices (factor or numeric).}
\item{metrics}{Character vector of metrics to compute. Options: "RMSE",   "Brier", "LogLoss", "Accuracy". Default is all.}
}
\details{
Computes standard prediction performance metrics:
\itemize{
  \item RMSE - Root Mean Squared Error across all probabilities
  \item Brier - Brier score (mean squared error for probabilities)
  \item LogLoss - Logarithmic loss (cross-entropy)
  \item Accuracy - Proportion of correct predictions
}

}
\value{
A list with computed metrics.

}
\examples{
# Generate data with known probabilities
dat <- generate_choice_data(n = 100, seed = 123)

# Fit a model and get predictions
# (this is a placeholder - you'd use actual model predictions)
predicted <- dat$true_probs + matrix(rnorm(100 * 3, sd = 0.1), 100, 3)
predicted <- predicted / rowSums(predicted)  # Normalize

# Evaluate performance
evaluate_performance(predicted, dat$true_probs, dat$data$choice)

}
