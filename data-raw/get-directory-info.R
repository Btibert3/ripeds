options(stringsAsFactors = F)

## set some of the parameters
YEARS = 2002:2014
SUFFIX = "HD"
BASE_URL = "http://nces.ed.gov/ipeds/datacenter/data/%s%s.zip"

## loop and get the raw datasets
for (YEAR in YEARS) {
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


## loop and build the datasets
hd = data.frame()
FILES = list.files(pattern = ".csv")
for (FILE in FILES) {
  ## read in
  tmp = readr::read_csv(FILE)
  ## because consistency is not the NCES's concern
  colnames(tmp) = tolower(colnames(tmp))
  ## parse out the year
  year = stringr::str_extract(FILE, "[0-9]{4}")
  ## cleanup so can bind against previous years
  tmp$survey_year = year
  if ("gentele" %in% colnames(tmp)) tmp$gentele = as.character(tmp$gentele)
  if ("fintele" %in% colnames(tmp)) tmp$fintele = as.character(tmp$fintele)
  if ("admtele" %in% colnames(tmp)) tmp$admtele = as.character(tmp$admtele)
  if ("closedat" %in% colnames(tmp)) tmp$closedat = as.character(tmp$closedat)
  ## bind rows
  hd = dplyr::bind_rows(hd, tmp)
  ## cleanup
  rm(tmp)
}


## cleanup the directory
FILES_CSV = list.files(pattern = ".csv")
FILES_ZIP = list.files(pattern = ".zip")
file.remove(c(FILES_CSV, FILES_ZIP))

## save the data
save(hd, file="../data/hd.rda")

## cleanup
rm(list=ls())
