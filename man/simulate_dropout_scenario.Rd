\name{simulate_dropout_scenario}
\alias{simulate_dropout_scenario}
\title{Simulate Dropout Scenario to Test Substitution Effects}
\description{
Implements the paper's signature methodological contribution: testing what happens
when alternatives are removed from the choice set. Compares predicted vs. actual
voter/consumer transitions to evaluate model accuracy for substitution effects.
}
\usage{
simulate_dropout_scenario(formula, data, drop_alternative, n_sims = 10000, models = c("MNL", "MNP"), verbose = TRUE, ...)
}
\arguments{
\item{formula}{Model formula (e.g., vote ~ ideology + income).}
\item{data}{Data frame containing the variables.}
\item{drop_alternative}{Character. Name of alternative to remove from choice set.}
\item{n_sims}{Integer. Number of simulations for ground truth. Default 10000.}
\item{models}{Character vector. Models to test: "MNL", "MNP", or both. Default c("MNL", "MNP").}
\item{verbose}{Logical. Print detailed results. Default TRUE.}
\item{...}{Additional arguments passed to model fitting functions.}
}
\details{
This function implements the novel substitution effect test from the paper:

1. Fits models on full choice set
2. Generates large-sample ground truth (n=10,000) to establish "true" probabilities
3. Removes specified alternative
4. Calculates TRUE substitution patterns from ground truth simulation
5. Predicts substitution patterns using each model
6. Compares predicted vs. actual voter/consumer transitions
7. Calculates dropout prediction error for each model

**Example interpretation:**
If Perot drops out:
- TRUE (from simulation): 51% -> Clinton, 49% -> Bush
- MNL predicts: 52% -> Clinton, 48% -> Bush (error = 1%)
- MNP predicts: 98% -> Clinton, 2% -> Bush (error = 47%)
-> MNL is more accurate for this substitution effect

}
\value{
A list with components:
\describe{
  \item{true_transitions}{Where voters/consumers actually go (from simulation)}
  \item{mnl_predictions}{MNL's predicted transition probabilities}
  \item{mnp_predictions}{MNP's predicted transition probabilities (if converges)}
  \item{prediction_errors}{|predicted - actual| for each model}
  \item{brier_scores}{Accuracy of probability predictions}
  \item{winner}{Which model performs better}
  \item{summary_table}{Formatted comparison table}

}
}
\examples{
\dontrun{
# Load example data
load("data/commuter_choice.rda")

# Test what happens if "Active" transportation is removed
result <- simulate_dropout_scenario(
  mode ~ income + age + distance,
  data = commuter_choice,
  drop_alternative = "Active",
  n_sims = 5000
)

# View results
print(result$summary_table)
print(result$winner)
}

}
