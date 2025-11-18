\name{interpret_convergence_failure}
\alias{interpret_convergence_failure}
\title{Interpret MNP Convergence Failure}
\description{
Diagnoses why MNP failed to converge and provides actionable recommendations.
}
\usage{
interpret_convergence_failure(formula, data, error_message = NULL, verbose = TRUE)
}
\arguments{
\item{formula}{Model formula.}
\item{data}{Data frame.}
\item{error_message}{Character. The error message from MNP (if available).}
\item{verbose}{Logical. Print diagnostic information. Default TRUE.}
}
\details{
This function performs several diagnostic checks to identify why MNP failed:
\itemize{
  \item Sample size adequacy (n < 250 is high-risk)
  \item Error correlation structure (low correlation favors MNL)
  \item Multicollinearity issues
  \item Identification problems
  \item Data quality issues
}

}
\value{
A list with components:
\describe{
  \item{likely_causes}{Character vector of probable reasons for failure}
  \item{recommendations}{Character vector of actionable next steps}
  \item{diagnostics}{List of diagnostic values (sample size, correlation estimate, etc.)}

}
}
\examples{
\dontrun{
# After MNP fails
diagnosis <- interpret_convergence_failure(choice ~ x1 + x2, data = mydata)
print(diagnosis$recommendations)
}

}
