#!/usr/bin/env Rscript
# Fix non-ASCII warning emoji in benchmark data

cat("Fixing warning attribute in mnl_mnp_benchmark.rda...\n")

load("data/mnl_mnp_benchmark.rda")

# Get current warning
warning_msg <- attr(mnl_mnp_benchmark, "warning")
cat("Original:", warning_msg, "\n\n")

# Replace emoji with ASCII
warning_msg <- gsub("\u26a0\ufe0f", "WARNING:", warning_msg)
warning_msg <- gsub("\u26a0", "WARNING:", warning_msg)

# Update attribute
attr(mnl_mnp_benchmark, "warning") <- warning_msg

# Save
save(mnl_mnp_benchmark, file = "data/mnl_mnp_benchmark.rda")

cat("Fixed:", warning_msg, "\n")
cat("\nSaved to data/mnl_mnp_benchmark.rda\n")
