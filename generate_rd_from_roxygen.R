#!/usr/bin/env Rscript
# Parse roxygen2 comments from R source files and generate .Rd documentation
# This is a workaround when roxygen2 package can't be installed

cat("Generating .Rd documentation from roxygen2 comments...\n\n")

# Function to extract roxygen comments from an R file
extract_roxygen_docs <- function(file_path) {
  lines <- readLines(file_path, warn = FALSE)

  # Find roxygen blocks (lines starting with #')
  roxygen_lines <- grep("^#'", lines)

  if (length(roxygen_lines) == 0) return(NULL)

  # Extract blocks (consecutive roxygen lines followed by function definition)
  blocks <- list()
  current_block <- NULL

  for (i in seq_along(lines)) {
    if (grepl("^#'", lines[i])) {
      if (is.null(current_block)) {
        current_block <- list(start = i, lines = character())
      }
      # Remove #' prefix and trim
      content <- sub("^#'\\s?", "", lines[i])
      current_block$lines <- c(current_block$lines, content)
    } else if (!is.null(current_block)) {
      # Check if this is a function definition
      if (grepl("^[a-zA-Z_][a-zA-Z0-9_.]*\\s*(<-|=)\\s*function", lines[i])) {
        func_name <- sub("\\s*(<-|=).*", "", lines[i])
        func_name <- trimws(func_name)
        current_block$function_name <- func_name
        # Capture multi-line function signature
        func_lines <- lines[i]
        j <- i
        # Keep adding lines until we find the closing ) after function(
        while (j <= length(lines) && !grepl("\\)\\s*\\{", func_lines[length(func_lines)])) {
          j <- j + 1
          if (j <= length(lines)) {
            func_lines <- c(func_lines, lines[j])
          }
        }
        current_block$function_line <- paste(func_lines, collapse = "\n")
        blocks[[func_name]] <- current_block
      }
      current_block <- NULL
    }
  }

  return(blocks)
}

# Function to parse function signature
parse_function_signature <- function(func_line) {
  # Handle multi-line function definitions
  # Extract everything from "function" to the closing ")" before "{"
  func_text <- gsub("\n", " ", func_line)  # Collapse to single line

  # Extract function(...) part
  match <- regexpr("function\\s*\\([^{]*\\)(?=\\s*\\{)", func_text, perl = TRUE)
  if (match > 0) {
    sig <- regmatches(func_text, match)
    # Clean up extra whitespace
    sig <- gsub("\\s+", " ", sig)
    sig <- trimws(sig)
    return(sig)
  }
  return("function(...)")
}

# Function to convert roxygen block to .Rd content
roxygen_to_rd <- function(func_name, block) {
  lines <- block$lines
  func_sig <- parse_function_signature(block$function_line)

  # Parse roxygen tags
  title <- ""
  description <- character()
  params <- list()
  return_val <- character()
  examples <- character()
  details <- character()
  export <- FALSE

  in_description <- FALSE
  in_details <- FALSE
  in_return <- FALSE
  in_examples <- FALSE
  current_param <- NULL

  for (line in lines) {
    if (grepl("^@title", line)) {
      title <- sub("^@title\\s+", "", line)
    } else if (grepl("^@description", line)) {
      in_description <- TRUE
      in_details <- FALSE
      in_return <- FALSE
      in_examples <- FALSE
      desc_text <- sub("^@description\\s*", "", line)
      # Only add if there's content after the tag
      if (nchar(trimws(desc_text)) > 0) description <- c(description, desc_text)
    } else if (grepl("^@param", line)) {
      in_description <- FALSE
      in_details <- FALSE
      in_return <- FALSE
      in_examples <- FALSE
      # Extract param name and description
      param_text <- sub("^@param\\s+", "", line)
      parts <- strsplit(param_text, "\\s+", perl = TRUE)[[1]]
      param_name <- parts[1]
      param_desc <- paste(parts[-1], collapse = " ")
      current_param <- param_name
      params[[param_name]] <- param_desc
    } else if (grepl("^@return", line)) {
      in_return <- TRUE
      in_description <- FALSE
      in_details <- FALSE
      in_examples <- FALSE
      return_text <- sub("^@return\\s*", "", line)
      # Only add if there's content after the tag
      if (nchar(trimws(return_text)) > 0) return_val <- c(return_val, return_text)
    } else if (grepl("^@examples", line)) {
      in_examples <- TRUE
      in_description <- FALSE
      in_details <- FALSE
      in_return <- FALSE
    } else if (grepl("^@details", line)) {
      in_details <- TRUE
      in_description <- FALSE
      in_return <- FALSE
      in_examples <- FALSE
      details_text <- sub("^@details\\s*", "", line)
      # Only add if there's content after the tag
      if (nchar(trimws(details_text)) > 0) details <- c(details, details_text)
    } else if (grepl("^@export", line)) {
      export <- TRUE
    } else if (grepl("^@", line)) {
      # Other tags, skip for now
      in_description <- FALSE
      in_details <- FALSE
      in_return <- FALSE
      in_examples <- FALSE
    } else {
      # Continuation of current section
      if (in_description) {
        description <- c(description, line)
      } else if (in_details) {
        details <- c(details, line)
      } else if (in_return) {
        return_val <- c(return_val, line)
      } else if (in_examples) {
        examples <- c(examples, line)
      } else if (!is.null(current_param) && nchar(line) > 0) {
        params[[current_param]] <- paste(params[[current_param]], line)
      } else if (title == "" && nchar(line) > 0) {
        # First non-empty line is title if not set
        title <- line
      } else if (nchar(line) > 0) {
        description <- c(description, line)
      }
    }
  }

  # Build .Rd content
  rd <- character()
  rd <- c(rd, paste0("\\name{", func_name, "}"))
  rd <- c(rd, paste0("\\alias{", func_name, "}"))
  rd <- c(rd, paste0("\\title{", if (title != "") title else tools::toTitleCase(gsub("_", " ", func_name)), "}"))

  # Description
  if (length(description) > 0) {
    rd <- c(rd, "\\description{")
    rd <- c(rd, paste(description, collapse = "\n"))
    rd <- c(rd, "}")
  }

  # Usage
  rd <- c(rd, "\\usage{")
  rd <- c(rd, paste0(func_name, sub("function", "", func_sig)))
  rd <- c(rd, "}")

  # Arguments
  if (length(params) > 0) {
    rd <- c(rd, "\\arguments{")
    for (pname in names(params)) {
      rd <- c(rd, paste0("\\item{", pname, "}{", params[[pname]], "}"))
    }
    rd <- c(rd, "}")
  }

  # Details
  if (length(details) > 0) {
    rd <- c(rd, "\\details{")
    rd <- c(rd, paste(details, collapse = "\n"))
    rd <- c(rd, "}")
  }

  # Return value
  if (length(return_val) > 0) {
    rd <- c(rd, "\\value{")
    # Split return value into description and \item entries
    has_items <- any(grepl("^\\s*\\\\item\\{", return_val))
    if (has_items) {
      # Find where \item entries start
      item_start <- which(grepl("^\\s*\\\\item\\{", return_val))[1]
      if (item_start > 1) {
        # Add description before \item entries
        rd <- c(rd, paste(return_val[1:(item_start-1)], collapse = "\n"))
      }
      # Wrap \item entries in \describe{}
      rd <- c(rd, "\\describe{")
      rd <- c(rd, paste(return_val[item_start:length(return_val)], collapse = "\n"))
      rd <- c(rd, "}")
    } else {
      rd <- c(rd, paste(return_val, collapse = "\n"))
    }
    rd <- c(rd, "}")
  }

  # Examples
  if (length(examples) > 0) {
    rd <- c(rd, "\\examples{")
    rd <- c(rd, paste(examples, collapse = "\n"))
    rd <- c(rd, "}")
  }

  return(rd)
}

# Process all R files
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
total_generated <- 0

for (r_file in r_files) {
  cat("Processing:", basename(r_file), "...")

  blocks <- extract_roxygen_docs(r_file)

  if (is.null(blocks) || length(blocks) == 0) {
    cat(" no roxygen docs found\n")
    next
  }

  for (func_name in names(blocks)) {
    rd_content <- roxygen_to_rd(func_name, blocks[[func_name]])

    # Write to man/ directory
    rd_file <- file.path("man", paste0(func_name, ".Rd"))
    writeLines(rd_content, rd_file)
    total_generated <- total_generated + 1
  }

  cat(" generated", length(blocks), "files\n")
}

cat("\nTotal .Rd files generated:", total_generated, "\n")
cat("Documentation generation complete!\n")
