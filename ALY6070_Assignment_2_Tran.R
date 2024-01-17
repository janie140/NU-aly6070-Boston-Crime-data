cat("\014")  # clears console
rm(list = ls())  # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) # clears packages
options(scipen = 100) # disables scientific notion for entire R session

library(pacman)
p_load(tidyverse, corrplot, skimr, RColorBrewer)

# load and combine data sets from 2015 to 2022
d2015 <- read.csv("2015.csv")
d2016 <- read.csv("2016.csv")
d2017 <- read.csv("2017.csv")
d2018 <- read.csv("2018.csv")
d2019 <- read.csv("2019.csv")
d2020 <- read.csv("2020.csv")
d2021 <- read.csv("2021.csv")
d2022 <- read.csv("2022.csv")
d2023 <- read.csv("2023.csv")

df <- rbind(d2015, d2016, d2017, d2018, d2019, d2020, d2021, d2022, d2023)

############################ EDA and DATA CLEANING #############################
# clean names into lowercase format
p_load(janitor)
df <- clean_names(df)

# descriptive statistics
colnames(df)
skim(df) #data types, missing values, min, max, mean, sd, hist
sapply(df, function(x) sum(is.na(x))) #Check for missing values in entire data set

# reformat values in the "shooting" column
unique(df$shooting)
df <- df |> mutate(shooting = ifelse(shooting == "", 0, shooting)) |>
  mutate(shooting = ifelse(shooting == "Y", 1, shooting))

# mutate all empty strings to NA
df <- df |> mutate_all(~ifelse(. == "", NA, .))

# remove Identifier variables & columns with > 20% missing values
df <- subset(df, select = -c(incident_number, offense_code_group,
                             ucr_part, reporting_area, occurred_on_date))

# convert variable types
df <- df |> mutate(across(c(offense_code, year, month, hour), as.factor))
df$shooting <- as.numeric(df$shooting)

# set "day_of_week" as a factor with custom levels
weekday_order <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                   "Saturday", "Sunday")
df$day_of_week <- factor(df$day_of_week, levels = weekday_order)

##### convert district codes into district names
unique(df$district)
# Mapping of district codes to full names
district_mapping <- data.frame(
  code = c('A1', 'A7', 'A15', 'B2','B3', 'C6', 'C11','D4','D14', 'E5', 'E13',
           'E18', 'External', 'NA'),
  full_name = c('Downtown', 'East Boston','Charlestown', 'Roxbury', 'Mattapan',
                'South Boston', 'Dorchester', 'South End', 'Brighton', 'West Roxbury',
                'Jamaica Plain', 'Hype Park', 'External', 'NA')
)
# Merge to replace codes with full names
df$district <- merge(df, district_mapping, by.x = "district", by.y = "code", all.x = TRUE)$full_name

############################ DATA CLEANED ######################################
write.csv(df, "~/Documents/crime_df_cleaned.csv")
################################################################################

# top-crime district => roxbury
# Where are the high-crime areas (streets) or hotspots in the city?

#### heatmap
# How do crime rates vary across different neighborhoods and streets?

#### A bar chart of the Top 10 most common crimes with labeling Shooting count 
# correlation between certain types of crimes and the presence of shootings

#### year to year analysis on crime and shooting => line graph
# trends in crime occurrences over time

# Are there specific hours or days of the week when crime rates are higher?
# Bar charts

# A (Boston) map exhibiting how crime rate changes in certain locations (districts,
# latitude, longitude indices) through the years.

############################ Visualization #####################################
### which year has the highest crime rate?
# crime rate throughout years from 2016 to 2022
df_ss <- df |> subset(df$year %in% c(2016, 2017, 2018, 2019, 2020, 2021, 2022))

ggplot(df_ss, aes(x = year)) +
  geom_histogram(stat="count", fill = "steelblue", color = "white") +
  labs(title = "Number of incidents from 2016 to 2022", x = "Year")

### Month of the year, Day of the Week, Time of the Day affect crime rates?
# crime rates by Month of the year
ggplot(df, aes(x = month)) + 
  geom_histogram(stat="count", fill = "orange", color = "white") +
  labs(title = "Distribution by month", x = "Month")

# crime rates by Day of the Week
ggplot(df, aes(x = day_of_week)) + 
  geom_histogram(stat="count", fill = "pink", color = "white") +
  labs(title = "Distribution by day of the week", x = "Day of the week")

# crime rates by Time of the Day
ggplot(df, aes(x = hour)) + 
  geom_histogram(stat="count", fill = "green", color = "white") +
  labs(title = "Distribution by Time of the Day", x = "Time of the Day")

### Top 10 most common crimes with Shooting Count?
top_crime <- df |> group_by(offense_description) |>
  summarise(count = n(), shooting_count = sum(shooting))
top_crime <- top_crime |> arrange(desc(count)) |> head(10)

ggplot(top_crime, aes(x = factor(offense_description, levels = offense_description),
                      y = count, fill = offense_description)) +
  geom_col() +
  geom_text(aes(label = shooting_count, color = "red"), vjust = -0.5) +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 8, angle = 45, hjust = 1, vjust = 1)) +
  labs(title = "Top 10 most common crimes with Shooting Count",
       x = "Crime", y = "Count")







