
LIBNAME GWTG "/mnt/workspace/GWTG/COVID19/data";
LIBNAME LIBRARY "/mnt/workspace/GWTG/COVID19/data";


DATA COVID_data;
    SET GWTG.covid19_cvd_final_aug20;
RUN;

PROC CONTENTS DATA=COVID_data DIRECTORY DETAILS;
RUN;

PROC FREQ DATA= COVID_data; 
    TABLES METHDIAG/MISSING; /*This can be used with
                                any categorical variables in the dataset*/    
RUN;


PROC MEANS DATA=COVID_data MEAN MEDIAN STD MIN MAX Q1 Q3 NMISS MAXDEC=2 ; 
    VAR AGEI; /*This can be used for any continuous variable from the dataset. */
RUN;

