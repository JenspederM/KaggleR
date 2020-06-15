
# Build Script ------------------------------------------------------------
kaggle_build_script <- function(command, verbose = TRUE) {
  on.exit(unlink(tmp))
  if (isTRUE(verbose)) {
    cat("Executing command: ", command, "\n\n")
  }
  tmp <- tempfile()
  write(file = tmp,
        x = paste("#!/bin/bash",
                  "export PATH='~/.local/bin:$PATH'",
                  "source ~/.bashrc",
                  command, sep = "\n"))
  system(paste0("chmod +x ", tmp))
  system(tmp)
  return(invisible(NULL))
}


# Redirect output to csv and read as data.frame ---------------------------
kaggle_command_to_df <- function(command, verbose = TRUE) {
  on.exit(unlink(tmp))
  if (isTRUE(verbose)) {
    cat("Executing command: ", command, "\n\n")
  }
  tmp <- tempfile(fileext = ".csv")
  kaggle_build_script(paste(command, "--csv", "&>", tmp), verbose = FALSE)
  return(utils::read.csv(tmp))
}


# Redirect output to csv and read as list ---------------------------------
kaggle_get_config <- function(command, verbose = TRUE) {
  on.exit(unlink(tmp))
  if (isTRUE(verbose)) {
    cat("Executing command: ", command, "\n\n")
  }
  tmp <- tempfile(fileext = ".csv")
  kaggle_build_script(paste(command, "&>", tmp), verbose = FALSE)
  output <- readLines(tmp)[-1]
  output <- gsub("-", "", output)
  output <- strsplit(output, ":")
  output_names <- lapply(output, function(x) trimws(x[[1]]))
  output_values <- lapply(output, function(x) trimws(x[[2]]))
  output <- setNames(output_values, output_names)
  return(output)
}


# Function builder for argument definitions -------------------------------

kaggle_build_add_argument <- function(argument = NULL, type = c("istrue", "isnull", "check")) {
  type <- match.arg(type)

  switch (type,
    istrue = return(
      function(command, value = NULL) {
        if (isTRUE(value)) {
          return(paste(command, argument, value))
        }
      }
    ),
    isnull = return(
      function(command, value = NULL) {
        if (!is.null(value)) {
          return(paste(command, argument, value))
        } else {
          return(command)
        }
      }
    ),
    check = return(
      function(command, value = NULL) {
        if (!is.null(value)) {
          return(paste(command, value))
        } else {
          return(command)
        }
      }
    )
  )
}

# Functions to add arguments ----------------------------------------------

# General
add_quiet <- kaggle_build_add_argument(argument = "--quiet", "istrue")
add_force <- kaggle_build_add_argument(argument = "--force", type = "istrue")
add_path <- kaggle_build_add_argument(argument = "--path", type = "isnull")

# Competitions List
add_group <- kaggle_build_add_argument(argument = "--group", type = "isnull")
add_category <- kaggle_build_add_argument(argument = "--category", type = "isnull")
add_sort_by <- kaggle_build_add_argument(argument = "--sort-by", type = "isnull")
add_page <- kaggle_build_add_argument(argument = "--page", type = "isnull")
add_search <- kaggle_build_add_argument(argument = "--search", type = "isnull")

# Competitions Download
add_file_name <- kaggle_build_add_argument(argument = "--file", type = "isnull")

# Competitions Leaderboard
add_show <- kaggle_build_add_argument(argument = "--show", type = "istrue")
add_download <- kaggle_build_add_argument(argument = "--download", type = "istrue")


