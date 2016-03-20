options(stringsAsFactors = F)

## set some of the parameters
YEARS = 2002:2014
SUFFIX = "IC"
BASE_URL = "http://nces.ed.gov/ipeds/datacenter/data/%s%s.zip"

## loop and get the raw datasets
for (YEAR in YEARS) {
  ## build the URL
  URL = sprintf(BASE_URL, SUFFIX, YEAR)
  ## download the zip file
  download.file(URL, paste0(SUFFIX, YEAR, ".zip"))
}

## in 2014, NCES decided to break things out, awesome
ADM_YEARS = as.character(c(2014))
SUFFIX = "ADM"
for (YEAR in ADM_YEARS) {
  ## build the URL
  URL = sprintf(BASE_URL, SUFFIX, YEAR)
  ## download the zip file
  download.file(URL, paste0(SUFFIX, YEAR, ".zip"))
}


## unzip the data
FILES = list.files(pattern = ".zip")
for (FILE in FILES) {
  unzip(FILE)
}

## IC has a number of revised datasets, reset YEAR vector
YEARS = as.character(2002:2013)

## loop and build the datasets
ic = data.frame()

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
  ic = dplyr::bind_rows(ic, survey)
  ## cleanup
  rm(x, survey)
}


## starting in 2014, join IC and ADM before adding to the core datasets
for (YEAR in ADM_YEARS) {
  ## get the files
  x = FILES[stringr::str_detect(FILES, YEAR)]
  ## get the IC files
  x_ic = x[stringr::str_detect(x, "ic")]
  x_adm = x[stringr::str_detect(x, "adm")]
  ## test to see if _rv in the file name
  if (length(x_ic) > 1) {
    x_ic = x_ic[stringr::str_detect(x_ic, "_rv")]
    cat("using revised file\n")
  }
  if (length(x_adm) > 1) {
    x_adm = x_adm[stringr::str_detect(x_adm, "_rv")]
    cat("using revised file\n")
  }
  ## load in the IC and ADM file
  survey_ic = readr::read_csv(x_ic)
  colnames(survey_ic) = tolower(colnames(survey_ic))
  survey_adm = readr::read_csv(x_adm)
  colnames(survey_adm) = tolower(colnames(survey_adm))
  ## join the datasets
  survey = dplyr::left_join(survey_ic, survey_adm)
  ## add the year
  survey$survey_year = YEAR
  ## append to the data
  ic = dplyr::bind_rows(ic, survey)
}




## cleanup the directory
FILES_CSV = list.files(pattern = ".csv")
FILES_ZIP = list.files(pattern = ".zip")
file.remove(c(FILES_CSV, FILES_ZIP))

## save the data
save(ic, file="../data/ic.rda")

## cleanup
rm(list=ls())
