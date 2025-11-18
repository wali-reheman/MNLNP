#!/usr/bin/env Rscript
# Fix non-ASCII characters in R source files for CRAN compliance

cat("Fixing non-ASCII characters in R files...\n\n")

# Files that need fixing (from R CMD check)
files <- c(
  "R/brier_score.R",
  "R/convergence_report.R",
  "R/create_data.R",
  "R/decision_framework.R",
  "R/diagnostics.R",
  "R/dropout_scenario.R",
  "R/flexible_mnl.R",
  "R/functional_form_test.R",
  "R/iia_and_decision.R",
  "R/model_choice_consequences.R",
  "R/recommend_model.R",
  "R/sample_size_calculator.R",
  "R/substitution_matrix.R",
  "R/visualization.R"
)

# Replacement mappings (non-ASCII -> ASCII)
replacements <- list(
  # Emoji and special symbols
  "\u26a0\ufe0f" = "WARNING:",  # ⚠️ warning emoji
  "\u26a0" = "WARNING:",        # ⚠ warning sign
  "\u2713" = "[OK]",            # ✓ checkmark
  "\u2714" = "[OK]",            # ✔ heavy checkmark
  "\u2717" = "[X]",             # ✗ ballot X
  "\u2718" = "[X]",             # ✘ heavy ballot X

  # Mathematical symbols
  "\u2192" = "->",              # → rightwards arrow
  "\u2190" = "<-",              # ← leftwards arrow
  "\u2265" = ">=",              # ≥ greater-than or equal to
  "\u2264" = "<=",              # ≤ less-than or equal to
  "\u00b1" = "+/-",             # ± plus-minus
  "\u2248" = "~=",              # ≈ almost equal
  "\u00d7" = "x",               # × multiplication

  # Punctuation
  "\u2022" = "*",               # • bullet
  "\u2013" = "-",               # – en dash
  "\u2014" = "--",              # — em dash
  "\u2018" = "'",               # ' left single quote
  "\u2019" = "'",               # ' right single quote
  "\u201c" = '"',               # " left double quote
  "\u201d" = '"'                # " right double quote
)

total_replacements <- 0

for (file in files) {
  if (!file.exists(file)) {
    cat(sprintf("  Skip: %s (not found)\n", file))
    next
  }

  # Read file
  content <- readLines(file, warn = FALSE)
  original <- content

  # Apply all replacements
  for (old in names(replacements)) {
    new <- replacements[[old]]
    content <- gsub(old, new, content, fixed = FALSE)
  }

  # Count changes
  changed <- sum(content != original)

  if (changed > 0) {
    # Write back
    writeLines(content, file)
    total_replacements <- total_replacements + changed
    cat(sprintf("  Fixed: %s (%d lines changed)\n", file, changed))
  } else {
    cat(sprintf("  Clean: %s (no changes needed)\n", file))
  }
}

cat(sprintf("\nTotal: %d lines fixed across %d files\n", total_replacements, length(files)))
cat("\nVerifying: Searching for remaining non-ASCII characters...\n")

# Verify no non-ASCII remains
for (file in files) {
  if (file.exists(file)) {
    content <- readLines(file, warn = FALSE)
    # Check for non-ASCII (excluding comments might be OK, but let's be strict)
    non_ascii_lines <- grep("[^\x01-\x7F]", content, perl = TRUE)
    if (length(non_ascii_lines) > 0) {
      cat(sprintf("  WARNING: %s still has non-ASCII on lines: %s\n",
                  file, paste(non_ascii_lines, collapse = ", ")))
    }
  }
}

cat("\nDone!\n")
