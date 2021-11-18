
%let root= /mnt/workspace/GWTG/; /*This location won't change unless you are using a folder other than the GWTG*/

%let registry = Resuscitation/; /*change the name of the registry to the specific one present in the GWTG folder*/
%let version_release_date = v3_2021-06/;/*Use the release of the data needed for analysis(eg:V2-2020_10 for October release)*/
%let data_folder = data/; /*Data folder is in every version release and shouldn't change*/
%let dataset_folder= CPA Adult/; /*This is specific to the type of dataset in the resuscitation folder*/
%let formats_folder = formats/; /*This is the location of the formats folder*/
%let data_directory = &root.&registry.&version_release_date.&data_folder.&dataset_folder;
%let formats_directory = &root.&registry.&version_release_date.&data_folder.&dataset_folder.&formats_folder;

%let data_file_name=v3_2021_06_gwtg_resus_cpa_adult; /*This is the name of the data file that you would use for the analysis*/


%put data_directory = &root.&registry.&version_release_date.&data_folder.&dataset_folder;
%put formats_directory = &root.&registry.&version_release_date.&data_folder.&dataset_folder.&formats_folder;

%put data_file_name=v3_2021_06_gwtg_resus_cpa_adult; /*This is the name of the data file that you would use for the analysis*/

LIBNAME GWTG "&data_directory.";/*In the code above you can see that the data directory is the combination of the 
                                root location, registry name, and release date. 
                                See the notes in the output below for the files paths*/
LIBNAME LIBRARY "&formats_directory.";


%let dataset=GWTG.&data_file_name; /*This code combines the library name and the dataFile name for
                                    the data that you would use and which is stored in the variable named dataFileName */
                                   
DATA gwtg_resus;
    SET &dataset.; /*variable merge is the combination of the library name and the dataFileName*/
RUN;

PROC CONTENTS DATA=gwtg_resus DIRECTORY DETAILS;
RUN;

PROC FREQ DATA=gwtg_resus;
TABLES RACE;
RUN;

PROC MEANS DATA=gwtg_resus MEAN MEDIAN STD MIN MAX Q1 Q3 NMISS MAXDEC=2 ; 
    VAR WT_KG; /*This can be used for any continuous variable from the dataset. */
RUN;

