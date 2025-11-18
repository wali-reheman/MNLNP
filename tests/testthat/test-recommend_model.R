test_that("recommend_model returns valid recommendations", {

  # Test small sample size
  result <- recommend_model(n = 100, verbose = FALSE)
  expect_equal(result$recommendation, "MNL")
  expect_equal(result$confidence, "High")
  expect_true(result$expected_mnp_convergence < 0.1)

  # Test medium sample size
  result <- recommend_model(n = 250, verbose = FALSE)
  expect_equal(result$recommendation, "MNL")
  expect_true(result$expected_mnp_convergence > 0.5)

  # Test large sample size
  result <- recommend_model(n = 1000, verbose = FALSE)
  expect_true(result$recommendation %in% c("MNL", "MNP", "Either"))
  expect_true(result$expected_mnp_convergence > 0.9)

  # Test large sample with high correlation
  result <- recommend_model(n = 1000, correlation = 0.7, verbose = FALSE)
  expect_true(result$recommendation %in% c("MNP", "Either"))
})


test_that("recommend_model validates inputs", {

  # Invalid n
  expect_error(recommend_model(n = -1), "positive integer")
  expect_error(recommend_model(n = "100"), NA)  # Should coerce

  # Invalid correlation
  expect_error(recommend_model(n = 100, correlation = 1.5), "between 0 and 1")
  expect_error(recommend_model(n = 100, correlation = -0.1), "between 0 and 1")

  # Invalid functional form
  expect_error(recommend_model(n = 100, functional_form = "cubic"), "must be")
})


test_that("recommend_model returns correct structure", {

  result <- recommend_model(n = 250, verbose = FALSE)

  expect_type(result, "list")
  expect_named(result, c("recommendation", "confidence", "reason",
                         "expected_mnp_convergence", "expected_mnl_win_rate",
                         "n", "correlation", "functional_form"))

  expect_type(result$recommendation, "character")
  expect_type(result$confidence, "character")
  expect_type(result$reason, "character")
  expect_type(result$expected_mnp_convergence, "double")
  expect_type(result$expected_mnl_win_rate, "double")
})


test_that("functional form affects recommendations", {

  result_linear <- recommend_model(n = 250, functional_form = "linear", verbose = FALSE)
  result_quad <- recommend_model(n = 250, functional_form = "quadratic", verbose = FALSE)

  # Both should recommend similar model
  expect_equal(result_linear$recommendation, result_quad$recommendation)

  # But quadratic should mention functional form in reason
  expect_match(result_quad$reason, "quadratic", ignore.case = TRUE)
  expect_false(grepl("quadratic", result_linear$reason, ignore.case = TRUE))
})
