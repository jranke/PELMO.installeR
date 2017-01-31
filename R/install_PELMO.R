#' Download FOCUS PELMO from the official site and unzip into the package installation directory
#'
#' @importFrom clipr write_clip
#' @param version The FOCUS PELMO version to install
#' @param local_zip Do not download, but use the local zip archive specified here
#' @export
install_PELMO <- function(version = "5.5.3", local_zip = NULL) {
  pkg_dir <- system.file(package = "PELMO.installeR")
  setup_dir <- file.path(pkg_dir, paste0("PELMO_", gsub("\\.", "", version), "_setup"))
  if (!dir.exists(setup_dir)) dir.create(setup_dir)

  if (is.null(local_zip)) {
    PELMO_file <- paste0("FOCUS_PELMO_", gsub("\\.", "_", version), ".zip")
    PELMO_url <- paste0("http://esdac.jrc.ec.europa.eu/public_path/projects_data/focus/gw/software/",
                        PELMO_file)
    PELMO_zip <- tempfile(fileext=".zip")
    download.file(PELMO_url, PELMO_zip)
  } else {
    if (file.exists(local_zip)) {
      PELMO_zip <- local_zip
    } else {
      stop(local_zip, " does not exist")
    }
  }

  unzip(PELMO_zip, exdir = setup_dir, junkpaths = TRUE)
  oldwd <- setwd(setup_dir)
  message("The FOCUS PELMO installer will now start.")
  message("Please select the following directory in the installation process:")
  PELMO_dest_dir <- paste0("Z:", gsub("/", "\\\\", pkg_dir),
                           "\\FOCUSPELMO.", gsub("\\.", "", version))
  message(PELMO_dest_dir)
  message("This is now being pasted to the system clipboard")
  write_clip(PELMO_dest_dir)
  system("wine setup.exe")
  setwd(oldwd)
}
