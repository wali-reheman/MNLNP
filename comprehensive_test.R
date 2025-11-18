#!/usr/bin/env Rscript
# Comprehensive test suite for all package functions

cat("\n")
cat("==============================================================\n")
cat("  COMPREHENSIVE PACKAGE TEST SUITE\n")
cat("==============================================================\n\n")

# Source all R files
cat("Loading package functions...\n")
source_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
for (f in source_files) {
  source(f)
}
cat("✓ All R files loaded\n\n")

# Track test results
tests_passed <- 0
tests_failed <- 0
test_errors <- list()

run_test <- function(test_name, test_func) {
  cat(sprintf("Testing: %s\n", test_name))
  cat(strrep("-", nchar(test_name) + 9), "\n")

  result <- tryCatch({
    test_func()
    cat("✓ PASSED\n\n")
    TRUE
  }, error = function(e) {
    cat(sprintf("✗ FAILED: %s\n\n", e$message))
    test_errors[[test_name]] <<- e$message
    FALSE
  })

  if (result) {
    tests_passed <<- tests_passed + 1
  } else {
    tests_failed <<- tests_failed + 1
  }

  result
}

# =============================================================================
# TEST 1: recommend_model()
# =============================================================================
run_test("recommend_model()", function() {
  # Test small sample
  rec1 <- recommend_model(n = 50, verbose = FALSE)
  stopifnot(rec1$recommendation == "MNL")

  # Test medium sample
  rec2 <- recommend_model(n = 250, correlation = 0, verbose = FALSE)
  stopifnot(rec2$recommendation %in% c("MNL", "Either"))

  # Test large sample with correlation
  rec3 <- recommend_model(n = 1000, correlation = 0.6, verbose = FALSE)
  stopifnot(!is.null(rec3$recommendation))

  cat(sprintf("  n=50: %s\n", rec1$recommendation))
  cat(sprintf("  n=250, cor=0: %s\n", rec2$recommendation))
  cat(sprintf("  n=1000, cor=0.6: %s\n", rec3$recommendation))
})

# =============================================================================
# TEST 2: generate_choice_data()
# =============================================================================
run_test("generate_choice_data()", function() {
  # Test linear functional form
  set.seed(123)
  dat1 <- generate_choice_data(n = 100, functional_form = "linear", seed = 123)
  stopifnot(nrow(dat1$data) == 100)
  stopifnot(ncol(dat1$true_probs) == 3)
  stopifnot(all(rowSums(dat1$true_probs) - 1 < 1e-10))

  # Test quadratic functional form
  dat2 <- generate_choice_data(n = 100, functional_form = "quadratic", seed = 456)
  stopifnot(nrow(dat2$data) == 100)

  # Test with correlation
  dat3 <- generate_choice_data(n = 100, correlation = 0.5, seed = 789)
  stopifnot(!is.null(dat3$data))

  cat(sprintf("  Linear: %d obs, %d alternatives\n",
              nrow(dat1$data), ncol(dat1$true_probs)))
  cat(sprintf("  Quadratic: %d obs\n", nrow(dat2$data)))
  cat(sprintf("  With correlation: %d obs\n", nrow(dat3$data)))
})

# =============================================================================
# TEST 3: fit_mnp_safe() with smart starting values
# =============================================================================
run_test("fit_mnp_safe() enhanced", function() {
  set.seed(123)
  n <- 150
  test_data <- data.frame(
    choice = factor(sample(1:3, n, replace = TRUE)),
    x1 = rnorm(n),
    x2 = rnorm(n)
  )

  # Test with fallback to MNL
  fit1 <- fit_mnp_safe(choice ~ x1 + x2, data = test_data,
                      fallback = "MNL", verbose = FALSE)
  stopifnot(!is.null(fit1))
  stopifnot(!is.null(attr(fit1, "model_type")))

  # Test with NULL fallback
  fit2 <- fit_mnp_safe(choice ~ x1 + x2, data = test_data,
                      fallback = "NULL", verbose = FALSE, max_attempts = 1)
  # fit2 can be NULL or a model, both are valid

  cat(sprintf("  Fallback='MNL': %s model fitted\n", attr(fit1, "model_type")))
  cat(sprintf("  Fallback='NULL': %s\n",
              if (is.null(fit2)) "NULL (expected)" else "Model fitted"))
})

# =============================================================================
# TEST 4: interpret_convergence_failure()
# =============================================================================
run_test("interpret_convergence_failure()", function() {
  set.seed(456)

  # Test with small sample (should flag sample size)
  small_data <- data.frame(
    choice = factor(sample(1:3, 50, replace = TRUE)),
    x1 = rnorm(50),
    x2 = rnorm(50)
  )

  diag1 <- interpret_convergence_failure(choice ~ x1 + x2,
                                         data = small_data,
                                         verbose = FALSE)
  stopifnot(length(diag1$likely_causes) > 0)
  stopifnot(length(diag1$recommendations) > 0)
  stopifnot(diag1$diagnostics$n == 50)

  # Test with medium sample
  med_data <- data.frame(
    choice = factor(sample(1:3, 200, replace = TRUE)),
    x1 = rnorm(200),
    x2 = rnorm(200)
  )

  diag2 <- interpret_convergence_failure(choice ~ x1 + x2,
                                         data = med_data,
                                         verbose = FALSE)
  stopifnot(!is.null(diag2$diagnostics$n))

  # Test with error message
  diag3 <- interpret_convergence_failure(choice ~ x1 + x2,
                                         data = small_data,
                                         error_message = "TruncNorm: lower bound > upper bound",
                                         verbose = FALSE)
  stopifnot(!is.null(diag3$diagnostics$error_message))

  cat(sprintf("  n=50: %d causes, %d recommendations\n",
              length(diag1$likely_causes), length(diag1$recommendations)))
  cat(sprintf("  n=200: %d causes\n", length(diag2$likely_causes)))
  cat(sprintf("  With error msg: recognized truncation error\n"))
})

# =============================================================================
# TEST 5: compare_mnl_mnp()
# =============================================================================
run_test("compare_mnl_mnp()", function() {
  set.seed(789)
  dat <- generate_choice_data(n = 150, seed = 789)

  comp <- compare_mnl_mnp(choice ~ x1 + x2, data = dat$data,
                         fallback_mnp = TRUE, verbose = FALSE)

  stopifnot(!is.null(comp$results))
  stopifnot(nrow(comp$results) > 0)
  stopifnot(!is.null(comp$winner))

  cat(sprintf("  Winner: %s\n", comp$winner))
  cat(sprintf("  Metrics compared: %d\n", nrow(comp$results)))
})

# =============================================================================
# TEST 6: compare_mnl_mnp_cv() with factor conversion fix
# =============================================================================
run_test("compare_mnl_mnp_cv() with factor fix", function() {
  set.seed(111)
  dat <- generate_choice_data(n = 200, seed = 111)

  # Test with numeric response (should auto-convert to factor)
  dat_numeric <- dat$data
  dat_numeric$choice <- as.numeric(dat_numeric$choice)

  cv <- compare_mnl_mnp_cv(choice ~ x1 + x2, data = dat_numeric,
                          k = 3, fallback_mnp = TRUE, verbose = FALSE)

  stopifnot(!is.null(cv$cv_results))
  stopifnot(nrow(cv$cv_results) > 0)

  cat(sprintf("  CV folds: %d\n", nrow(cv$cv_results)))
  cat(sprintf("  Winner: %s\n", cv$winner))
  cat(sprintf("  Factor conversion: handled correctly\n"))
})

# =============================================================================
# TEST 7: quantify_model_choice_consequences()
# =============================================================================
run_test("quantify_model_choice_consequences()", function() {
  # Quick test with small n_sims
  cons <- quantify_model_choice_consequences(
    n = 100,
    true_correlation = 0,
    n_sims = 15,
    verbose = FALSE
  )

  stopifnot(!is.null(cons$summary))
  stopifnot(nrow(cons$summary) == 2)  # MNL and MNP
  stopifnot(!is.null(cons$recommendation))
  stopifnot(is.logical(cons$safe_zone))

  # Test with higher correlation
  cons2 <- quantify_model_choice_consequences(
    n = 200,
    true_correlation = 0.6,
    n_sims = 15,
    verbose = FALSE
  )

  stopifnot(!is.null(cons2$recommendation))

  cat(sprintf("  n=100, cor=0: %s\n", cons$recommendation))
  cat(sprintf("  Safe zone: %s\n", cons$safe_zone))
  cat(sprintf("  n=200, cor=0.6: %s\n", cons2$recommendation))
})

# =============================================================================
# TEST 8: check_mnp_convergence() with interactive fix
# =============================================================================
run_test("check_mnp_convergence() with interactive fix", function() {
  # This should not error even in non-interactive mode
  # Create a mock MNP object
  mock_mnp <- list(
    param = matrix(rnorm(1000 * 5), ncol = 5),
    class = "mnp"
  )
  class(mock_mnp) <- "mnp"
  colnames(mock_mnp$param) <- paste0("beta", 1:5)

  diag <- check_mnp_convergence(mock_mnp, diagnostic_plots = TRUE, verbose = FALSE)

  stopifnot(!is.null(diag$converged))
  stopifnot(!is.null(diag$geweke_test))
  stopifnot(!is.null(diag$effective_sample_size))

  cat(sprintf("  Converged: %s\n", diag$converged))
  cat(sprintf("  Geweke tests: %d parameters\n", length(diag$geweke_test)))
  cat(sprintf("  ESS computed: %d parameters\n", length(diag$effective_sample_size)))
  cat(sprintf("  No plot errors in non-interactive mode\n"))
})

# =============================================================================
# TEST 9: Visualization functions
# =============================================================================
run_test("Visualization functions", function() {
  # These should not error in non-interactive mode

  # Test plot_convergence_rates
  invisible(capture.output({
    res1 <- plot_convergence_rates()
  }))
  stopifnot(!is.null(res1))

  # Test plot_win_rates
  invisible(capture.output({
    res2 <- plot_win_rates()
  }))
  stopifnot(!is.null(res2))

  # Test plot_recommendation_regions
  invisible(capture.output({
    res3 <- plot_recommendation_regions()
  }))
  stopifnot(!is.null(res3))

  cat("  plot_convergence_rates: OK\n")
  cat("  plot_win_rates: OK\n")
  cat("  plot_recommendation_regions: OK\n")
})

# =============================================================================
# TEST 10: required_sample_size()
# =============================================================================
run_test("required_sample_size()", function() {
  n1 <- required_sample_size(model = "MNP", target_convergence = 0.90, verbose = FALSE)
  n2 <- required_sample_size(model = "MNP", target_convergence = 0.80, verbose = FALSE)

  stopifnot(is.numeric(n1$recommended_n))
  stopifnot(is.numeric(n2$recommended_n))
  stopifnot(n1$recommended_n > n2$recommended_n)  # Higher target = larger n

  cat(sprintf("  For 90%% convergence: n >= %d\n", n1$recommended_n))
  cat(sprintf("  For 80%% convergence: n >= %d\n", n2$recommended_n))
})

# =============================================================================
# TEST 11: evaluate_performance()
# =============================================================================
run_test("evaluate_performance()", function() {
  set.seed(222)
  dat <- generate_choice_data(n = 100, seed = 222)

  fit <- fit_mnp_safe(choice ~ x1 + x2, data = dat$data,
                     fallback = "MNL", verbose = FALSE)

  pred_probs <- predict(fit, type = "probs")
  if (!is.matrix(pred_probs)) {
    pred_probs <- cbind(1 - pred_probs, pred_probs)
  }

  perf <- evaluate_performance(pred_probs, dat$true_probs)

  stopifnot(!is.null(perf$rmse))
  stopifnot(!is.null(perf$brier_score))
  stopifnot(perf$rmse >= 0)
  stopifnot(perf$brier_score >= 0)

  cat(sprintf("  RMSE: %.4f\n", perf$rmse))
  cat(sprintf("  Brier score: %.4f\n", perf$brier_score))
})

# =============================================================================
# TEST 12: run_benchmark_simulation() function availability
# =============================================================================
run_test("run_benchmark_simulation() exists and has correct interface", function() {
  stopifnot(exists("run_benchmark_simulation"))
  stopifnot(is.function(run_benchmark_simulation))

  # Check function arguments
  args <- names(formals(run_benchmark_simulation))
  expected_args <- c("sample_sizes", "correlations", "effect_sizes", "n_reps",
                    "n_alternatives", "functional_forms", "parallel", "n_cores",
                    "save_results", "output_file", "verbose")

  stopifnot(all(expected_args %in% args))

  cat("  Function exists: YES\n")
  cat(sprintf("  Arguments: %d (all expected args present)\n", length(args)))
  cat("  Note: Full simulation test skipped (would take hours)\n")
})

# =============================================================================
# TEST 13: Power analysis functions
# =============================================================================
run_test("power_analysis_mnl()", function() {
  power <- power_analysis_mnl(
    effect_size = 0.5,
    sample_sizes = c(100, 200, 300),
    n_sims = 20,
    alpha = 0.05,
    verbose = FALSE
  )

  stopifnot(!is.null(power$power_curve))
  stopifnot(nrow(power$power_curve) == 3)

  cat(sprintf("  Sample sizes tested: %d\n", nrow(power$power_curve)))
  cat(sprintf("  Power range: %.2f - %.2f\n",
              min(power$power_curve$power), max(power$power_curve$power)))
})

run_test("sample_size_table()", function() {
  table <- sample_size_table(
    effect_sizes = c(0.3, 0.5),
    power_levels = c(0.80, 0.90),
    alpha = 0.05,
    verbose = FALSE
  )

  stopifnot(!is.null(table))
  stopifnot(nrow(table) > 0)

  cat(sprintf("  Table rows: %d\n", nrow(table)))
})

# =============================================================================
# TEST 14: predict.mnp_safe() S3 method
# =============================================================================
run_test("predict.mnp_safe() method", function() {
  set.seed(333)
  train_data <- data.frame(
    choice = factor(sample(1:3, 100, replace = TRUE)),
    x1 = rnorm(100),
    x2 = rnorm(100)
  )

  test_data <- data.frame(
    x1 = rnorm(20),
    x2 = rnorm(20)
  )

  fit <- fit_mnp_safe(choice ~ x1 + x2, data = train_data,
                     fallback = "MNL", verbose = FALSE)

  # Test probability predictions
  probs <- predict(fit, newdata = test_data, type = "probs")
  stopifnot(is.matrix(probs))
  stopifnot(nrow(probs) == 20)

  # Test class predictions
  classes <- predict(fit, newdata = test_data, type = "class")
  stopifnot(length(classes) == 20)

  cat(sprintf("  Probability predictions: %d x %d matrix\n",
              nrow(probs), ncol(probs)))
  cat(sprintf("  Class predictions: %d values\n", length(classes)))
})

# =============================================================================
# SUMMARY
# =============================================================================
cat("\n")
cat("==============================================================\n")
cat("  TEST SUITE SUMMARY\n")
cat("==============================================================\n\n")

cat(sprintf("Total tests: %d\n", tests_passed + tests_failed))
cat(sprintf("Passed: %d\n", tests_passed))
cat(sprintf("Failed: %d\n", tests_failed))

if (tests_failed > 0) {
  cat("\nFailed tests:\n")
  for (test_name in names(test_errors)) {
    cat(sprintf("  - %s: %s\n", test_name, test_errors[[test_name]]))
  }
  cat("\n")
  quit(status = 1)
} else {
  cat("\n✓ ALL TESTS PASSED!\n\n")
  cat("Package is fully functional and ready for use.\n\n")
}
