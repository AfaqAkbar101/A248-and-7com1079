install.packages("dplyr")
install.packages("ggplot2")
# Load required libraries
library(dplyr)
# 1. Load the datasets
attendance <- read.csv("DataSet/secondary-attendance-csv-2.csv")
free_school_meals <- read.csv("DataSet/secondary-free-school-meals-csv-1.csv")

# Inspect structure 
str(attendance)
str(free_school_meals)

# Clean columns
attendance <- attendance %>%
  rename(
    TotalPupils = Tot_Pupil,
    AuthorizedSessions = AuthSess,
    UnauthorizedSessions = UnauthSes,
    TotalSessions = TotalSess
  )

free_school_meals <- free_school_meals %>%
  rename(
    FSMEntitled = FSMEntitl,
    TotalRoll = TotalNOR
  )

# 2. Merging datasets on code
merged_data <- merge(
  attendance, free_school_meals, 
  by = "lsoa11cd"
)

# Inspected data
head(merged_data)



# Calculate new metrics
merged_data <- merged_data %>%
  mutate(
    AttendanceRate = (AuthorizedSessions / TotalSessions) * 100,
    UnauthorizedAbsenceRate = (UnauthorizedSessions / TotalSessions) * 100,
    FSMProportion = (FSMEntitled / TotalRoll) * 100
  )

# Inspect the merged data with new metrics
head(merged_data)

# Summary statistics
summary(merged_data)




