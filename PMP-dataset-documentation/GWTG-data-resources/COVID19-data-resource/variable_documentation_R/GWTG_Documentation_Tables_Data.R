library(data.table)
library(xlsx)
library(dplyr)

###GWTG documentation Preprocessing 
##Laura Stevens June 29, 2020


working_directory = "/Users/laurastevens/Dropbox/AHA/Research and Pilot Projects/GWTG/"
setwd(working_directory)


#load documentation
load_documentation_duke <- function(file, contentSheet, formatSheet){
    content <- read.xlsx(file,  sheetName = contentSheet)
    formats <- read.xlsx(file, sheetName = formatSheet)
    return(list("data_dict" = content, "formats" = formats))
}


load_documentation_pdf <- function(file, ...){
    extract_tables(pdf_file, output = "data.frame")
}

add_coding_to_factor <- function(col_name, var_levels, data){
    factor(data[[col_name]], 
           levels = var_levels[[col_name]][which(var_levels[[col_name]] %in% unique(data[[col_name]]))],
           labels = names(var_levels[[col_name]])[which(var_levels[[col_name]] %in% unique(data[[col_name]]))])
}

#set files
#stroke_data_file <- "GWTG Data/stroct19.csv"
#hf_data_file <- "GWTG Data/hfoct19.csv"
#gwtg_doc_file <- "GWTG Documentation/AHA GWTG October 2019 Data.xlsx"
covid_data_file <- "GWTG Data/covid_initial_data_deiden_5.14.20.xlsx"
covid_doc_file <- "GWTG Documentation/COVID-19 Documentation/COVID Config File to Support Future Uploads.xls"

#Example covid data
covid_formats <- read.xlsx(covid_doc_file, sheetName = "Data Elements")
covid_data <- read.xlsx(covid_data_file, sheetIndex = 1)
continuous_vars <- colnames(covid_data)[colnames(covid_data) %in% as.character(covid_formats$Variable.Name[covid_formats$Field.Type %in% c("DECIMAL", "INTEGER")])]
covid_data <- covid_data %>% mutate_at(vars(continuous_vars), funs(as.numeric(as.character(.))))

#set factor levels, map coding values to data
covid_coding <- covid_formats %>% filter(!Field.Type %in% c("DATE", "INTEGER", "TEXT", "DECIMAL")) %>%
    select(Variable.Name, Response.Option, Response.Code) %>% na.omit()

var_levels <- covid_coding %>% group_by(Variable.Name) %>% summarise(coding = list(setNames(Response.Code, Response.Option)))
var_levels <- setNames(var_levels$coding, var_levels$Variable.Name)   
covid_data[colnames(covid_data)[colnames(covid_data) %in% names(var_levels)]] <- sapply(colnames(covid_data)[colnames(covid_data) %in% names(var_levels)], add_coding_to_factor, var_levels = var_levels, data = covid_data)

#map documentation to vars in data and add pdfs CRF forms
binary_mult_select_vars <- c('psource', 'medhisto', 'docusymp', 'antihyprtnsvtx', 'liplowthrptx', 'antiplttx', 'antihyprglymtx')
binary_mult_select_doc <- covid_formats %>% mutate_all(as.character) %>%
    filter(Variable.Name %in% binary_mult_select_vars) %>% group_by(Variable.Name) %>%
    mutate(Variable = paste0(Variable.Name, Response.Code), 
           Field.Type = unique(na.omit(Field.Type)),
           Description = paste0(unique(na.omit(Description)), ": ", Response.Option)) %>% 
    ungroup() %>% select(-Variable.Name) %>% rename("Variable.Name" = "Variable")

##path that works
#file:///Users/laurastevens/Dropbox/AHA/Research%20and%20Pilot%20Projects/GWTG/GWTG%20Data/R/www/AHA_COVID_CVD_Coding_CRF_4_28_2020.pdf
root_path <- "GWTG Data/R/www"
covid_doc <- covid_formats %>% mutate_all(as.character) %>%
    mutate(Description = replace(Description, Variable.Name %in% binary_mult_select_vars, binary_mult_select_doc$Description), 
           Field.Type = replace(Field.Type, Variable.Name %in% binary_mult_select_vars, binary_mult_select_doc$Field.Type),
           Field.Type = stringr::str_to_lower(Field.Type),
           Variable.Name = replace(Variable.Name, Variable.Name %in% binary_mult_select_vars, binary_mult_select_doc$Variable.Name)) %>% 
    mutate(path = stringr::str_replace_all(file.path("file://", working_directory, root_path, "AHA_COVID_CVD_Coding_CRF_4_28_2020.pdf"),' ', '%20'),
           path = replace(path, Repeat.Group.Name == 'seriallabs_rg', stringr::str_replace_all(paste0(root_path, "AHA_COVID-CVD_Coding CRF Serial Lab Tracker_4.28.2020.pdf"),' ', '%20')),
           path2 = stringr::str_replace_all(file.path("file://", working_directory, root_path,  "COVID19_Cardiovascular_Registry_Coding Instructions_v2_5_20_2020.pdf"),' ', '%20'),
           link = paste0('<a  target=_blank href=', path, '>Collection Report Form</a><br><a  target=_blank href=', path2, '>Registry Criteria and Definitions</a>')) %>% 
    select(Variable = Variable.Name, Description, Type = Field.Type, link) %>% na.omit()


#data for display 
#get chart data
covid_overview <- calc_data_overview_dist_childrow(covid_data)
covid_overview <- covid_doc %>% dplyr::right_join(covid_overview) 
covid_overview <- covid_overview %>% mutate(Type = stringr::str_to_lower(Type), link = gsub(".pdf", ".pdf\"", gsub("href=", "href=\"", link)))
#caption
captionText <- paste0("Data Dimensions (patients X clinical variables): ", paste0(dim(covid_data), collapse =  " X "))
caption = htmltools::tags$caption(style = 'caption-side:bottom; text-align:center; color:grey;', captionText)
#get header, rowchildren cols and make caption

covid_overview_DT <- calc_data_overview_DT(covid_overview, show_missing = T, index_childrow_cols = which(grepl("Summary|link", colnames(covid_overview))), caption = caption)
covid_overview_DT


# Example using HF Data
documentationTable <- load_documentation_duke(varsDocFile, contentSheet = "HF Content 11-2019", formatSheet = "HF Formats 11-2019")
documentationTable  <- dplyr::full_join(documentationTable$data_dict, documentationTable$formats)

#load data
#strokeData <- fread(stroke_data_file)
#hfData <- fread(hf_data_file)

#get box/bar plot information for sparklines
#hfSummaryDist <- getBarChartBoxChartData(hfData)


