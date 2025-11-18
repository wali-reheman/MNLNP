\name{test_iia}
\alias{test_iia}
\title{Test Independence of Irrelevant Alternatives (IIA)}
\description{
Implements the Hausman-McFadden test for IIA assumption in multinomial models.
If IIA holds, MNL is appropriate. If IIA is violated, consider MNP or mixed logit.
}
\usage{
test_iia(formula_obj, data_obj, method = "hausman", omit_alternative = NULL, alpha = 0.05, verbose = TRUE)
}
\arguments{
\item{formula_obj}{Model formula (e.g., choice ~ x1 + x2).}
\item{data_obj}{Data frame containing the variables in the formula.}
\item{method}{Character. Test method: "hausman" (default) or "small-hsiao".}
\item{omit_alternative}{Which alternative to omit for test. If NULL, auto-selects largest group.}
\item{alpha}{Significance level. Default 0.05.}
\item{verbose}{Logical. Print interpretation. Default TRUE.}
}
\details{
The Hausman-McFadden test compares MNL estimates from the full choice set
versus a restricted choice set with one alternative removed.

**Interpretation:**
\itemize{
  \item p > 0.05: IIA likely holds -> Use MNL (simpler, more efficient)
  \item p < 0.05: IIA violated -> Consider MNP or mixed logit
}

**Important:**  This test requires sufficient observations of each alternative.
With sparse data, test may be unreliable.

}
\value{
A list with components:
\describe{
  \item{test_statistic}{Test statistic value}
  \item{p_value}{P-value}
  \item{df}{Degrees of freedom}
  \item{decision}{Character: "IIA holds" or "IIA violated"}
  \item{recommendation}{Which model to use based on test}
  \item{method}{Test method used}

}
}
\examples{
\dontrun{
# Generate data
dat <- generate_choice_data(n = 300, correlation = 0.4, seed = 123)

# Test IIA
iia_test <- test_iia(choice ~ x1 + x2, data_obj = dat$data)

# Interpretation
print(iia_test$decision)
print(iia_test$recommendation)
}

}
