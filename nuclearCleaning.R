# Load libraries
library(dplyr)
library(stringr)
library(countrycode)

# Read csv into dataframe
df = read.csv("/Users/SG/Documents/Programming/nuclearProjects/nuclearData.csv")

# remove unwanted columns
dfReactor <- df[, -c(2, 3, 5, 7, 9, 11, 12)]

# remove unwanted rows
dfReactor <- dfReactor[-c(1, 45, 46),]

# rename columns
dfReactor = rename(dfReactor, "Country" = 1,
                              "Operable Reactors" = 2,
                              "Under Construction Reactors" = 3,
                              "Planned Reactors" = 4,
                              "Proposed Reactors" = 5)

# extract strings from country column to remove symbols
dfReactor <- dfReactor %>% mutate(Country = str_extract(Country, "[A-Za-z ]+"))

# use countrycodde package to add regions
region <- countrycode(dfReactor$Country, origin = 'country.name', destination = 'region')
dfReactor$Region <- region
dfReactor <- dfReactor %>% relocate(Region, .after = Country)
