
# Build Script ------------------------------------------------------------
kaggle_build_script <- function(command, verbose = TRUE) {
  if (isTRUE(verbose)) cat("Executing command: kaggle", command, "\n\n")

  if (.Platform$OS.type == "unix") {
    path <- "PATH=~/.local/bin:$PATH"
    path <- "PATH=~/.asdf/shims:$PATH"
  } else if (.Platform$OS.type == "windows") {
    path <- character()
  } else {
    stop("Unable to determine OS")
  }

  kaggle_call <- system2("kaggle", command, env = path, stdout = TRUE, stderr = "error.log")

  if (grepl("--csv", command)) {
    tryCatch(
      return(utils::read.csv(text = kaggle_call)),
      error = function(e) {
        print(sprintf("There was a problem: %s", e))
        return(writeLines(kaggle_call))
      }
    )
  } else {
    return(writeLines(kaggle_call))
  }

  return(invisible(NULL))
}

# Redirect output to csv and read as list ---------------------------------
kaggle_get_config <- function(command, verbose = TRUE) {
  tmp <- system2("kaggle", "config view", env = path, stdout = TRUE)
  if (isTRUE(verbose)) cat(tmp[1])
  tmp <- tmp[-1]
  tmp <- gsub("-|:", "", tmp)
  tmp <- trimws(tmp)
  tmp <- strsplit(tmp, " ")
  config_name <- vapply(tmp, `[[`, 1, FUN.VALUE = "")
  config_value <- vapply(tmp, `[[`, 2, FUN.VALUE = "")
  return(data.frame(config_name, config_value))
}


# Function builder for argument definitions -------------------------------

kaggle_build_add_argument <- function(argument = NULL, type = c("istrue", "isnull", "check")) {
  type <- match.arg(type)

  switch (type,
          istrue = return(
            function(command, value = NULL) {
              if (isTRUE(value)) {
                return(paste(command, argument))
              } else {
                return(command)
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


# > General --------------------------------------------------------------
add_quiet <- kaggle_build_add_argument(argument = "--quiet", "istrue")
add_force <- kaggle_build_add_argument(argument = "--force", type = "istrue")

# Download
add_file_name <- kaggle_build_add_argument(argument = "--file", type = "isnull")
add_path <- kaggle_build_add_argument(argument = "--path", type = "isnull")

# List
add_search <- kaggle_build_add_argument(argument = "--search", type = "isnull")
add_sort_by <- kaggle_build_add_argument(argument = "--sort-by", type = "isnull")
add_page <- kaggle_build_add_argument(argument = "--page", type = "isnull")
add_mine <- kaggle_build_add_argument(argument = "--mine", type = "istrue")
add_user <- kaggle_build_add_argument(argument = "--user", type = "isnull")

# Create/Version
add_keep_tabular <- kaggle_build_add_argument(argument = "--keep-tabular", type = "istrue")

# > Competitions ----------------------------------------------------------

# >> Competitions List ----------------------------------------------------
add_group <- kaggle_build_add_argument(argument = "--group", type = "isnull")
add_category <- kaggle_build_add_argument(argument = "--category", type = "isnull")

# >> Competitions Leaderboard ---------------------------------------------
add_show <- kaggle_build_add_argument(argument = "--show", type = "istrue")
add_download <- kaggle_build_add_argument(argument = "--download", type = "istrue")


# > Datasets --------------------------------------------------------------

# >> Datasets List --------------------------------------------------------
add_max_size <- kaggle_build_add_argument(argument = "--max-size", type = "isnull")
add_min_size <- kaggle_build_add_argument(argument = "--min-size", type = "isnull")
add_file_type <- kaggle_build_add_argument(argument = "--file-type", type = "isnull")
add_tags <- kaggle_build_add_argument(argument = "--tags", type = "isnull")

# >> Datasets Download ----------------------------------------------------
add_unzip <- kaggle_build_add_argument(argument = "--unzip", type = "istrue")

# >> Datasets Create ------------------------------------------------------
add_public <- kaggle_build_add_argument(argument = "--public", type = "istrue")

# >> Datasets Version -----------------------------------------------------
add_delete_old_versions <- kaggle_build_add_argument(argument = "--delete-old-versions", type = "istrue")
add_update <- kaggle_build_add_argument(argument = "--update", type = "istrue")


# > Kernels ---------------------------------------------------------------

# >> Kernels List ---------------------------------------------------------
add_page_size <- kaggle_build_add_argument(argument = "--page-size", type = "isnull")
add_parent <- kaggle_build_add_argument(argument = "--parent", type = "istrue")
add_competition <- kaggle_build_add_argument(argument = "--competition", type = "isnull")
add_dataset <- kaggle_build_add_argument(argument = "--dataset", type = "isnull")

# >> Kernels Pull ---------------------------------------------------------
add_metadata <- kaggle_build_add_argument(argument = "--metadata", type = "istrue")

