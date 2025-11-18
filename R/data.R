#' MNL vs MNP Benchmark Results
#'
#' Empirical benchmark data from Monte Carlo simulations comparing Multinomial
#' Logit (MNL) and Multinomial Probit (MNP) models across different conditions.
#'
#' @format A data frame with simulation results:
#' \describe{
#'   \item{sample_size}{Sample size (n): 50, 100, 250, 500, 1000}
#'   \item{correlation}{Error term correlation: 0, 0.3, 0.5, 0.7}
#'   \item{functional_form}{Data generating process: "linear", "quadratic", "log"}
#'   \item{mnp_convergence_rate}{Proportion of MNP replications that converged}
#'   \item{mnl_win_rate}{Proportion of times MNL had lower RMSE (when both converged)}
#'   \item{mnl_rmse_mean}{Mean RMSE for MNL across successful replications}
#'   \item{mnp_rmse_mean}{Mean RMSE for MNP across successful replications}
#'   \item{mnl_brier_mean}{Mean Brier score for MNL}
#'   \item{mnp_brier_mean}{Mean Brier score for MNP}
#'   \item{n_replications}{Number of simulation replications per condition}
#' }
#'
#' @details
#' This dataset contains results from systematic Monte Carlo simulations with
#' 1,000+ replications per condition. Each replication:
#' \enumerate{
#'   \item Generated synthetic multinomial choice data with known probabilities
#'   \item Fit both MNL and MNP models
#'   \item Evaluated prediction performance (RMSE, Brier score)
#'   \item Tracked convergence status
#' }
#'
#' Key findings embedded in this data:
#' \itemize{
#'   \item MNP convergence rates increase with sample size (2% at n=100 to 95% at n=1000)
#'   \item MNL often outperforms MNP even when MNP converges (52-63% win rate)
#'   \item High error correlation gives MNP slight advantage (when it converges)
#'   \item Quadratic functional forms benefit from quadratic MNL specifications
#' }
#'
#' @source Monte Carlo simulations conducted for the MNLNP research project
#'
#' @examples
#' data(mnl_mnp_benchmark)
#'
#' # Convergence rates by sample size
#' aggregate(mnp_convergence_rate ~ sample_size, data = mnl_mnp_benchmark, mean)
#'
#' # MNL win rates by sample size
#' aggregate(mnl_win_rate ~ sample_size, data = mnl_mnp_benchmark, mean)
#'
#' # Performance comparison at n=250
#' subset(mnl_mnp_benchmark, sample_size == 250)
#'
"mnl_mnp_benchmark"
