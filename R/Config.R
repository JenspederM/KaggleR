
#' View Current Config Values
#'
#' @export
#' @examples
#' kaggle_config_view()
kaggle_config_view <- function() {
  cmd <- "kaggle config view"
  return(kaggle_build_script(cmd))
}

#' Set a Configuration Value
#'
#' Valid values depending on name
#' - competition: Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' - path: Folder where file(s) will be downloaded, defaults to current working directory
#' - proxy: Proxy for HTTP requests
#'
#' @param name Name of the configuration parameter (one of competition, path, proxy)
#' @param value Value of the configuration parameter
#' @export
#' @examples
#' kaggle_config_set(name = "competition", value = "titanic")
kaggle_config_set <- function(name, value) {
  name <- match.arg(name, choices = c("competition", "path", "proxy"))
  cmd <- paste("kaggle config set --name", name, "--value", value)
  return(kaggle_build_script(cmd))
}

#' Clear a configuration value
#'
#' @param name Name of the configuration parameter
#' @export
#' @examples
#' kaggle_config_unset(name = "competition")
kaggle_config_unset <- function(name) {
  name <- match.arg(name, choices = c("competition", "path", "proxy"))
  cmd <- paste("kaggle config unset --name", name)
  return(kaggle_build_script(cmd))
}
