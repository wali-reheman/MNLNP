#!/usr/bin/env Rscript
# Final validation test - tests actual function signatures and behavior

cat("\n=== FINAL VALIDATION TEST ===\n\n")

# Source all R files
source_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
for (f in source_files) {
  source(f)
}

tests_passed <- 0
tests_total <- 0

test <- function(name, expr) {
  tests_total <<- tests_total + 1
  cat(sprintf("[%d] %s... ", tests_total, name))

  result <- tryCatch({
    expr
    cat("✓\n")
    tests_passed <<- tests_passed + 1
    TRUE
  }, error = function(e) {
    cat(sprintf("✗ %s\n", e$message))
    FALSE
  })

  result
}

# Core Functions
test("recommend_model() with various inputs", {
  r1 <- recommend_model(n = 50, verbose = FALSE)
  stopifnot(r1$recommendation == "MNL")

  r2 <- recommend_model(n = 1000, correlation = 0.6, verbose = FALSE)
  stopifnot(!is.null(r2$recommendation))
})

test("generate_choice_data() creates valid data", {
  set.seed(123)
  dat <- generate_choice_data(n = 100, seed = 123)
  stopifnot(nrow(dat$data) == 100)
  stopifnot(ncol(dat$true_probs) == 3)
  stopifnot(all(abs(rowSums(dat$true_probs) - 1) < 1e-10))
})

test("fit_mnp_safe() with smart starting values", {
  set.seed(123)
  test_data <- data.frame(
    choice = factor(sample(1:3, 150, replace = TRUE)),
    x1 = rnorm(150),
    x2 = rnorm(150)
  )

  fit <- fit_mnp_safe(choice ~ x1 + x2, data = test_data,
                     fallback = "MNL", verbose = FALSE)
  stopifnot(!is.null(fit))
  stopifnot(!is.null(attr(fit, "model_type")))
})

# New High-Impact Functions
test("interpret_convergence_failure() diagnoses issues", {
  set.seed(456)
  small_data <- data.frame(
    choice = factor(sample(1:3, 50, replace = TRUE)),
    x1 = rnorm(50),
    x2 = rnorm(50)
  )

  diag <- interpret_convergence_failure(choice ~ x1 + x2,
                                        data = small_data,
                                        verbose = FALSE)
  stopifnot(length(diag$likely_causes) > 0)
  stopifnot(length(diag$recommendations) > 0)
  stopifnot(diag$diagnostics$n == 50)
})

test("quantify_model_choice_consequences() runs", {
  cons <- quantify_model_choice_consequences(
    n = 100,
    true_correlation = 0,
    n_sims = 10,
    verbose = FALSE
  )

  stopifnot(!is.null(cons$summary))
  stopifnot(nrow(cons$summary) == 2)
  stopifnot(!is.null(cons$recommendation))
})

test("compare_mnl_mnp() compares models", {
  set.seed(789)
  dat <- generate_choice_data(n = 150, seed = 789)

  comp <- compare_mnl_mnp(choice ~ x1 + x2, data = dat$data,
                         fallback_mnp = TRUE, verbose = FALSE)

  stopifnot(!is.null(comp$results))
  stopifnot(!is.null(comp$winner))
})

test("compare_mnl_mnp_cv() with cross-validation", {
  set.seed(111)
  dat <- generate_choice_data(n = 200, seed = 111)

  # Test with numeric response (factor conversion)
  dat_numeric <- dat$data
  dat_numeric$choice <- as.numeric(dat_numeric$choice)

  cv <- compare_mnl_mnp_cv(choice ~ x1 + x2, data = dat_numeric,
                           k = 3, fallback_mnp = TRUE, verbose = FALSE)

  stopifnot(!is.null(cv$results))
  stopifnot(!is.null(cv$cv_performed))
})

test("check_mnp_convergence() without verbose parameter", {
  # Create mock MNP object
  mock_mnp <- list(param = matrix(rnorm(1000 * 5), ncol = 5))
  class(mock_mnp) <- "mnp"
  colnames(mock_mnp$param) <- paste0("beta", 1:5)

  # Test without verbose parameter (it doesn't have one)
  diag <- check_mnp_convergence(mock_mnp, diagnostic_plots = FALSE)

  stopifnot(!is.null(diag$converged))
  stopifnot(!is.null(diag$geweke_test))
})

test("Visualization functions work in non-interactive mode", {
  invisible(capture.output({
    r1 <- plot_convergence_rates()
    r2 <- plot_win_rates()
    r3 <- plot_recommendation_regions()
  }))

  stopifnot(!is.null(r1))
  stopifnot(!is.null(r2))
  stopifnot(!is.null(r3))
})

test("required_sample_size() without verbose parameter", {
  # Function doesn't have verbose parameter
  result <- required_sample_size(model = "MNP", target_convergence = 0.90)

  stopifnot(!is.null(result$recommended_n))
  stopifnot(is.numeric(result$recommended_n))
})

test("evaluate_performance() returns correct structure", {
  set.seed(222)

  # Create predicted and true probabilities
  n <- 100
  true_probs <- matrix(runif(n * 3), ncol = 3)
  true_probs <- true_probs / rowSums(true_probs)

  pred_probs <- matrix(runif(n * 3), ncol = 3)
  pred_probs <- pred_probs / rowSums(pred_probs)

  perf <- evaluate_performance(pred_probs, true_probs)

  # Check structure - it returns a named numeric vector
  stopifnot(!is.null(perf))
  stopifnot(length(perf) > 0)
})

test("power_analysis_mnl() with correct parameters", {
  # Check actual parameter names
  power <- power_analysis_mnl(
    effect_size = 0.5,
    n_range = c(100, 300),
    n_points = 3,
    n_sims = 20,
    alpha = 0.05
  )

  stopifnot(!is.null(power$power_curve))
})

test("sample_size_table() with correct parameters", {
  # Check actual function signature
  table <- sample_size_table(
    effect_size = 0.5,
    power = 0.80,
    alpha = 0.05
  )

  stopifnot(!is.null(table))
})

test("predict.mnp_safe() S3 method", {
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

  probs <- predict(fit, newdata = test_data, type = "probs")
  classes <- predict(fit, newdata = test_data, type = "class")

  stopifnot(is.matrix(probs))
  stopifnot(nrow(probs) == 20)
  stopifnot(length(classes) == 20)
})

test("run_benchmark_simulation() function exists", {
  stopifnot(exists("run_benchmark_simulation"))
  stopifnot(is.function(run_benchmark_simulation))
})

# Summary
cat(sprintf("\n=== RESULTS: %d/%d tests passed ===\n\n", tests_passed, tests_total))

if (tests_passed == tests_total) {
  cat("✓ ALL TESTS PASSED!\n")
  cat("Package is fully functional.\n\n")
  quit(status = 0)
} else {
  cat(sprintf("✗ %d tests failed\n\n", tests_total - tests_passed))
  quit(status = 1)
}
