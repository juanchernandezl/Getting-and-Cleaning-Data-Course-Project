
# Getting and Cleaning Data Course Project

rm(list = ls(all = TRUE))
library(plyr)

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# 1 Merges the training and the test sets to create one data set.
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table('./data/UCI HAR Dataset/features.txt')

data_mean_sdev <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, data_mean_sdev]
names(x_data) <- features[data_mean_sdev, 2]

# 3 Uses descriptive activity names to name the activities in the data set.
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

y_data[, 1] <- activityLabels[y_data[, 1], 2]
names(y_data) <- "activity"

# 4 Appropriately labels the data set with descriptive variable names.
names(subject_data) <- "subject"
data <- cbind(x_data, y_data, subject_data)

# 5 Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
data_project <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(data_project, "tidy_data.txt", row.name=FALSE)


