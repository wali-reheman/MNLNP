test_that("required_sample_size calculates correctly", {

  # MNL always works
  result <- required_sample_size(model = "MNL", target_convergence = 0.90)
  expect_equal(result$minimum_n, 1)
  expect_equal(result$convergence_at_n, 1.0)

  # MNP needs larger samples for higher convergence
  result_50 <- required_sample_size(model = "MNP", target_convergence = 0.50)
  result_90 <- required_sample_size(model = "MNP", target_convergence = 0.90)
  result_95 <- required_sample_size(model = "MNP", target_convergence = 0.95)

  expect_true(result_50$minimum_n < result_90$minimum_n)
  expect_true(result_90$minimum_n < result_95$minimum_n)

  # 90% convergence should be around n=500
  expect_true(result_90$minimum_n >= 450)
  expect_true(result_90$minimum_n <= 550)
})


test_that("required_sample_size validates inputs", {

  # Invalid model
  expect_error(required_sample_size(model = "OLS"), "must be")

  # Invalid target_convergence
  expect_error(required_sample_size(model = "MNP", target_convergence = 1.5), "between 0 and 1")
  expect_error(required_sample_size(model = "MNP", target_convergence = -0.1), "between 0 and 1")
})


test_that("required_sample_size returns correct structure", {

  result <- required_sample_size(model = "MNP", target_convergence = 0.90)

  expect_type(result, "list")
  expect_named(result, c("minimum_n", "convergence_at_n", "warning"))

  expect_type(result$minimum_n, "double")
  expect_type(result$convergence_at_n, "double")
})
