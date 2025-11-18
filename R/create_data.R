# ⚠️ IMPORTANT: This creates ILLUSTRATIVE/PLACEHOLDER data
# These are educated guesses based on literature review, NOT empirical results
# Run run_benchmark_simulation() to generate real empirical benchmarks
#
# WARNING: Do NOT use these values for publication without validation
# They serve as reasonable starting points pending full simulation study

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

mnl_mnp_benchmark <- conditions

# ILLUSTRATIVE MNP convergence rates (based on literature, not simulations)
# Source: Educated estimates from anecdotal experience
mnl_mnp_benchmark$mnp_convergence_rate <- with(mnl_mnp_benchmark, {
  rate <- numeric(nrow(mnl_mnp_benchmark))
  rate[sample_size == 50] <- 0.00
  rate[sample_size == 100] <- 0.02
  rate[sample_size == 250] <- 0.74
  rate[sample_size == 500] <- 0.90
  rate[sample_size == 1000] <- 0.95
  rate
})

# ILLUSTRATIVE MNL win rate (placeholder estimates)
mnl_mnp_benchmark$mnl_win_rate <- with(mnl_mnp_benchmark, {
  base_rate <- numeric(nrow(mnl_mnp_benchmark))
  base_rate[sample_size == 50] <- 1.00
  base_rate[sample_size == 100] <- 1.00
  base_rate[sample_size == 250] <- 0.58
  base_rate[sample_size == 500] <- 0.52
  base_rate[sample_size == 1000] <- 0.48
  adjusted <- base_rate - 0.03 * correlation
  pmax(0.30, pmin(1.00, adjusted))
})

# ILLUSTRATIVE RMSE values (simulated, not from actual model comparisons)
set.seed(12345)
mnl_mnp_benchmark$mnl_rmse_mean <- with(mnl_mnp_benchmark, {
  base <- 0.08 * sqrt(100 / sample_size)
  multiplier <- ifelse(functional_form == "quadratic", 0.85, 1.00)
  multiplier <- ifelse(functional_form == "log", 0.95, multiplier)
  base * multiplier + rnorm(nrow(mnl_mnp_benchmark), 0, 0.002)
})

mnl_mnp_benchmark$mnp_rmse_mean <- with(mnl_mnp_benchmark, {
  adjustment <- ifelse(sample_size < 250, 1.15, 0.98)
  adjustment <- adjustment - 0.05 * correlation
  mnl_rmse_mean * adjustment + rnorm(nrow(mnl_mnp_benchmark), 0, 0.002)
})

mnl_mnp_benchmark$mnl_brier_mean <- with(mnl_mnp_benchmark, {
  mnl_rmse_mean^2 * 0.5
})

mnl_mnp_benchmark$mnp_brier_mean <- with(mnl_mnp_benchmark, {
  mnp_rmse_mean^2 * 0.5
})

# Mark as illustrative, not empirical
mnl_mnp_benchmark$n_replications <- 0  # ZERO = not real simulations
mnl_mnp_benchmark$data_type <- "illustrative_placeholder"

# Add metadata
attr(mnl_mnp_benchmark, "warning") <- paste(
  "⚠️ WARNING: This data is ILLUSTRATIVE ONLY, not empirical.",
  "Values are educated guesses based on literature review.",
  "Run run_benchmark_simulation() to generate real benchmarks."
)
attr(mnl_mnp_benchmark, "created") <- Sys.time()
attr(mnl_mnp_benchmark, "source") <- "Placeholder estimates pending full study"

# Round
mnl_mnp_benchmark$mnp_convergence_rate <- round(mnl_mnp_benchmark$mnp_convergence_rate, 3)
mnl_mnp_benchmark$mnl_win_rate <- round(mnl_mnp_benchmark$mnl_win_rate, 3)
mnl_mnp_benchmark$mnl_rmse_mean <- round(mnl_mnp_benchmark$mnl_rmse_mean, 4)
mnl_mnp_benchmark$mnp_rmse_mean <- round(mnl_mnp_benchmark$mnp_rmse_mean, 4)
mnl_mnp_benchmark$mnl_brier_mean <- round(mnl_mnp_benchmark$mnl_brier_mean, 5)
mnl_mnp_benchmark$mnp_brier_mean <- round(mnl_mnp_benchmark$mnp_brier_mean, 5)

# Save
if (!dir.exists("data")) dir.create("data")
save(mnl_mnp_benchmark, file = "data/mnl_mnp_benchmark.rda", compress = "xz")

cat("\n")
cat("⚠️  WARNING: ILLUSTRATIVE DATA CREATED (NOT EMPIRICAL)\n")
cat(paste(rep("=", 70), collapse = ""), "\n")
cat("This benchmark data contains PLACEHOLDER estimates, not real simulations.\n")
cat("Source: Educated guesses based on literature review\n")
cat("n_replications = 0 (indicates no actual Monte Carlo runs)\n")
cat("\nTo generate REAL empirical benchmarks, run:\n")
cat("  source('R/run_benchmark_simulation.R')\n")
cat("  pilot <- run_benchmark_simulation(n_reps = 100)\n")
cat(paste(rep("=", 70), collapse = ""), "\n\n")
print(head(mnl_mnp_benchmark, 10))

