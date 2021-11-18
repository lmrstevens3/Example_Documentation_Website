
#package to load sas files
install.packages('haven')

library(haven)

registry = "Resuscitation/"
version_release_date = "v3_2021-06/"
#The paste command below is merging all the variables to make a single file path.
data_directory =  paste0("/mnt/workspace/GWTG/", registry, version_release_date,  "data/")
dataset_folder="CPA Adult/"
data_file = paste0(data_directory, dataset_folder,'v3_2021_06_gwtg_resus_cpa_adult.sas7bdat')
formats_file = paste0(data_directory, dataset_folder, 'formats/v3_2021_06_gwtg_resus_formats.sas7bdat')

data_file
formats_file

df <- read_sas(data_file)
formats <- read_sas(formats_file)

head(df, n = 10) #set n = 10, to show 10 rows

head(formats, n = 10) #set n = 10, to show 10 rows

str(df[,c(1:3, 6:8, 10)]) #show structure of columns 1-3, 6-8, and 10

colnames(df[, 100:105]) #display columns 100-105

attributes(df$RACE) #display attributes of variable "RACE"

table(df$RACE, useNA = "ifany")

#get coding for df variable METHDIAG
coding <- formats$LABEL[formats$FMTNAME == attributes(df$RACE)$format][c(0:7)]
#set variable typeas factor with coding labels
df$RACE <- factor(df$RACE, labels = coding)
#create a table with labels
table(df$RACE, useNA = "ifany") #useNA shows missing values if present

summary(df$AGE_CPAY_NEW)

summary(as.factor(df$RACE))
