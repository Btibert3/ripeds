options(stringsAsFactors = F)

## set some of the parameters
YEARS = as.character(seq(2002, 2014, by=2))
PREFIX = "EF"
BASE_URL = "http://nces.ed.gov/ipeds/datacenter/data/%s%sCP.zip"

## loop and get the raw datasets
for (YEAR in YEARS) {
  ## build the URL
  URL = sprintf(BASE_URL, PREFIX, YEAR)
  ## download the zip file
  download.file(URL, paste0(PREFIX, YEAR, ".zip"))
}


## unzip the data
FILES = list.files(pattern = ".zip")
for (FILE in FILES) {
  unzip(FILE)
}


## loop and build the datasets
efc = data.frame()

## flag the files
FILES = list.files(pattern = ".csv")

## loop and build
for (YEAR in YEARS) {
  ## get the files
  x = FILES[stringr::str_detect(FILES, YEAR)]
  ## test to see if _rv in the file name
  if (length(x) > 1) {
    x = x[stringr::str_detect(x, "_rv")]
    cat("using revised file\n")
  }
  ## read in the file
  survey = readr::read_csv(x)
  ## colnames to lower
  colnames(survey) = tolower(colnames(survey))
  year = stringr::str_extract(x, "[0-9]{4}")
  ## cleanup so can bind against previous years
  survey$survey_year = year
  ## bind
  efc = dplyr::bind_rows(efc, survey)
  ## cleanup
  rm(x, survey)
}


## cleanup the directory
FILES_CSV = list.files(pattern = ".csv")
FILES_ZIP = list.files(pattern = ".zip")
file.remove(c(FILES_CSV, FILES_ZIP))

## save the data
efcp = efc
save(efcp, file="../data/efcp.rda")

## cleanup
rm(list=ls())
