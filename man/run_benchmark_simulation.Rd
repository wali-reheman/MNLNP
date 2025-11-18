\name{run_benchmark_simulation}
\alias{run_benchmark_simulation}
\title{Run Comprehensive Benchmark Simulation Study}
\description{
Conducts systematic Monte Carlo simulations across multiple conditions to
establish empirical benchmarks for MNL vs MNP performance.
}
\usage{
run_benchmark_simulation(sample_sizes = c(50, 100, 250, 500, 1000, 2000), correlations = seq(0, 0.8, by = 0.2), effect_sizes = c(0.3, 0.5, 0.8), n_reps = 500, n_alternatives = 3, n_vars = 2, functional_forms = c("linear", "quadratic"), parallel = FALSE, n_cores = 4, save_results = TRUE, output_file = "data/mnl_mnp_benchmark.rda", verbose = TRUE)
}
\arguments{
\item{sample_sizes}{Vector of sample sizes to test. Default: c(50, 100, 250, 500, 1000, 2000).}
\item{correlations}{Vector of error correlations. Default: seq(0, 0.8, by=0.2).}
\item{effect_sizes}{Vector of effect sizes. Default: c(0.3, 0.5, 0.8).}
\item{n_reps}{Number of replications per condition. Default: 500.}
\item{n_alternatives}{Number of choice alternatives. Default: 3.}
\item{n_vars}{Number of predictor variables. Default: 2.}
\item{functional_forms}{Vector of functional forms. Default: c("linear", "quadratic").}
\item{parallel}{Logical. Use parallel processing. Default: FALSE.}
\item{n_cores}{Number of cores for parallel processing. Default: 4.}
\item{save_results}{Logical. Save results to .rda file. Default: TRUE.}
\item{output_file}{File path for saving results. Default: "data/mnl_mnp_benchmark.rda".}
\item{verbose}{Logical. Print progress. Default: TRUE.}
}
\details{
This function runs a comprehensive simulation study to replace placeholder
benchmark data with real empirical results.

**Recommended Full Study:**
- 6 sample sizes x 5 correlations x 3 effect sizes x 2 forms x 500 reps = 45,000 simulations
- Estimated time: 12-24 hours with parallel processing
- Disk space: ~50-100 MB for results

**Quick Pilot Study:**
- 3 sample sizes x 3 correlations x 2 effect sizes x 1 form x 100 reps = 1,800 simulations
- Estimated time: 1-2 hours

}
\value{
A data frame with columns:
\describe{
  \item{n}{Sample size}
  \item{correlation}{Error correlation}
  \item{effect_size}{Effect size}
  \item{functional_form}{Functional form}
  \item{rep}{Replication number}
  \item{mnp_converged}{Logical: Did MNP converge?}
  \item{mnl_rmse}{MNL prediction RMSE}
  \item{mnp_rmse}{MNP prediction RMSE (NA if failed)}
  \item{mnl_winner}{Logical: Did MNL have lower RMSE?}
  \item{mnl_aic}{MNL AIC}
  \item{mnp_aic}{MNP AIC}
  \item{computation_time_mnl}{Seconds to fit MNL}
  \item{computation_time_mnp}{Seconds to fit MNP}

}
}
\examples{
\dontrun{
# Quick pilot study (1,800 simulations)
pilot <- run_benchmark_simulation(
  sample_sizes = c(100, 250, 500),
  correlations = c(0, 0.4, 0.8),
  effect_sizes = c(0.3, 0.5),
  functional_forms = "linear",
  n_reps = 100,
  save_results = TRUE,
  output_file = "data/pilot_benchmark.rda"
)

# Full benchmark study (45,000 simulations - SLOW!)
full <- run_benchmark_simulation(
  n_reps = 500,
  parallel = TRUE,
  n_cores = 8,
  save_results = TRUE
)
}

}
