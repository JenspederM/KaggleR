
#' View Current Config Values
#'
#' @examples
#' kaggle_config_view()
#'
#'
#' @export
kaggle_config_view <- function() {
  cmd <- "config view"
  return(kaggle_get_config(cmd))
}

#' Set a Configuration Value
#'
#' Valid values depending on name
#' - competition: Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' - path: Folder where file(s) will be downloaded, defaults to current working directory
#' - proxy: Proxy for HTTP requests
#'
#' @param name Name of the configuration parameter One of competition, path, or proxy
#' @param value Value of the configuration parameter
#'
#'
#' @examples
#' \dontrun{
#' kaggle_config_set(name = "competition", value = "titanic")
#' }
#'
#'
#' @export
kaggle_config_set <- function(name, value) {
  cmd <- paste("config set",
               "--name", match.arg(name, choices = c("competition", "path", "proxy")),
               "--value", value)
  return(kaggle_build_script(cmd))
}

#' Clear a configuration value
#'
#' @param name Name of the configuration parameter. One of competition, path, or proxy
#'
#'
#' @examples
#' \dontrun{
#' kaggle_config_unset(name = "competition")
#' }
#'
#'
#' @export
kaggle_config_unset <- function(name) {
  cmd <- paste("config unset",
               "--name", match.arg(name, choices = c("competition", "path", "proxy")))
  return(kaggle_build_script(cmd))
}
