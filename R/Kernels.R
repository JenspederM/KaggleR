
#' List Kernels
#'
#' @param search Term(s) to search for
#' @param parent Find children of the specified parent kernel
#' @param competition Find kernels for a given competition
#' @param dataset Find kernels for a given dataset
#' @param mine Display only my items
#' @param size Number of kernels to list. Default size is 20, max is 100
#' @param user Find kernels created by a given user
#' @param language Specify the language the kernel is written in. Default is 'all'. Valid options are 'all', 'python', 'r', 'sqlite', and 'julia'
#' @param kernel_type Specify the type of kernel. Default is 'all'. Valid options are 'all', 'script', and 'notebook'
#' @param output_type Search for specific kernel output types. Default is 'all'. Valid options are 'all', 'visualizations', and 'data'
#' @param sort_by Sort list results. Default is 'hotness'.  Valid options are 'hotness', 'commentCount', 'dateCreated', 'dateRun', 'relevance', 'scoreAscending', 'scoreDescending', 'viewCount', and 'voteCount'. 'relevance' is only applicable if a search term is specified.
#' @export
#' @examples
#' kaggle_kernels_list(search = "titanic")
#' kaggle_kernels_list(language = "python")
kaggle_kernels_list <- function(mine = FALSE, size = 20, search = NULL, parent = NULL,
                                competition = NULL, dataset = NULL, user = NULL,
                                language = c("all", "python", "r", "sqlite", "julia"),
                                kernel_type = c("all", "script", "notebook"),
                                output_type = c("all", "visualizations", "data"),
                                sort_by = c('hotness', 'commentCount', 'dateCreated', 'dateRun', 'relevance', 'scoreAscending', 'scoreDescending', 'viewCount', 'voteCount')) {
  language <- match.arg(language)
  kernel_type <- match.arg(kernel_type)
  output_type <- match.arg(output_type)
  sort_by <- match.arg(sort_by)
  cmd <- paste("kaggle kernels list",
               "--language", language,
               "--kernel-type", kernel_type,
               "--output-type", output_type,
               "--sort-by", sort_by,
               "--page-size", size)
  if (isTRUE(mine)) {
    cmd <- paste(cmd, "--mine")
  }
  if (!is.null(search)) {
    cmd <- paste(cmd, "--search", search)
  }
  if (!is.null(parent)) {
    cmd <- paste(cmd, "--parent", parent)
  }
  if (!is.null(competition)) {
    cmd <- paste(cmd, "--competition", competition)
  }
  if (!is.null(dataset)) {
    cmd <- paste(cmd, "--dataset", dataset)
  }
  if (!is.null(user)) {
    cmd <- paste(cmd, "--user", user)
  }

  return(kaggle_command_to_df(cmd))
}


#' Initialize Metadata File for a Kernel
#'
#' @param folder Folder for upload, containing data files and a special kernel-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Kernel-Metadata).
#' @export
#' @examples
#' kaggle_kernels_init(folder = "./path/to/kernel")
kaggle_kernels_init <- function(folder) {
  cmd <- paste("kaggle kernels init --path", folder)
  return(kaggle_build_script(cmd))
}

#' Push a Kernel
#'
#' @param folder Folder for upload, containing data files and a special kernel-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Kernel-Metadata).
#' @export
#' @examples
#' kaggle_kernels_push(folder = "./path/to/kernel")
kaggle_kernels_push <- function(folder) {
  cmd <- paste("kaggle kernels push --path", folder)
  return(kaggle_build_script(cmd))
}


#' Pull a Kernel
#'
#' @param kernel Kernel URL suffix in format <owner>/<kernel-name> (use `kaggle_kernels_list()` to show options)
#' @param path Folder where file(s) will be downloaded, defaults to current working directory
#' @param metadata Generate metadata when pulling kernel
#' @export
#' @examples
#' kaggle_kernels_pull(kernel = "rtatman/list-of-5-day-challenges", path = "/path/to/dest")
kaggle_kernels_pull <- function(kernel, path = NULL, metadata = FALSE) {
  cmd <- paste("kaggle kernels pull", kernel)
  if (!is.null(path)) {
    cmd <- paste(cmd, "--path", path)
  }
  if (isTRUE(metadata)) {
    cmd <- paste(cmd, "--metadata")
  }
  return(kaggle_build_script(cmd))
}


#' Retrieve a Kernel's output
#'
#' @param kernel Kernel URL suffix in format <owner>/<kernel-name> (use `kaggle_kernels_list()` to show options)
#' @param path Folder where file(s) will be downloaded, defaults to current working directory
#' @param force Skip check whether local version of file is up to date, force file download
#' @param quiet Suppress printing information about the upload/download progress
#' @export
#' @examples
#' kaggle_kernels_output(kernel = "mrisdal/exploring-survival-on-the-titanic", path = "/path/to/dest")
kaggle_kernels_output <- function(kernel, path = NULL, force = FALSE, quiet = FALSE) {
  cmd <- paste("kaggle kernels output", kernel)
  if (!is.null(path)) {
    cmd <- paste(cmd, "--path", path)
  }
  if (isTRUE(force)) {
    cmd <- paste(cmd, "--force")
  }
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }
  return(kaggle_build_script(cmd))
}


#' Get the Status of the Latest Kernel Run
#'
#' @param kernel Kernel URL suffix in format <owner>/<kernel-name> (use `kaggle_kernels_list()` to show options)
#' @export
#' @examples
#' kaggle_kernels_status(kernel = "mrisdal/exploring-survival-on-the-titanic")
kaggle_kernels_status <- function(kernel) {
  cmd <- paste("kaggle kernels output", kernel)
  return(kaggle_build_script(cmd))
}


