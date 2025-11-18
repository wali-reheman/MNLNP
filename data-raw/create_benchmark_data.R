# Create benchmark dataset from simulation results
# This script creates the mnl_mnp_benchmark dataset included in the package

# NOTE: This is a PLACEHOLDER with representative values based on preliminary results
# Replace this with actual simulation results when Phase 1 completes

# Simulation conditions
sample_sizes <- c(50, 100, 250, 500, 1000)
correlations <- c(0, 0.3, 0.5, 0.7)
functional_forms <- c("linear", "quadratic", "log")

# Create all combinations
conditions <- expand.grid(
  sample_size = sample_sizes,
  correlation = correlations,
  functional_form = functional_forms,
  stringsAsFactors = FALSE
)

# Add empirical results (PLACEHOLDER - based on preliminary findings)
# These values should be replaced with actual simulation output

mnl_mnp_benchmark <- conditions

# MNP convergence rates (increases with n)
mnl_mnp_benchmark$mnp_convergence_rate <- with(mnl_mnp_benchmark, {
  rate <- numeric(nrow(mnl_mnp_benchmark))
  rate[sample_size == 50] <- 0.00
  rate[sample_size == 100] <- 0.02
  rate[sample_size == 250] <- 0.74
  rate[sample_size == 500] <- 0.90
  rate[sample_size == 1000] <- 0.95
  rate
})

# MNL win rate (decreases with n, affected by correlation)
mnl_mnp_benchmark$mnl_win_rate <- with(mnl_mnp_benchmark, {
  base_rate <- numeric(nrow(mnl_mnp_benchmark))
  base_rate[sample_size == 50] <- 1.00   # MNP never converges
  base_rate[sample_size == 100] <- 1.00  # MNP rarely converges
  base_rate[sample_size == 250] <- 0.58
  base_rate[sample_size == 500] <- 0.52
  base_rate[sample_size == 1000] <- 0.48

  # Adjust for correlation (high correlation favors MNP slightly)
  adjusted <- base_rate - 0.03 * correlation
  pmax(0.30, pmin(1.00, adjusted))  # Bound between 0.30 and 1.00
})

# Mean RMSE values (placeholder - needs actual simulation results)
mnl_mnp_benchmark$mnl_rmse_mean <- with(mnl_mnp_benchmark, {
  # Base RMSE decreases with sample size
  base <- 0.08 * sqrt(100 / sample_size)

  # Adjust for functional form
  multiplier <- ifelse(functional_form == "quadratic", 0.85, 1.00)
  multiplier <- ifelse(functional_form == "log", 0.95, multiplier)

  base * multiplier + rnorm(nrow(mnl_mnp_benchmark), 0, 0.002)
})

mnl_mnp_benchmark$mnp_rmse_mean <- with(mnl_mnp_benchmark, {
  # MNP slightly worse than MNL on average at small n, better at large n
  adjustment <- ifelse(sample_size < 250, 1.15, 0.98)
  # High correlation helps MNP
  adjustment <- adjustment - 0.05 * correlation

  mnl_rmse_mean * adjustment + rnorm(nrow(mnl_mnp_benchmark), 0, 0.002)
})

# Brier scores (similar pattern to RMSE)
mnl_mnp_benchmark$mnl_brier_mean <- with(mnl_mnp_benchmark, {
  mnl_rmse_mean^2 * 0.5  # Approximate relationship
})

mnl_mnp_benchmark$mnp_brier_mean <- with(mnl_mnp_benchmark, {
  mnp_rmse_mean^2 * 0.5
})

# Number of replications (will be actual value from simulations)
mnl_mnp_benchmark$n_replications <- 1000

# Round for cleaner display
mnl_mnp_benchmark$mnp_convergence_rate <- round(mnl_mnp_benchmark$mnp_convergence_rate, 3)
mnl_mnp_benchmark$mnl_win_rate <- round(mnl_mnp_benchmark$mnl_win_rate, 3)
mnl_mnp_benchmark$mnl_rmse_mean <- round(mnl_mnp_benchmark$mnl_rmse_mean, 4)
mnl_mnp_benchmark$mnp_rmse_mean <- round(mnl_mnp_benchmark$mnp_rmse_mean, 4)
mnl_mnp_benchmark$mnl_brier_mean <- round(mnl_mnp_benchmark$mnl_brier_mean, 5)
mnl_mnp_benchmark$mnp_brier_mean <- round(mnl_mnp_benchmark$mnp_brier_mean, 5)

# Save to package data directory
usethis::use_data(mnl_mnp_benchmark, overwrite = TRUE)

# Print summary
cat("\nBenchmark dataset created with", nrow(mnl_mnp_benchmark), "conditions\n")
cat("\nSample preview:\n")
print(head(mnl_mnp_benchmark, 10))

cat("\n\nNOTE: This contains PLACEHOLDER values based on preliminary results.")
cat("\nReplace with actual simulation output when Phase 1 completes.\n")
