
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
#' @export
kaggle_competitions_list <- function(group = c('general', 'entered', 'inClass'),
                                     category = c('all', 'featured', 'research', 'recruitment', 'gettingStarted', 'masters', 'playground'),
                                     sort_by = c('latestDeadline','grouped', 'prize', 'earliestDeadline',  'numberOfTeams', 'recentlyCreated'),
                                     search = NULL) {
  group <- match.arg(group)
  category <- match.arg(category)
  sort_by <- match.arg(sort_by)
  cmd <- paste("kaggle competitions list", "--group", group, "--category", category, "--sort-by", sort_by)
  if (!is.null(search)) {
    cmd <- paste(cmd, "--search", search)
  }
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
#' @export
kaggle_competitions_files <- function(competition, quiet = FALSE) {
  cmd <- paste("kaggle competitions files", competition)
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

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
  cmd <- "kaggle competitions download"
  if (!is.null(file_name)) {
    cmd <- paste(cmd, "-f", file_name)
  }
  if (!is.null(path)) {
    cmd <- paste(cmd, "-p", path)
  }
  if (isTRUE(force)) {
    cmd <- paste(cmd, "--force")
  }
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

  kaggle_build_script(cmd)

  return(invisible(NULL))
}

#' Submit to a Competition
#'
#' Note: you will need to accept competition rules at https://www.kaggle.com/c/<competition-name>/rules.
#'
#' @param competition Competition URL suffix (use `kaggle_competitions_list()` to show options)
#' @param file_name File for upload (full path)
#' @param message Message describing this submission
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
kaggle_competitions_submit <- function(competition, file_name, message, quiet = FALSE) {
  cmd <- paste("kaggle competitions submit", competition, "-f", file_name, "-m", message)
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

  kaggle_build_script(cmd)

  return(invisible(NULL))
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
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

  return(kaggle_command_to_df(cmd))
}

#' Get Competition Leaderboard
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
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

  if (isTRUE(show) && !isTRUE(download)) {
    cmd <- paste(cmd, "--show")

    return(kaggle_command_to_df(cmd))
  }

  if (isTRUE(show) && isTRUE(download)) {

    cmd_dl <- paste(cmd, "--download")
    if (!is.null(path)) {
      cmd_dl <- paste(cmd_dl, "--path", path)
    }

    kaggle_build_script(cmd_dl)

    cmd <- paste(cmd, "--show")

    return(kaggle_command_to_df(cmd))
  }

  if (isTRUE(download)) {
    cmd <- paste(cmd, "--download")
    if (!is.null(path)) {
      cmd <- paste(cmd, "--path", path)
    }


    return(kaggle_build_script(cmd))
  }
}
