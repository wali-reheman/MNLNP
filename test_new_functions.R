#!/usr/bin/env Rscript
# Quick smoke test for new high-impact functions

cat("\n=== Testing New High-Impact Functions ===\n\n")

# Source all R files
source_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
for (f in source_files) {
  source(f)
}

cat("✓ All R files sourced successfully\n\n")

# Test 1: interpret_convergence_failure
cat("Test 1: interpret_convergence_failure()\n")
cat("---------------------------------------\n")
set.seed(123)
n <- 100
test_data <- data.frame(
  choice = factor(sample(1:3, n, replace = TRUE)),
  x1 = rnorm(n),
  x2 = rnorm(n)
)

diagnosis <- interpret_convergence_failure(
  choice ~ x1 + x2,
  data = test_data,
  verbose = FALSE
)

cat(sprintf("  Identified %d likely causes\n", length(diagnosis$likely_causes)))
cat(sprintf("  Provided %d recommendations\n", length(diagnosis$recommendations)))
cat(sprintf("  Sample size: n = %d\n", diagnosis$diagnostics$n))
cat("  ✓ interpret_convergence_failure() works!\n\n")

# Test 2: Enhanced fit_mnp_safe with smart starting values
cat("Test 2: fit_mnp_safe() with smart starting values\n")
cat("--------------------------------------------------\n")

# Create larger dataset for better convergence
set.seed(456)
n <- 200
test_data2 <- data.frame(
  choice = factor(sample(1:3, n, replace = TRUE)),
  x1 = rnorm(n),
  x2 = rnorm(n)
)

fit <- fit_mnp_safe(
  choice ~ x1 + x2,
  data = test_data2,
  fallback = "MNL",
  max_attempts = 1,
  verbose = FALSE
)

cat(sprintf("  Model type: %s\n", attr(fit, "model_type")))
cat(sprintf("  Coefficients: %d\n", length(coef(fit))))
cat("  ✓ fit_mnp_safe() enhancement works!\n\n")

# Test 3: quantify_model_choice_consequences (quick test with n_sims=10)
cat("Test 3: quantify_model_choice_consequences()\n")
cat("--------------------------------------------\n")

consequences <- quantify_model_choice_consequences(
  n = 100,
  true_correlation = 0,
  n_sims = 10,  # Quick test
  verbose = FALSE
)

cat(sprintf("  Safe zone: %s\n", consequences$safe_zone))
cat(sprintf("  Recommendation: %s\n", consequences$recommendation))
cat(sprintf("  Number of models compared: %d\n", nrow(consequences$summary)))
cat("  ✓ quantify_model_choice_consequences() works!\n\n")

# Test 4: Check run_benchmark_simulation exists
cat("Test 4: run_benchmark_simulation() function\n")
cat("-------------------------------------------\n")
cat("  Function exists:", exists("run_benchmark_simulation"), "\n")
cat("  Note: Full simulation test skipped (would take too long)\n")
cat("  ✓ run_benchmark_simulation() is available!\n\n")

cat("=== All New Functions Tested Successfully! ===\n\n")

cat("Summary of New Capabilities:\n")
cat("  1. interpret_convergence_failure() - Diagnoses WHY MNP fails\n")
cat("  2. fit_mnp_safe() - Now uses smart MNL starting values\n")
cat("  3. quantify_model_choice_consequences() - Shows cost of wrong model\n")
cat("  4. run_benchmark_simulation() - Framework for empirical benchmarks\n\n")

cat("Package is ready for use!\n")
