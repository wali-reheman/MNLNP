\name{decision_framework}
\alias{decision_framework}
\title{Interactive Decision Framework for Model Selection}
\description{
Implements the paper's practical guidance as an interactive decision tool.
Walks users through decision tree to recommend MNL vs MNP based on their situation.
}
\usage{
decision_framework(n = NULL, estimand = NULL, computational_limits = NULL, correlation = NULL, interactive = TRUE, verbose = TRUE)
}
\arguments{
\item{n}{Integer. Sample size. If NULL, will prompt interactively.}
\item{estimand}{Character. What to estimate: "probabilities", "parameters",   "substitution", or NULL for interactive prompt.}
\item{computational_limits}{Logical. Do you have computational constraints?   If NULL, will prompt.}
\item{correlation}{Character. Expected error correlation: "none", "low", "medium",   "high", or NULL for interactive prompt.}
\item{interactive}{Logical. Use interactive prompts. Default TRUE.}
\item{verbose}{Logical. Print detailed reasoning. Default TRUE.}
}
\details{
This function translates the paper's findings into actionable guidance by walking
users through a decision tree based on:

1. Sample size (n)
2. Estimand (what you want to estimate)
3. Computational constraints
4. Expected correlation structure

**Decision logic:**
- n < 250: Always MNL (MNP won't converge)
- 250 <= n < 500: MNL preferred (MNP unreliable)
- n >= 500 + high correlation: MNP viable
- Substitution effects: Usually MNL better
- Computational limits: Always MNL

}
\value{
A list with components:
\describe{
  \item{recommendation}{Character: "MNL", "MNP", or "Either"}
  \item{reasoning}{Detailed explanation of recommendation}
  \item{confidence}{Character: "High", "Medium", or "Low"}
  \item{caveats}{Important considerations}
  \item{alternative_options}{What to try if primary choice doesn't work}
  \item{next_steps}{Recommended actions}

}
}
\examples{
\dontrun{
# Non-interactive mode
decision_framework(
  n = 300,
  estimand = "probabilities",
  computational_limits = FALSE,
  interactive = FALSE
)

# Interactive mode (will prompt user)
decision_framework(interactive = TRUE)
}

}
