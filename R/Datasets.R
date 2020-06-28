
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
#' @param page Page number for results paging. Page size is 20 by default
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
                                 search = NULL, user = NULL, mine = FALSE, page = NULL) {
  if (length(tag_ids) > 1) {
    tag_ids <- paste(tag_ids, collapse = ", ")
  }
  cmd <- paste("datasets list",
               "--sort-by", match.arg(sort_by),
               "--file-type", match.arg(file_type),
               "--license", match.arg(license_name),
               "--csv")
  cmd <- add_tags(cmd, tag_ids)
  cmd <- add_search(cmd, search)
  cmd <- add_mine(cmd, mine)
  cmd <- add_user(cmd, user)
  cmd <- add_page(cmd, page)
  cmd <- add_max_size(cmd, max_size)
  cmd <- add_min_size(cmd, min_size)
  return(kaggle_build_script(cmd))
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
  cmd <- paste("datasets files", dataset, "--csv")
  return(kaggle_build_script(cmd))
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
#' \dontrun{
#' kaggle_datasets_download("zillow/zecon")
#' kaggle_datasets_download("zillow/zecon", file_name = "State_time_series.csv")
#' }
#'
#'
#' @export
kaggle_datasets_download <- function(dataset, file_name = NULL, path = NULL, unzip = FALSE, force = FALSE, quiet = FALSE) {
  cmd <- paste("datasets download", dataset)
  cmd <- add_file_name(cmd, file_name)
  cmd <- add_path(cmd, path)
  cmd <- add_unzip(cmd, unzip)
  cmd <- add_force(cmd, force)
  cmd <- add_quiet(cmd, quiet)
  return(kaggle_build_script(cmd))
}


#' Initialize Metadata file for Dataset Creation
#'
#' @param folder Folder for upload, containing data files and a special dataset-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata).
#'
#'
#' @examples
#' \dontrun{
#' kaggle_datasets_init(folder = "./path/to/dataset")
#' }
#'
#'
#' @export
kaggle_datasets_init <- function(folder) {
  cmd <- paste("datasets init",
               "--path", folder)
}


#' Create a new dataset
#'
#'
#' @param folder Folder for upload, containing data files and a special dataset-metadata.json file (https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata).
#' @param public Create publicly (default is private)
#' @param keep_tabular Do not convert tabular files to CSV (default is to convert)
#' @param quiet Suppress printing information about the upload/download progress
#' @param dir_mode What to do with directories (default is "skip"): "skip" - ignore; "zip" - compressed upload; "tar" - uncompressed upload
#'
#'
#' @examples
#' \dontrun{
#' kaggle_datasets_create(folder = "./path/to/dataset")
#' }
#'
#'
#' @export
kaggle_datasets_create <- function(folder, dir_mode = c("skip", "zip", "tar"), public = FALSE, keep_tabular = FALSE, quiet = FALSE) {
  cmd <- paste("datasets create",
               "--path", folder,
               "--dir-mode", match.arg(dir_mode))
  cmd <- add_public(cmd, public)
  cmd <- add_keep_tabular(cmd, keep_tabular)
  cmd <- add_quiet(cmd, quiet)
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
#' \dontrun{
#' kaggle_datasets_version(folder = "./path/to/dataset", version_notes = "Updated data")
#' }
#'
#'
#' @export
kaggle_datasets_version <- function(folder, version_notes, dir_mode = c("skip", "zip", "tar"), keep_tabular = FALSE,  delete_old_versions = FALSE, quiet = FALSE) {
  cmd <- paste("datasets version",
               "--path", folder,
               "--message", version_notes,
               "--dir-mode", match.arg(dir_mode))
  cmd <- add_keep_tabular(cmd, keep_tabular)
  cmd <- add_delete_old_versions(cmd, delete_old_versions)
  cmd <- add_quiet(cmd, quiet)
  return(kaggle_build_script(cmd))
}


#' Download Metadata for an Existing Dataset
#'
#' @param dataset Dataset URL suffix in format <owner>/<dataset-name> (use `kaggle_datasets_list()`to show options)
#' @param path Location to download dataset metadata to. Defaults to current working directory
#' @param update A flag to indicate whether the dataset metadata should be updated.
#'
#' @examples
#' \dontrun{
#' kaggle_datasets_metadata(dataset = "zillow/zecon", path = "./path/to/download")
#' }
#'
#'
#' @export
kaggle_datasets_metadata <- function(dataset, path = NULL, update = FALSE) {
  cmd <- paste("datasets metadata", dataset)
  cmd <- add_path(cmd, path)
  cmd <- add_update(cmd, update)
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
  cmd <- paste("datasets status", dataset)
  return(kaggle_build_script(cmd))
}
