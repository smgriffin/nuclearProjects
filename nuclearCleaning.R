# Load libraries
library(dplyr)
library(stringr)
library(countrycode)
library(ggplot2)

# Read csv into dataframe
df = read.csv("")

# remove unwanted columns
dfReactor <- df[, -c(2, 3, 5, 7, 9, 11, 12)]

# remove unwanted rows
dfReactor <- dfReactor[-c(1, 44, 45, 46),]

# rename columns
dfReactor = rename(dfReactor, "Country" = 1,
                              "Operable" = 2,
                              "UnderConstruction" = 3,
                              "Planned" = 4,
                              "Proposed" = 5)

# extract strings from country column to remove symbols
dfReactor <- dfReactor %>% mutate(Country = str_extract(Country, "[A-Za-z ]+"))

# use countrycodde package to add regions
region <- countrycode(dfReactor$Country, origin = 'country.name', destination = 'region')
dfReactor$Region <- region
dfReactor <- dfReactor %>% relocate(Region, .after = Country)

# Write clean data to csv
colnms <- c("Operable", "UnderConstruction", "Planned", "Proposed")
dfReactor[, colnms] <- lapply(dfReactor[, colnms], as.numeric)
dfReactor$Total <- rowSums(dfReactor[, colnms])
write.csv(dfReactor, "/Users/SG/Documents/Programming/nuclearProjects/cleanReactor.csv", row.names = FALSE)

# group the data by region and summarise
byRegion <- dfReactor %>% group_by(Region)
byRegion <- byRegion %>% mutate_at(c(3:6), as.numeric)
byRegion <- byRegion %>% summarise(
    Operable = sum(Operable),
    "Under Construction" = sum(UnderConstruction),
    Planned = sum(Planned),
    Proposed = sum(Proposed)
)

# Add a total column and reorder
#byRegion$Total <- rowSums(byRegion[,c("Operable", "Under Construction", "Planned", "Proposed")])
#byRegion <- arrange(byRegion, -Total)

# lengthen data to prepare for grouped barchart
longRegion <- pivot_longer(byRegion, !Region, names_to = "Status", values_to = "Count")

# create grouped barchart
ggplot(longRegion, aes(fill = Status, y= Count, x = Region)) +
    geom_bar(position="dodge", stat="identity") +
    theme(axis.text.x=element_text(angle=45, hjust=1)) +
    scale_fill_brewer(palette = "Spectral") +
    labs(title = "Global Nuclear Projects",
         subtitle = "Plotted by Region",
         caption = "Data source: World Nuclear Association"
)
