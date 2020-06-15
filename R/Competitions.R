
#' List Competitions
#'
#' @param group Search for competitions in a specific group. Default is 'general'. Valid options are 'general', 'entered', and 'inClass'
#' @param category Search for competitions of a specific category. Default is 'all'. Valid options are 'all', 'featured', 'research', 'recruitment', 'gettingStarted', 'masters', and 'playground'
#' @param sort_by Sort list results. Default is 'latestDeadline'. Valid options are 'grouped', 'prize', 'earliestDeadline', 'latestDeadline', 'numberOfTeams', and 'recentlyCreated'
#' @param search Term(s) to search for
#' @return `data.frame`
#'
#'
#' @examples
#' kaggle_competitions_list(category = "gettingStarted")
#' kaggle_competitions_list(search = "health")
#'
#'
#' @export
kaggle_competitions_list <- function(group = c('general', 'entered', 'inClass'),
                                     category = c('all', 'featured', 'research', 'recruitment', 'gettingStarted', 'masters', 'playground'),
                                     sort_by = c('latestDeadline','grouped', 'prize', 'earliestDeadline',  'numberOfTeams', 'recentlyCreated'),
                                     search = NULL) {
  cmd <- paste("kaggle competitions list",
               "--group", match.arg(group),
               "--category", match.arg(category),
               "--sort-by", match.arg(sort_by))
  cmd <- add_search(cmd, search)
  return(kaggle_command_to_df(cmd))
}

#' List Competition Files
#'
#' Note: you will need to accept competition rules at https://www.kaggle.com/c/<competition-name>/rules.
#'
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_competitions_files(competition = "favorita-grocery-sales-forecasting")
#'
#'
#' @export
kaggle_competitions_files <- function(competition, quiet = FALSE) {
  cmd <- paste("kaggle competitions files", competition)
  cmd <- add_quiet(cmd, quiet)
  return(kaggle_command_to_df(cmd))
}


#' Download Competition Files
#'
#' Note: you will need to accept competition rules at https://www.kaggle.com/c/<competition-name>/rules.
#'
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' @param file_name File name, all files downloaded if not provided
#' @param path Folder where file(s) will be downloaded, defaults to current working directory
#' @param force Skip check whether local version of file is up to date, force file download
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_competitions_download_files(competition = "favorita-grocery-sales-forecasting")
#' kaggle_competitions_download_files(competition = "favorita-grocery-sales-forecasting",
#'                                    file_name = "test.csv.7z")
#'
#'
#' @export
kaggle_competitions_download_files <- function(competition, file_name = NULL, path = NULL, force = FALSE, quiet = FALSE) {
  cmd <- paste("kaggle competitions download", competition)
  cmd <- add_file_name(cmd, file_name)
  cmd <- add_path(cmd, path)
  cmd <- add_force(cmd, force)
  cmd <- add_quiet(cmd, quiet)
  return(kaggle_build_script(cmd))
}

#' Submit to a Competition
#'
#' Note: you will need to accept competition rules at https://www.kaggle.com/c/<competition-name>/rules.
#'
#' @param file_name File for upload (full path)
#' @param message Message describing this submission
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options). If empty, the default competition will be used (use "kaggle config set competition")"
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_competitions_submit(competition = "favorita-grocery-sales-forecasting",
#'                            file_name = "sample_submission_favorita.csv.7z",
#'                            message = "My submission message")
#'
#'
#' @export
kaggle_competitions_submit <- function(file_name, message, competition = NULL, quiet = FALSE) {
  cmd <- paste("kaggle competitions submit",
               "--file", file_name,
               "--message", message)
  cmd <- add_quiet(cmd, quiet)

  return(kaggle_build_script(cmd))
}

#' List competition submissions
#'
#' Note: you will need to accept competition rules at https://www.kaggle.com/c/<competition-name>/rules.
#'
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_competitions_submissions(competition = "favorita-grocery-sales-forecasting")
#'
#'
#' @export
kaggle_competitions_submissions <- function(competition, quiet = FALSE) {
  cmd <- paste("kaggle competitions submissions", competition)
  cmd <- add_quiet(cmd, quiet)

  return(kaggle_command_to_df(cmd))
}

#' Get Competition Leaderboard
#'
#' If both download and show are `TRUE`, then quiet will be `TRUE` as well.
#'
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' @param show Show the top of the leaderboard
#' @param download Download entire leaderboard
#' @param path Folder where file(s) will be downloaded, defaults to current working directory
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_competitions_leaderboard(competition = "favorita-grocery-sales-forecasting")
#' kaggle_competitions_leaderboard(competition = "favorita-grocery-sales-forecasting",
#'                                 download = TRUE)
#' kaggle_competitions_leaderboard(competition = "favorita-grocery-sales-forecasting",
#'                                 download = TRUE, path = "./path")
#'
#'
#' @export
kaggle_competitions_leaderboard <- function(competition, show = TRUE, download = FALSE, path = NULL, quiet = FALSE) {
  cmd <- paste("kaggle competitions leaderboard", competition)
  cmd <- add_show(cmd, show)
  cmd <- add_download(cmd, download)
  cmd <- add_path(cmd, path)
  cmd <- add_quiet(cmd, quiet)

  if (isTRUE(show)) {
    if (isTRUE(quiet)) {
      return(kaggle_command_to_df(cmd))
    } else {
      cmd <- add_quiet(cmd, TRUE)
      return(kaggle_command_to_df(cmd))
    }
  } else {
    return(kaggle_build_script(cmd))
  }
}
