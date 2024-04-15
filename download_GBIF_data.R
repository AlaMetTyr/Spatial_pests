##GBIF user set up
install.packages("usethis")
usethis::edit_r_environ()

## Load Rpackages
library(rgbif)


name_backbone("Arthropoda")

## Download data from gbif for managed and introdcued establishments in NZ
occ_download(
  pred("hasGeospatialIssue", FALSE),
  pred("hasCoordinate", TRUE),
  pred("occurrenceStatus","PRESENT"), 
 # pred("establishmentMeans","INTRODUCED"),
  pred_not(pred_in("basisOfRecord",c("FOSSIL_SPECIMEN","LIVING_SPECIMEN"))),
  pred("taxonKey", 54),
 pred("country", "NZ"),
  format = "SIMPLE_CSV"
)

##############################################################################
########## download from species list for final spatial data list ############
##############################################################################
library(dplyr)
library(readr)  
library(rgbif) 

long_checklist <- read_excel("fullspecieslevel_keys.xlsx")

# match the names 
gbif_taxon_keys <- data.frame(gbif_taxon_keys = long_checklist$taxonKey) %>% 
  pull(gbif_taxon_keys,gbif_taxon_keys) 

# !!very important here to use pred_in!!
occ_download(
  pred_in("taxonKey", gbif_taxon_keys),
  pred("country","NZ"),
  pred("hasGeospatialIssue", FALSE),
  pred("hasCoordinate", TRUE),
  pred("occurrenceStatus","PRESENT"), 
  pred_not(pred_in("basisOfRecord",c("FOSSIL_SPECIMEN","LIVING_SPECIMEN"))),
  format = "SIMPLE_CSV"
)

