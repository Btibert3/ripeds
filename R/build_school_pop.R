#' Helper function to identify core school population
#' 
#' A function to filter down school data to generate a school population for further analyses.
#' 
#' @param year character. The survey year of interest.  Default is 2014
#' 
#' @return a dataframe of basic school information, which is a subset of all schools in the IPEDS universe
#' 
#' @examples 
#' \dontrun{
#' school_pop  <- build_school_pop()
#' }
#' @export
#' build_school_pop
build_school_pop <- function(year = '2014') {
  ## get the data
  data(hd)
  hd <- dplyr::filter(hd, survey_year == year & 
                        sector %in% 1:2 & 
                        pset4flg == 1 & 
                        deggrant == 1)
  hd <- dplyr::select(hd, unitid, instnm, stabbr, obereg, sector, hdegofr1, hbcu, 
                      locale, ccbasic:ccsizset, longitud, latitude)
                    
  ## filter further and data quality
  hd = dplyr::filter(hd, obereg %in% 1:8)
  hd = dplyr::filter(hd, hdegofr1 %in% 11:40)
  hd = dplyr::filter(hd, !is.na(longitud) & !is.na(latitude))
  hd = hd[complete.cases(hd), ]
  
  ## return
  return(hd)
  
}









