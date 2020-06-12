
# Build Script ------------------------------------------------------------
kaggle_build_script <- function(command) {
  cat("Executing command: ", command, "\n\n")
  tmp <- tempfile()
  on.exit(unlink(tmp))
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
kaggle_command_to_df <- function(command) {
  cat("Executing command: ", command, "\n\n")
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp))
  kaggle_build_script(paste(command, "--csv", "&>", tmp))
  return(utils::read.csv(tmp))
}
