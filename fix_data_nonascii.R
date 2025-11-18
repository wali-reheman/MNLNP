#!/usr/bin/env Rscript
# Fix non-ASCII in data files

cat("Fixing non-ASCII in data files...\n\n")

# Load mnl_mnp_benchmark
if (file.exists("data/mnl_mnp_benchmark.rda")) {
  load("data/mnl_mnp_benchmark.rda")

  # Check for non-ASCII in note attribute
  note <- attr(mnl_mnp_benchmark, "note")
  if (!is.null(note)) {
    cat("Original note:", substr(note, 1, 50), "...\n")

    # Remove warning emoji and replace with ASCII
    note <- gsub("\u26a0\ufe0f", "WARNING:", note)
    note <- gsub("\u26a0", "WARNING:", note)

    attr(mnl_mnp_benchmark, "note") <- note
    save(mnl_mnp_benchmark, file = "data/mnl_mnp_benchmark.rda")

    cat("Fixed note:", substr(note, 1, 50), "...\n")
    cat("Saved: data/mnl_mnp_benchmark.rda\n")
  } else {
    cat("No note attribute found\n")
  }
} else {
  cat("File not found: data/mnl_mnp_benchmark.rda\n")
}

cat("\nDone!\n")
