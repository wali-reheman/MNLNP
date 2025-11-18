\name{brier_score}
\alias{brier_score}
\title{Calculate Brier Score with Decomposition}
\description{
Standalone function for Brier score calculation with optional decomposition
into calibration, refinement, and uncertainty components. Helps diagnose
WHY a model performs poorly.
}
\usage{
brier_score(predicted_probs, actual_choices, decompose = TRUE, by_alternative = FALSE, verbose = TRUE)
}
\arguments{
\item{predicted_probs}{Matrix of predicted probabilities (n x K alternatives).}
\item{actual_choices}{Factor or integer vector of actual choices.}
\item{decompose}{Logical. Decompose into components. Default TRUE.}
\item{by_alternative}{Logical. Calculate score separately for each alternative. Default FALSE.}
\item{verbose}{Logical. Print detailed results. Default TRUE.}
}
\details{
**Brier score** measures accuracy of probabilistic predictions:
BS = (1/n) * sum((p_ij - y_ij)^2)

Lower is better (perfect predictions = 0, worst = 2 for binary).

**Decomposition:**
\itemize{
  \item **Calibration**: Are predicted probabilities well-calibrated?
  \item **Refinement**: Does model distinguish between easy and hard cases?
  \item **Uncertainty**: Inherent unpredictability in data
}

This decomposition helps diagnose model problems:
- High calibration -> probabilities systematically wrong
- Low refinement -> model can't distinguish cases
- High uncertainty -> inherently noisy data

}
\value{
A list with components:
\describe{
  \item{brier_score}{Overall Brier score}
  \item{calibration}{Calibration component (if decompose=TRUE)}
  \item{refinement}{Refinement component (if decompose=TRUE)}
  \item{uncertainty}{Uncertainty component (if decompose=TRUE)}
  \item{by_alternative}{Brier scores by alternative (if by_alternative=TRUE)}
  \item{interpretation}{Text interpretation of results}

}
}
\examples{
\dontrun{
# Fit model
mnl <- nnet::multinom(choice ~ x1 + x2, data = mydata)

# Get predictions
probs <- fitted(mnl)

# Calculate Brier score
brier <- brier_score(probs, mydata$choice, decompose = TRUE)

# Diagnose issues
print(brier$interpretation)
}

}
