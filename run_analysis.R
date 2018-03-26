##Data Cleaning Final Project --Huilong Zhou

## Load the packages
library("dplyr")
library("reshape2")

## Load the data and unzip the files
## setwd("C:/Users/huilong/Documents/DataScience/DS3_Project")
path=getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Data.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))

unzip(zipfile = "Data.zip")


## Loads the training file
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_names]
train_Activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_Subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_Subjects, train_Activities, train)

## Loads the test file
test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_names]
test_Activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_Subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Subjects, test_Activities, test)


# Load the features file, don't convert text labels to factors
features <- read.table('./UCI HAR Dataset/features.txt')
features[,2] <- as.character(features[,2])

# Load the activity labels file
activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
activities[,2] <- as.character(activities[,2])

features_names <- grep(".*mean.*|.*std.*", features[,2])
features_names.names <- features[features_names,2]
features_names.names <- gsub('[-()]', '', features_names.names)


## Merge the training and the test sets to create one dataset
## Extract only the measurements on the mean and standard deviation for each measurement

Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", features_names.names)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))



# turn activities & subjects into factors
Data$activity <- factor(Data$activity, levels = activities[,1], labels = activities[,2])
Data$subject <- as.factor(Data$subject)

Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

