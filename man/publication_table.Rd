\name{publication_table}
\alias{publication_table}
\title{Create Publication-Ready Regression Table}
\description{
Generates camera-ready tables comparing MNL and MNP models for academic papers.
Supports LaTeX, HTML, and markdown formats.
}
\usage{
publication_table(mnl_fit, mnp_fit = NULL, format = "latex", digits = 3, stars = TRUE, se_type = "parentheses", caption = NULL, title = NULL, label = NULL, verbose = TRUE)
}
\arguments{
\item{mnl_fit}{Fitted MNL model (from nnet::multinom or fit_mnp_safe).}
\item{mnp_fit}{Fitted MNP model (from MNP::mnp or fit_mnp_safe). Can be NULL.}
\item{format}{Character. Output format: "latex", "html", or "markdown". Default "latex".}
\item{digits}{Number of decimal places. Default 3.}
\item{stars}{Logical. Add significance stars. Default TRUE.}
\item{se_type}{Character. "standard" or "parentheses". Default "parentheses".}
\item{caption}{Character. Table caption. Default NULL (uses title if provided).}
\item{title}{Character. Alias for caption. Default NULL.}
\item{label}{Character. LaTeX label. Default NULL.}
\item{verbose}{Logical. Print table to console. Default TRUE.}
}
\details{
Creates professional regression tables with:
\itemize{
  \item Coefficient estimates
  \item Standard errors (in parentheses)
  \item Significance stars (* p<0.05, ** p<0.01, *** p<0.001)
  \item Model fit statistics (Log-likelihood, AIC, BIC)
  \item Sample size
}

**LaTeX output** is ready for copy-paste into manuscript.
**HTML output** works in R Markdown documents.
**Markdown output** is human-readable.

}
\value{
Character vector containing formatted table.

}
\examples{
\dontrun{
# Generate data and fit models
dat <- generate_choice_data(n = 300, seed = 123)
mnl <- fit_mnp_safe(choice ~ x1 + x2, data = dat$data, fallback = "MNL")

# Create LaTeX table
table_latex <- publication_table(mnl, format = "latex")
cat(table_latex, sep = "\n")

# Create HTML table
table_html <- publication_table(mnl, format = "html")
cat(table_html, sep = "\n")

# Compare MNL and MNP
mnp <- fit_mnp_safe(choice ~ x1 + x2, data = dat$data, fallback = "NULL")
if (!is.null(mnp)) {
  table <- publication_table(mnl, mnp, format = "latex")
  cat(table, sep = "\n")
}
}

}
