## Load Rpackages
library(dplyr)
library(readxl)
library(plyr)
library(tidyverse)

##Read excel files into R
GBIF_species <- read_excel("full_GBIF.xlsx")
Pest_list <- read_excel("pest_list_emma.xlsx")
NZOR_list <- read_excel("NZOR.xlsx")

##Subset emmas list to genus level and save as dataframe
names_df_emma <- data.frame(Genus = Pest_list$Genus, Species = Pest_list$Species)

##Subset NZOR list to genus level and save as dataframe
names_NZOR <- data.frame(Genus = NZOR_list$Genus, Species = NZOR_list$Species)

############################ subsetting the gbif dat based on the pest list and NZOR exotics###################################
# Get unique combinations of genus and species from names_df_emma
unique_combinations <- unique(names_df_emma[, c("Genus", "Species")])

# Create an empty list to store subsets
subset_list_pest <- list()

# Loop through each unique combination
for (i in 1:nrow(unique_combinations)) {
  # Subset GBIF_species based on current combination
  subset_list_pest[[i]] <- GBIF_species[GBIF_species$Genus == unique_combinations[i, "Genus"] & 
                                     GBIF_species$Species == unique_combinations[i, "Species"], ]
}

# Combine all subsets into a single data frame
final_subset_pest <- do.call(rbind, subset_list_pest) ######### 583 out of 1483 = 39% of pest list is in gbif data

#####################################now repeat this for the NZOR df

# Get unique combinations of genus and species from names_df_emma
unique_combinations <- unique(names_NZOR[, c("Genus", "Species")])

# Create an empty list to store subsets
subset_list_names_NZOR <- list()

# Loop through each unique combination
for (i in 1:nrow(unique_combinations)) {
  # Subset GBIF_species based on current combination
  subset_list_names_NZOR[[i]] <- GBIF_species[GBIF_species$Genus == unique_combinations[i, "Genus"] & 
                                     GBIF_species$Species == unique_combinations[i, "Species"], ]
}

# Combine all subsets into a single data frame
final_subset_NZOR <- do.call(rbind, subset_list_names_NZOR) ########## 34% of NZOR is in gbif data

#################### now we need to merge and remove the duplicate rows

##merge the two outputs into one file with unique rows
merged_df <- rbind(final_subset_NZOR,final_subset_pest)


##Get all unique rows by removing duplicates
unique_data <- unique(merged_df)
num_duplicates <- sum(duplicated(unique_data))
print(num_duplicates) ##### there should be no duplicates here

write.csv(unique_data, "fullspecieslevel_keys.csv", row.names=FALSE)


#####################################################
spatial <- read_excel("spatialjoin_occurance_forest.xlsx")

##Get all unique rows by removing duplicates
unique_species <- spatial %>%
  group_by(species) %>%
  filter(n() == 1)

write.csv(unique_species, "unique_species_forest.csv", row.names=FALSE)


merged_df_total <- rbind(names_df_emma, names_NZOR)
num_duplicates <- sum(duplicated(merged_df_total))
print(num_duplicates)
