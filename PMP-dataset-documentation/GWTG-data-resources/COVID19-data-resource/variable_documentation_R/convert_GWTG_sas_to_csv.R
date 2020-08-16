library(haven)
library(data.table)

###GWTG data conversion
##June 2, 2020
working_directory = "/Users/laurastevens/Dropbox/AHA/Research and Pilot Projects/GWTG/"
setwd(working_directory)
#read and convert sas files to csv
convert_sas_csv_function <- function(sasfile) {
    timestamp()
    print("reading sas file")
    sasData <- read_sas(sasfile)
    print("writing csv")
    fwrite(strokeData, gsub(".sas*$", ".csv", sasfile))
    timestamp()
}
strokeData <- convert_sas_csv_function("GWTG Data/stroct19.sas7bdat")
rm(strokeData)
strokeData <- convert_sas_csv_function("GWTG Data/hfoct19.sas7bdat")
rm(hfData)
