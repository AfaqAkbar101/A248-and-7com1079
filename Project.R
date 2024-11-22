
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
# Renaming Columns for better understanding
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

# Merging Data 
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


print(quartile_summary)



# Visulization of Quartile Analysis
# Bar Plot of FSM Quartile vs Average Attendance Rate

ggplot(quartile_summary, aes(x = FSMQuartile, y = AverageAttendanceRate)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(
    title = "Average Attendance Rate by FSM Quartile",
    x = "FSM Quartile",
    y = "Average Attendance Rate"
  )


# Scatter Plot
# Attendance Rate vs FSM Proportion


ggplot(merged_data, aes(x = FSMProportion, y = AttendanceRate)) +
  geom_point(color = "blue", alpha = 0.7) +
  ggtitle("Attendance Rate vs Free School Meal Proportion") +
  xlab("FSM Proportion (%)") +
  ylab("Attendance Rate (%)") +
  theme_minimal()


# Scatter Plot
# Unauthorized Absence Rate vs FSM Proportion'

ggplot(merged_data, aes(x = FSMProportion, y = UnauthorizedAbsenceRate)) +
  geom_point(color = "red", alpha = 0.7) +
  ggtitle("Unauthorized Absence Rate vs Free School Meal Proportion") +
  xlab("FSM Proportion (%)") +
  ylab("Unauthorized Absence Rate (%)") +
  theme_minimal()

# Bar Plot
# Average Attendance Rate by FSM Proportion Quartiles

ggplot(quartile_summary, aes(x = factor(FSMQuartile), y = AverageAttendanceRate)) +
  geom_bar(stat = "identity", fill = "green", alpha = 0.8) +
  ggtitle("Average Attendance Rate by FSM Proportion Quartiles") +
  xlab("FSM Quartile") +
  ylab("Average Attendance Rate (%)") +
  theme_minimal()




# Histogram
# Distribution of Attendance Rates

ggplot(merged_data, aes(x = AttendanceRate)) +
  geom_histogram(bins = 30, fill = "blue", color = "black", alpha = 0.7) +
  ggtitle("Distribution of Attendance Rates") +
  xlab("Attendance Rate (%)") +
  ylab("Frequency") +
  theme_minimal()



# Histogram
# Distribution of FSM Proportion

ggplot(merged_data, aes(x = FSMProportion)) +
  geom_histogram(bins = 30, fill = "purple", color = "black", alpha = 0.7) +
  ggtitle("Distribution of FSM Proportion") +
  xlab("FSM Proportion (%)") +
  ylab("Frequency") +
  theme_minimal()



# Density Plot
# Attendance Rate Distribution

ggplot(merged_data, aes(x = AttendanceRate)) +
  geom_density(fill = "blue", alpha = 0.7) +
  ggtitle("Density Plot of Attendance Rate") +
  xlab("Attendance Rate (%)") +
  ylab("Density") +
  theme_minimal()


# Boxplot
# Attendance Rate by FSM Quartile

ggplot(merged_data, aes(x = factor(FSMQuartile), y = AttendanceRate)) +
  geom_boxplot(fill = "lightgreen", color = "black", alpha = 0.7) +
  ggtitle("Attendance Rate by FSM Quartile") +
  xlab("FSM Quartile") +
  ylab("Attendance Rate (%)") +
  theme_minimal()

  


