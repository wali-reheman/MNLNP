#' mnlChoice: Evidence-Based Model Selection for Multinomial Choice Models
#'
#' @description
#' Provides practical guidance for choosing between Multinomial Logit (MNL)
#' and Multinomial Probit (MNP) models based on systematic Monte Carlo simulations.
#'
#' @details
#' The mnlChoice package helps researchers make evidence-based decisions about
#' which multinomial choice model to use. Based on 3,000+ Monte Carlo replications,
#' this package provides:
#'
#' \itemize{
#'   \item Decision support functions (\code{\link{recommend_model}})
#'   \item Robust MNP fitting with fallback (\code{\link{fit_mnp_safe}})
#'   \item Head-to-head model comparison (\code{\link{compare_mnl_mnp}})
#'   \item Sample size calculators (\code{\link{required_sample_size}})
#'   \item Empirical benchmark data (\code{\link{mnl_mnp_benchmark}})
#' }
#'
#' Key findings from the research:
#' \itemize{
#'   \item MNL often outperforms MNP, especially at small to medium sample sizes
#'   \item MNP convergence failures are common (2% at n=100, 74% at n=250)
#'   \item Even when MNP converges, MNL frequently has better prediction accuracy
#'   \item Functional form specification often matters more than model choice
#' }
#'
#' @section Main Functions:
#'
#' \describe{
#'   \item{\code{recommend_model()}}{Get evidence-based MNL vs MNP recommendation}
#'   \item{\code{compare_mnl_mnp()}}{Compare both models on your data}
#'   \item{\code{fit_mnp_safe()}}{Fit MNP with robust error handling}
#'   \item{\code{required_sample_size()}}{Calculate minimum n for MNP convergence}
#' }
#'
#' @section Data:
#'
#' \describe{
#'   \item{\code{mnl_mnp_benchmark}}{Simulation results with convergence rates and performance metrics}
#' }
#'
#' @author Your Name \email{your.email@@example.com}
#'
#' @references
#' [Your names] (2024). When Multinomial Logit Outperforms Multinomial Probit:
#' A Monte Carlo Comparison. [Journal/Working Paper].
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
