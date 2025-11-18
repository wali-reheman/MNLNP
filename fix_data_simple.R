#!/usr/bin/env Rscript
# Fix warning attribute by replacing entire message

cat("Fixing warning attribute in mnl_mnp_benchmark.rda...\n")

load("data/mnl_mnp_benchmark.rda")

# Replace entire warning message with ASCII version
new_warning <- "WARNING: This data is ILLUSTRATIVE ONLY, not empirical. Values are educated guesses based on literature review. Run run_benchmark_simulation() to generate real benchmarks."

attr(mnl_mnp_benchmark, "warning") <- new_warning

# Save
save(mnl_mnp_benchmark, file = "data/mnl_mnp_benchmark.rda")

cat("Fixed! New warning message:\n")
cat(new_warning, "\n")
cat("\nSaved to data/mnl_mnp_benchmark.rda\n")
