#' Institutional Characteristics and Admissions Data from IPEDS
#'
#' For more information, download a data dictionary from the IPEDS website.
#' 
#' Survey years 2002 - 2014.
#' 
#' Note:  In 2014, the data in the IC survey files was broken out into IC and ADM.  These files are combined.
#'
#' @source http://nces.ed.gov/ipeds/datacenter/DataFiles.aspx
#' @format Data frame with columns
#' \describe{
#' \item{survey_year}{The year of the survey}
#' \item{app_year}{The survey allows schools to report different years. 
#' This column identifes the year reported for the survey; some schools report the same year twice.
#' The column that drives this is appdate.  In 2014, it appears that this was not asked, so I assume that this
#' enforces that the survey year is equal to the fall reporting period; 2014 =  Fall 2014.}
#' }
#' @examples
#'   ic
"ic"