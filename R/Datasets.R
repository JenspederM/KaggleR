
#' List Datasets
#'
#' @param sort_by Sort list results. Default is 'hottest'. Valid options are 'hottest', 'votes', 'updated', and 'active'
#' @param file_type Search for datasets with a specific file type. Default is 'all'. Valid options are 'all', 'csv', 'sqlite', 'json', and 'bigQuery'. Please note that bigQuery datasets cannot be downloaded
#' @param license_name Search for datasets with a specific license. Default is 'all'. Valid options are 'all', 'cc', 'gpl', 'odb', and 'other'
#' @param max_size Specify the maximum size of the dataset to return (bytes)
#' @param min_size Specify the minimum size of the dataset to return (bytes)
#' @param tag_ids Search for datasets that have specific tags. Tag list should be comma separated
#' @param search Term(s) to search for
#' @param mine Display only my items
#' @param user Find public datasets owned by a specific user or organization
#'
#'
#' @examples
#' kaggle_datasets_list(search = "demographies")
#' kaggle_datasets_list(sort_by = "votes")
#'
#'
#' @export
kaggle_datasets_list <- function(sort_by = c('hottest', 'votes', 'updated', 'active'),
                                 file_type = c('all', 'csv', 'sqlite', 'json', 'bigQuery'),
                                 license_name = c('all', 'cc', 'gpl', 'odb', 'other'),
                                 max_size = NULL, min_size = NULL,  tag_ids = NULL,
                                 search = NULL, mine = NULL, user = NULL) {
  sort_by <- match.arg(sort_by)
  file_type <- match.arg(file_type)
  license_name <- match.arg(license_name)
  cmd <- paste("kaggle datasets list", "--sort-by", sort_by, "--file-type", file_type, "--license", license_name)
  if (!is.null(max_size)) {
    cmd <- paste(cmd, "--max-size", max_size)
  }
  if (!is.null(min_size)) {
    cmd <- paste(cmd, "--min-size", min_size)
  }
  if (!is.null(tag_ids)) {
    if (length(tag_ids) > 1) {
      tag_ids <- paste(tag_ids, collapse = ", ")
    }
    cmd <- paste(cmd, "--tags", tag_ids)
  }
  if (!is.null(search)) {
    cmd <- paste(cmd, "--search", search)
  }
  if (!is.null(mine)) {
    cmd <- paste(cmd, "--mine")
  }
  if (!is.null(user)) {
    cmd <- paste(cmd, "--user", user)
  }

  return(kaggle_command_to_df(cmd))
}


#' List Files for a Dataset
#'
#' @param dataset  Dataset URL suffix in format <owner>/<dataset-name> (use "kaggle_datasets_list()" to show options)
#'
#'
#' @examples
#' kaggle_datasets_files("zillow/zecon")
#'
#'
#' @export
kaggle_datasets_files <- function(dataset) {
  cmd <- paste("kaggle datasets files", dataset)
  return(kaggle_command_to_df(cmd))
}


#' Download dataset files
#'
#' Please note that BigQuery datasets cannot be downloaded.
#'
#' @param dataset Dataset URL suffix in format <owner>/<dataset-name> (use "kaggle_datasets_list()" to show options)
#' @param file_name File name, all files downloaded if not provided (use kaggle_datasets_files(dataset = "<owner>/<dataset-name>") to show options)
#' @param path Folder where file(s) will be downloaded, defaults to current working directory
#' @param unzip Unzip the downloaded file. Will delete the zip file when completed.
#' @param force Skip check whether local version of file is up to date, force file download
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_datasets_download("zillow/zecon")
#' kaggle_datasets_download("zillow/zecon", file_name = "State_time_series.csv")
#'
#'
#' @export
kaggle_datasets_download <- function(dataset, file_name = NULL, path = NULL, unzip = FALSE, force = FALSE, quiet = FALSE) {
  cmd <- paste("kaggle datasets download", dataset)
  if (!is.null(file_name)) {
    cmd <- paste(cmd, "--file", file_name)
  }
  if (!is.null(path)) {
    cmd <- paste(cmd, "--path", path)
  }
  if (isTRUE(unzip)) {
    cmd <- paste(cmd, "--unzip")
  }
  if (isTRUE(force)) {
    cmd <- paste(cmd, "--force")
  }
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }

  return(kaggle_build_script(cmd))
}

#' Initialize Metadata file for Dataset Creation
#'
#' @param folder Folder for upload, containing data files and a special dataset-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata).
#'
#'
#' @examples
#' kaggle_datasets_init(folder = "./path/to/dataset")
#'
#'
#' @export
kaggle_datasets_init <- function(folder) {
  cmd <- paste("kaggle datasets init --path", folder)
}



#' Create a new dataset
#'
#'
#' @param folder Folder for upload, containing data files and a special dataset-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata).
#' @param public Create publicly (default is private)
#' @param keep_tabular Do not convert tabular files to CSV (default is to convert)
#' @param quiet Suppress printing information about the upload/download progress
#' @param dir_mode What to do with directories: "skip" - ignore; "zip" - compressed upload; "tar" - uncompressed upload
#'
#'
#' @examples
#' kaggle_datasets_create(folder = "./path/to/dataset")
#'
#'
#' @export
kaggle_datasets_create <- function(folder, public = FALSE, keep_tabular = FALSE, dir_mode = c("skip", "zip", "tar"), quiet = FALSE) {
  dir_mode <- match.arg(dir_mode)
  cmd <- paste("kaggle datasets create --path", folder, "--dir-mode", dir_mode)
  if (isTRUE(public)) {
    cmd <- paste(cmd, "--public")
  }
  if (isTRUE(keep_tabular)) {
    cmd <- paste(cmd, "--keep-tabular")
  }
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }
  return(kaggle_build_script(cmd))
}


#' Creata a New Dataset Version
#'
#' @param folder Folder for upload, containing data files and a special dataset-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata).
#' @param version_notes Message describing the new version
#' @param keep_tabular Do not convert tabular files to CSV (default is to convert)
#' @param dir_mode What to do with directories: "skip" - ignore; "zip" - compressed upload; "tar" - uncompressed upload
#' @param delete_old_versions Delete old versions of this dataset
#' @param quiet Suppress printing information about the upload/download progress
#'
#'
#' @examples
#' kaggle_datasets_version(folder = "./path/to/dataset", version_notes = "Updated data")
#'
#'
#' @export
kaggle_datasets_version <- function(folder, version_notes, keep_tabular = FALSE, dir_mode = c("skip", "zip", "tar"), delete_old_versions = FALSE, quiet = FALSE) {
  dir_mode <- match.arg(dir_mode)
  cmd <- paste("kaggle datasets version --path", folder, "--message", version_notes)
  if (isTRUE(keep_tabular)) {
    cmd <- paste(cmd, "--keep-tabular")
  }
  if (isTRUE(delete_old_versions)) {
    cmd <- paste(cmd, "--delete-old-versions")
  }
  if (isTRUE(quiet)) {
    cmd <- paste(cmd, "--quiet")
  }
  return(kaggle_build_script(cmd))
}


#' Download Metadata for an Existing Dataset
#'
#' @param dataset Dataset URL suffix in format <owner>/<dataset-name> (use `kaggle_datasets_list()`to show options)
#' @param path Location to download dataset metadata to. Defaults to current working directory
#'
#'
#' @examples
#' kaggle_datasets_metadata(dataset = "zillow/zecon", path = "./path/to/download")
#'
#'
#' @export
kaggle_datasets_metadata <- function(dataset, path = NULL) {
  cmd <- paste("kaggle datasets metadata", dataset)
  if (!is.null(path)) {
    cmd <- paste(cmd, "--path", path)
  }
  return(kaggle_build_script(cmd))
}

#' Get Dataset Creation Status
#'
#' @param dataset dataset Dataset URL suffix in format <owner>/<dataset-name> (use `kaggle_datasets_list()`to show options)
#'
#'
#' @examples
#' kaggle_datasets_status("zillow/zecon")
#'
#'
#' @export
kaggle_datasets_status <- function(dataset) {
  cmd <- paste("kaggle datasets status", dataset)
  return(kaggle_build_script(cmd))
}
