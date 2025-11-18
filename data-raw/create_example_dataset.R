# Create a realistic example dataset for the package
# Based on classic transportation mode choice problem

set.seed(42)

n <- 500  # 500 commuters

# Generate realistic covariates
commuter_choice <- data.frame(
  # Individual characteristics
  income = rnorm(n, mean = 50, sd = 20),  # Income in $1000s
  age = round(rnorm(n, mean = 40, sd = 12)),
  edu_years = round(rnorm(n, mean = 14, sd = 3)),
  distance_miles = abs(rnorm(n, mean = 15, sd = 8)),

  # Choice-specific factors
  own_car = rbinom(n, 1, 0.7),
  has_transit_pass = rbinom(n, 1, 0.3),

  # Time constraints
  work_hours = rnorm(n, mean = 8, sd = 1.5)
)

# Clip values
commuter_choice$income <- pmax(10, pmin(150, commuter_choice$income))
commuter_choice$age <- pmax(18, pmin(70, commuter_choice$age))
commuter_choice$edu_years <- pmax(8, pmin(20, commuter_choice$edu_years))
commuter_choice$distance_miles <- pmax(1, pmin(50, commuter_choice$distance_miles))
commuter_choice$work_hours <- pmax(4, pmin(12, commuter_choice$work_hours))

# Generate mode choice based on realistic utility
# Alternatives: 1=Drive, 2=Public Transit, 3=Bike/Walk

# Utilities (true DGP)
u_drive <- (
  0.5 * commuter_choice$own_car +
  -0.02 * commuter_choice$distance_miles +
  0.01 * commuter_choice$income +
  rnorm(n, 0, 1)
)

u_transit <- (
  0.3 * commuter_choice$has_transit_pass +
  -0.01 * commuter_choice$distance_miles +
  -0.02 * commuter_choice$income +
  0.05 * commuter_choice$edu_years +
  rnorm(n, 0, 1.2)  # Higher variance
)

u_active <- (
  -0.10 * commuter_choice$distance_miles +
  -0.03 * commuter_choice$age +
  0.05 * commuter_choice$work_hours +
  rnorm(n, 0, 1.5)
)

# Make choice (highest utility)
utilities <- cbind(u_drive, u_transit, u_active)
mode_choice <- apply(utilities, 1, which.max)

# Convert to factor with labels
commuter_choice$mode <- factor(mode_choice,
                               levels = 1:3,
                               labels = c("Drive", "Transit", "Active"))

# Create clean variable names
colnames(commuter_choice) <- c(
  "income", "age", "education", "distance",
  "owns_car", "has_pass", "work_hours", "mode"
)

# Remove temporary columns
commuter_choice <- commuter_choice[, c("mode", "income", "age", "education",
                                       "distance", "owns_car", "has_pass", "work_hours")]

# Check distribution
cat("\nMode Choice Distribution:\n")
print(table(commuter_choice$mode))

cat("\nSummary Statistics:\n")
print(summary(commuter_choice))

# Save
if (!dir.exists("data")) dir.create("data")
save(commuter_choice, file = "data/commuter_choice.rda", compress = "xz")

cat("\n✓ Example dataset 'commuter_choice' created successfully!\n")
cat(sprintf("  N = %d observations\n", nrow(commuter_choice)))
cat(sprintf("  Alternatives = %d (Drive, Transit, Active)\n", nlevels(commuter_choice$mode)))
cat(sprintf("  Predictors = %d\n", ncol(commuter_choice) - 1))
cat("\nUsage:\n")
cat("  data(commuter_choice)\n")
cat("  fit <- fit_mnp_safe(mode ~ income + age + education + distance, data = commuter_choice)\n\n")
