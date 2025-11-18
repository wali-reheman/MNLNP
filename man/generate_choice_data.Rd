\name{generate_choice_data}
\alias{generate_choice_data}
\title{Generate Synthetic Multinomial Choice Data}
\description{
Creates synthetic multinomial choice data with known probabilities for testing
and simulation studies. Allows control over sample size, number of alternatives,
error correlation, and functional form.
}
\usage{
generate_choice_data(n, n_alternatives = 3, n_vars = 2, correlation = 0, functional_form = "linear", effect_size = 1, seed = NULL)
}
\arguments{
\item{n}{Integer. Number of observations to generate.}
\item{n_alternatives}{Integer. Number of choice alternatives (default 3).}
\item{n_vars}{Integer. Number of explanatory variables (default 2).}
\item{correlation}{Numeric. Correlation between error terms (0 to 1). Default 0.}
\item{functional_form}{Character. "linear", "quadratic", or "log". Default "linear".}
\item{effect_size}{Numeric. Magnitude of coefficients. Default 1.}
\item{seed}{Integer. Random seed for reproducibility. If NULL, no seed set.}
}
\details{
This function generates multinomial choice data using either a logit or probit
data generating process. The errors can be correlated according to the specified
correlation structure.

For the linear functional form, utilities are:
\deqn{U_{ij} = \beta_j' X_i + \epsilon_{ij}}

For quadratic:
\deqn{U_{ij} = \beta_j' X_i + \gamma_j' X_i^2 + \epsilon_{ij}}

The chosen alternative is the one with highest utility.

}
\value{
A list with components:
\describe{
  \item{data}{Data frame with choice outcome and covariates}
  \item{true_probs}{Matrix of true choice probabilities}
  \item{true_betas}{Matrix of true coefficient values}
  \item{correlation_matrix}{Correlation matrix used for errors}
  \item{formula}{Formula object dynamically created based on n_vars (e.g., choice ~ x1 + x2 + x3)}
  \item{n_vars}{Number of predictor variables}
  \item{n_alternatives}{Number of choice alternatives}

}
}
\examples{
# Generate simple 3-alternative choice data
dat <- generate_choice_data(n = 250)
head(dat$data)
head(dat$true_probs)

# Generate data with correlation
dat <- generate_choice_data(n = 500, correlation = 0.5)

# Generate data with quadratic functional form
dat <- generate_choice_data(n = 250, functional_form = "quadratic")

}
