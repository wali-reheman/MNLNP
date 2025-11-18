\name{substitution_matrix}
\alias{substitution_matrix}
\title{Calculate Substitution Matrix for All Alternatives}
\description{
Calculates complete transition matrix showing where support flows when each
alternative is removed from the choice set. Visualizes substitution patterns
across all possible dropouts.
}
\usage{
substitution_matrix(model_fit, data, from_alternative = NULL, method = "simulation", n_sims = 5000, visualize = FALSE, verbose = TRUE)
}
\arguments{
\item{model_fit}{Fitted model object (MNL or MNP).}
\item{data}{Data frame containing the variables.}
\item{from_alternative}{Character. Which alternative's removal to analyze.   If NULL, analyzes all alternatives.}
\item{method}{Character. "simulation" (recommended) or "analytical" (IIA-based).   Default "simulation".}
\item{n_sims}{Integer. Number of simulations for ground truth. Default 5000.}
\item{visualize}{Logical. Create visualization (requires ggplot2). Default FALSE.}
\item{verbose}{Logical. Print results. Default TRUE.}
}
\details{
Creates a comprehensive view of substitution patterns by calculating where
voters/consumers go when each alternative is removed.

**Transition matrix format:**
```
             To: Clinton  Bush  Perot
From: Clinton    --      35%   65%
      Bush      40%       --    60%
      Perot     51%      49%     --
```

**Methods:**
\itemize{
  \item **simulation**: Uses large-sample simulation to estimate true flows
  \item **analytical**: Uses IIA assumption (P(j|i drops) proportional to P(j))
}

}
\value{
A list with components:
\describe{
  \item{transition_matrix}{Matrix of transition probabilities}
  \item{flow_table}{Data frame with detailed flow information}
  \item{visualization}{ggplot object if visualize=TRUE}
  \item{summary}{Text summary of key patterns}

}
}
\examples{
\dontrun{
# Fit model
mnl <- nnet::multinom(mode ~ income + distance, data = commuter_choice)

# Full substitution matrix
sub_matrix <- substitution_matrix(mnl, data = commuter_choice)

# Analyze specific alternative
sub_matrix <- substitution_matrix(
  mnl,
  data = commuter_choice,
  from_alternative = "Active"
)
}

}
