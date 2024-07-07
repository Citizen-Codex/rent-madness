library(tidyverse)
library(ipumsr)
library(spatstat)

zillow_raw_county <- read_csv("data/County_zori_uc_sfrcondomfr_sm_month.csv")

zillow_processed_county <- zillow_raw_county %>%
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
  summarise(
    MEAN_ZORI = mean(rent, na.rm = TRUE),
    COUNTY_NAME = first(RegionName),
    STATE_NAME = first(StateName)
  ) %>%
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
  mutate(
    STATEFIP = str_pad(STATEFIP, 2, pad = "0"),
    COUNTYFIP = str_pad(COUNTYFIP, 3, pad = "0")
  ) %>%
  # Merge state and county FIP codes
  mutate(CODE = paste0(STATEFIP, COUNTYFIP)) %>%
  # Group by year and county
  group_by(YEAR, CODE) %>%
  # Summarize the weighted median for each year and county
  summarise(MEDIAN_ACS_RENT = weighted.median(RENT, HHWT))

merged_data_county <- merge(
  zillow_processed_county,
  ipums_processed,
  by = c("YEAR", "CODE")
)

write_csv(merged_data_county, "data/merged_rent_data_county.csv")


zillow_raw_zip <- read_csv("data/Zip_zori_uc_sfrcondomfr_sm_month.csv")

zillow_processed_zip <- zillow_raw_zip %>%
  # Move rent data into long format
  pivot_longer(
    cols = -(1:9),
    names_to = "date",
    values_to = "rent"
  ) %>%
  # Keep only the year from the date
  separate(date, c("YEAR"), sep = "-") %>%
  # Filter years to match the date range of the IPUMS data
  filter(YEAR <= 2022 & YEAR >= 2018) %>%
  # Group by zip code
  group_by(RegionName) %>%
  # Summarize the mean rent for each year and county
  summarise(
    MEAN_ZORI = mean(rent, na.rm = TRUE),
    COUNTY_NAME = first(CountyName),
    STATE_NAME = first(StateName)
  ) %>%
  # Filter out any rows with missing rent data
  filter(!is.na(MEAN_ZORI)) %>%
  # Reorder state and county names to the start
  relocate(STATE_NAME, COUNTY_NAME) %>%
  rename(ZIP = RegionName)

census_raw_zip <- read_csv("data/ACS_zip_contract_rent.csv", skip = 1)

census_processed_zip <- census_raw_zip %>%
  select(
    ZIP = `Geographic Area Name`,
    MEDIAN_ACS_RENT = `Estimate!!Median contract rent`
  ) %>%
  mutate(
    MEDIAN_ACS_RENT = case_when(
      MEDIAN_ACS_RENT == "3,500+" ~ 3500,
      MEDIAN_ACS_RENT == "-" ~ NA,
      .default = as.numeric(MEDIAN_ACS_RENT)
    )
  ) %>%
  filter(!is.na(MEDIAN_ACS_RENT)) %>%
  rowwise() %>%
  mutate(ZIP = str_split(ZIP, " ")[[1]][2])

merged_data_zip <- merge(
  zillow_processed_zip,
  census_processed_zip,
  by = "ZIP"
)

write_csv(merged_data_zip, "data/merged_rent_data_zip.csv")
