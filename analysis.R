library(tidyverse)
library(ipumsr)
library(spatstat)

zillow_raw <- read_csv("data/County_zori_uc_sfrcondomfr_sm_month.csv")

zillow_processed <- zillow_raw %>%
  # Move rent data into long format
  pivot_longer(
    cols = -(1:9), 
    names_to = "date",
    values_to = "rent"
  ) %>%
  # Keep only the year from the date
  separate(date, c("YEAR"), sep = "-") %>%
  # Merge state and county FIP codes
  mutate(CODE = paste0(StateCodeFIPS, MunicipalCodeFIPS)) %>%
  # Group by year and county
  group_by(YEAR, CODE) %>%
  # Summarize the mean rent for each year and county
  summarise(MEAN_ZORI = mean(rent, na.rm = TRUE),
            COUNTY_NAME = first(RegionName),
            STATE_NAME = first(StateName)) %>%
  # Filter out any rows with missing rent data
  filter(!is.na(MEAN_ZORI)) %>%
  # Reorder state and county names to the start
  relocate(STATE_NAME, COUNTY_NAME)

codebook <- read_ipums_ddi("data/usa_00024.xml")
ipums_raw <- read_ipums_micro(codebook)

ipums_processed <- ipums_raw %>%
  # Remove the 5 year sample and any records without
  # county information
  filter(SAMPLE != 202203, COUNTYFIP != 0, RENT > 100) %>%
  # Format FIP codes for merging
  mutate(STATEFIP = str_pad(STATEFIP, 2, pad = "0"),
         COUNTYFIP = str_pad(COUNTYFIP, 3, pad = "0")) %>%
  # Merge state and county FIP codes
  mutate(CODE = paste0(STATEFIP, COUNTYFIP)) %>%
  # Group by year and county
  group_by(YEAR, CODE) %>%
  # Summarize the weighted median for each year and county
  summarise(MEDIAN_ACS_RENT = weighted.median(RENT, HHWT))
  
merged_data <- merge(
  zillow_processed,
  ipums_processed,
  by = c("YEAR", "CODE")
)

write_csv(merged_data, "data/merged_rent_data.csv")
