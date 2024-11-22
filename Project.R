
# Installing Required Libraries for this project

install.packages("dplyr")
install.packages("ggplot2")


# Load required libraries
library(dplyr)
library(ggplot2)


# Loading Data Set
# Data Set Location in DataSet Folder

attendance <- read.csv("DataSet/secondary-attendance-csv-2.csv")
free_school_meals <- read.csv("DataSet/secondary-free-school-meals-csv-1.csv")

str(attendance)
str(free_school_meals)

# Cleaning Data

# Data Set -> Student Attendance
attendance <- attendance %>%
  rename(
    TotalPupils = Tot_Pupil,
    AuthorizedSessions = AuthSess,
    UnauthorizedSessions = UnauthSes,
    TotalSessions = TotalSess
  )

# Data Set -> Free School Meals
free_school_meals <- free_school_meals %>%
  rename(
    FSMEntitled = FSMEntitl,
    TotalRoll = TotalNOR
  )

# Merging Data set
merged_data <- merge(
  attendance, free_school_meals, 
  by = "lsoa11cd"
)

# Inspecting Merged Data set
head(merged_data)



# Calculating Metics
merged_data <- merged_data %>%
  mutate(
    AttendanceRate = (AuthorizedSessions / TotalSessions) * 100,
    UnauthorizedAbsenceRate = (UnauthorizedSessions / TotalSessions) * 100,
    FSMProportion = (FSMEntitled / TotalRoll) * 100
  )

# Inspecting the Merged Data
head(merged_data)

# Summary statistics
summary(merged_data)


# Getting 2 rows 1 coulmn 
head(merged_data,2)


# Correlation b/w FSM PROPORTION and ATTANDANCE METRICS
correlation_attendance <- cor(merged_data$FSMProportion, merged_data$AttendanceRate)

# Correlation b/w FSM PROPORTION and UNAUTHORIZED ABSENCE RATE
correlation_unauth <- cor(merged_data$FSMProportion, merged_data$UnauthorizedAbsenceRate)


print(paste("Correlation between FSM Proportion and Attendance Rate:", correlation_attendance))
print(paste("Correlation between FSM Proportion and Unauthorized Absence Rate:", correlation_unauth))


# Quartile Analysis
merged_data <- merged_data %>%
  mutate(FSMQuartile = ntile(FSMProportion, 4))

# Summary of FSM Quartile
quartile_summary <- merged_data %>%
  group_by(FSMQuartile) %>%
  summarize(AverageAttendanceRate = mean(AttendanceRate, na.rm = TRUE))


