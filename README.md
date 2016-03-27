# ripeds

An R data-package for NCES IPEDS data. Instead of crawling the data manually or using the IPEDS package, this package simply keeps stores the data in R data frames for easy access.  All you need to do is load the survey data of choice into your environment, and you are off and running.  In addition, there will be some helper functions to calculate common KPIs, like admit rate, freshmen discount rate, etc.

## Quick Start

To install the package, simply use devtools.  This will take a second because there are a lot of data to grab.

```
devtools::install_github("btibert3/ripeds")
```

### A Sample Session

Load the packages

```
library(ripeds)
library(dplyr)
```

Load the institutional characterstics dataset

```
data(ic)
```

What do we have?

```
dim(ic)
```

Keep records where the # of applicants isn't missing

```
ic = filter(ic, applcn > 0 & app_year >= 2002)
```

Plot the data by the app year, which is not always in the survey year.  

```
tbl_df(ic) %>% group_by(app_year) %>% summarise(apps = sum(applcn)) %>% plot(type="l", ylim=c(0,10000000))
```

Prior to 2014, it looks like some institutions had the choice on what application year they would report.  In 2014, it apepars that the option was removed.  As a result, there is a sizable drop in app volume in 2013.


## Notes  

- I am starting with years 2002 to present.
- When the data are collected, and a revised file is included, I will always use that file, not the original data reported.


## Data Collected

- [x] HD: Directory Info
- [x] IC and ADM: Institutional Characteristics and Admissions data  
- [x] SFA: Student Financial Aid  
- [x] EF_C: Fall Enrollment - Residence and Migration
- [x] CHARGE_AY: Student Charges for Academic Programs
- [x] EF_CP: Fall Enrollment - Major, r/e, level, etc.


## To do

- [ ] Improve documentation files for the datasets and package
- [ ] Add data before 2002 
- [ ] Improve cleanup for `efcp`. Columns may have changed across years.

## Observations  

- As of 3/20/2016, the survey files in 2014 for `IC` and `ADM` were broken out.  What's more, the file `ADM.csv` only includes 2236 schools but `IC2014.csv` includes 7531 schools.  Finally, the variable `appdate` which flags the fall reporting year appears to be missing in 2014, so I am assuming that the survey year is based on the Fall reporting year.  





## Issues/Questions/Feature Requests

For data issues, or feature requests, feel free to submit an Issue to this repo.  I will do my best to monitor and stay on top of issues.



## Last Update

March 2016