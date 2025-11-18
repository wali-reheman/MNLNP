#!/usr/bin/env Rscript
# Check all .Rd files for errors

rd_files <- list.files("man", pattern = "\\.Rd$", full.names = TRUE)

cat("Checking", length(rd_files), ".Rd files...\n\n")

errors <- list()

for (rd_file in rd_files) {
  result <- tryCatch({
    capture.output(tools::checkRd(rd_file))
  }, error = function(e) {
    paste("ERROR:", conditionMessage(e))
  })

  # Check if there were any errors/warnings
  error_lines <- grep("prepare_Rd:|checkRd:|Error:", result, value = TRUE)

  if (length(error_lines) > 0) {
    cat("===", basename(rd_file), "===\n")
    cat(paste(error_lines[1:min(3, length(error_lines))], collapse = "\n"), "\n\n")
    errors[[basename(rd_file)]] <- error_lines
  }
}

cat("\nSummary:\n")
cat("Total files:", length(rd_files), "\n")
cat("Files with errors:", length(errors), "\n")
cat("Files passing:", length(rd_files) - length(errors), "\n")

if (length(errors) > 0) {
  cat("\nFiles with errors:\n")
  print(names(errors))
}
