
#package to load sas files
install.packages('haven')

library(haven)

dataFile = '/mnt/workspace/GWTG/COVID19/data/covid19_cvd_final_aug20.sas7bdat'
formatsFile = '/mnt/workspace/GWTG/COVID19/data/R_Python_windows_formats.sas7bcat'

df <- read_sas(dataFile, formatsFile)

head(df, n = 10) #set n = 10, to show 10 rows

colnames(df[, 423:429]) #display last 6 column names

str(df[,c(1:3, 6:8, 10)]) #show structure of columns 1-3, 6-8, and 10

attributes(df$METHDIAG) #display attributes of variable "METHDIAG"

table(df$METHDIAG, useNA = "ifany")

#create table
var_table <- table(df$METHDIAG, useNA = "ifany") #useNA shows missing values if present
names(var_table) <- c("RT-PCR Test", "Clinical Diagnosis using Hospital Specific Criteria", "IgM antibody test", "Missing") #change rownames -1 means RT-PCR Test, 2 means Clinical Diagnosis using Hospital Specific Criteria, 3 means IgM antibody test
var_table

summary(df$AGEi)

summary(as.factor(df$METHDIAG))
