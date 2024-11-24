library(tidyverse)
library(ipumsr)
library(spatstat)
library(sf)

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

census_raw_zip_rent <- read_csv("data/ACS_zip_contract_rent.csv", skip = 1)
census_raw_zip_population <- read_csv("data/ACS_zip_populations.csv", skip = 1)
census_raw_zip_housing <- read_csv("data/ACS_zip_housing_characteristics.csv", skip = 1)
census_raw_zip_income <- read_csv("data/ACS_zip_income.csv", skip = 1)
census_raw_zip_housing_age <- read_csv("data/ACS_zip_housing_age.csv", skip = 1)

census_processed_zip_rent <- census_raw_zip_rent %>%
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
  )

census_processed_zip_population <- census_raw_zip_population %>%
  select(
    ZIP = `Geographic Area Name`,
    TOTAL_POPULATION = `Estimate!!SEX AND AGE!!Total population`,
    WHITE_POPULATION = `Estimate!!RACE!!Total population!!One race!!White`,
    HISPANIC_PERCENT = `Percent!!HISPANIC OR LATINO AND RACE!!Total population!!Hispanic or Latino (of any race)`,
    ASIAN_PERCENT = `Percent!!RACE!!Total population!!One race!!Asian`,
    BLACK_PERCENT = `Percent!!RACE!!Total population!!One race!!Black or African American`,
    WHITE_PERCENT = `Percent!!RACE!!Total population!!One race!!White`,
    OTHER_PERCENT = `Percent!!RACE!!Total population!!One race!!Some Other Race`
  ) %>%
  mutate(NON_WHITE_PERCENT = ifelse(TOTAL_POPULATION != 0, 100 * (TOTAL_POPULATION - WHITE_POPULATION) / TOTAL_POPULATION, 0)) %>%
  mutate(across(2:9, ~ case_when(
    . == "-" ~ NA,
    .default = as.numeric(.)
  )))

census_processed_zip_housing <- census_raw_zip_housing %>%
  select(
    ZIP = `Geographic Area Name`,
    SINGLE_FAMILY_PERCENT = `Estimate!!Total!!Total households!!UNITS IN STRUCTURE!!1-unit structures`,
    RENT_PERCENT = `Estimate!!Total!!Total households!!HOUSING TENURE!!Renter-occupied housing units`
  ) %>%
  mutate(across(2:3, ~ case_when(
    . == "-" ~ NA,
    .default = as.numeric(.)
  )))

current_year <- 2022

census_processed_zip_housing_age <- census_raw_zip_housing_age %>%
  select(
    ZIP = `Geographic Area Name`,
    Y_PRE_1939 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!1939 or earlier`,
    Y_1940_1959 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!1940 to 1959`,
    Y_1960_1979 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!1960 to 1979`,
    Y_1980_1999 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!1980 to 1999`,
    Y_2000_2009 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!2000 to 2009`,
    Y_2010_2019 = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!2010 to 2019`,
    Y_2020_PLUS = `Estimate!!Percent renter-occupied housing units!!Occupied housing units!!YEAR STRUCTURE BUILT!!2020 or later`
  ) %>%
  mutate(
    MEAN_AGE = (as.numeric(Y_PRE_1939) * (current_year - 1939) + as.numeric(Y_1940_1959) * (current_year - 1950) + as.numeric(Y_1960_1979) * (current_year - 1970) + as.numeric(Y_1980_1999) * (current_year - 1990) + as.numeric(Y_2000_2009) * (current_year - 2005) + as.numeric(Y_2010_2019) * (current_year - 2015) + as.numeric(Y_2020_PLUS) * (current_year - 2020)) / 100,
    .keep = "unused"
  )

census_processed_zip_income <- census_raw_zip_income %>%
  select(
    ZIP = `Geographic Area Name`,
    MEDIAN_INCOME = `Estimate!!Households!!Median income (dollars)`
  ) %>%
  mutate(
    MEDIAN_INCOME = case_when(
      MEDIAN_INCOME == "-" ~ NA,
      .default = as.numeric(MEDIAN_INCOME)
    )
  )

census_processed_zip <-
  merge(
    census_processed_zip_rent,
    census_processed_zip_population,
    by = "ZIP"
  ) %>%
  merge(
    census_processed_zip_housing,
    by = "ZIP"
  ) %>%
  merge(
    census_processed_zip_income,
    by = "ZIP"
  ) %>%
  merge(
    census_processed_zip_housing_age,
    by = "ZIP"
  ) %>%
  rowwise() %>%
  mutate(ZIP = str_split(ZIP, " ")[[1]][2])

merged_data_zip <- merge(
  zillow_processed_zip,
  census_processed_zip,
  by = "ZIP",
  all = TRUE
) %>%
  mutate(GAP = (MEAN_ZORI - MEDIAN_ACS_RENT) / MEDIAN_ACS_RENT)

write_csv(merged_data_zip, "data/merged_rent_data_zip.csv")

sf_use_s2(FALSE)

zip_shapes <- st_read("data/USA_ZIP_Code_Boundaries.json") %>%
  st_make_valid() %>%
  mutate(AREA = st_area(geometry))

merged_data_zip_sf <- merged_data_zip %>%
  merge(zip_shapes, by.x = "ZIP", by.y = "ZIP_CODE", all = TRUE) %>%
  mutate(POPULATION_DENSITY = as.numeric(TOTAL_POPULATION / AREA)) %>%
  filter(AREA > 0)

st_write(merged_data_zip_sf, "data/merged_rent_data_zip_sf.geojson")

model <- lm(
  data = merged_data_zip_sf %>% filter(GAP < 2),
  GAP ~ SINGLE_FAMILY_PERCENT + RENT_PERCENT + log(MEDIAN_INCOME) + POPULATION_DENSITY + OTHER_PERCENT + log(MEDIAN_INCOME) * RENT_PERCENT + MEAN_AGE
)
summary(model)

# Check the amount of population covered by the zillow data
merged_data_zip %>%
  group_by(is.na(GAP)) %>%
  summarise(population = sum(TOTAL_POPULATION)) %>%
  mutate(percent = population / sum(population))
