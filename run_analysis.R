### Get data & Unzip

if (!file.exists('UCI HAR Dataset')) {
  url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "dataset.zip")
  unzip("dataset.zip")
}

# 1. Merges the training and the test sets to create one data set.

## Read train data

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header = FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",header = FALSE)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header = FALSE)

## Read train data

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",header = FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE)

## Combine data

X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
S <- rbind(subject_train, subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

## Read train data

features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
mdfeatures <- grepl("mean\\(\\)|std\\(\\)",features$V2)

## Extracts measurements

X <- X[,mdfeatures]

# 3. Uses descriptive activity names to name the activities in the data set.

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
Y[, 1] <- activity_labels[Y[, 1], 2]

# 4. Appropriately labels the data set with descriptive variable names.
names(X) <- gsub("\\(|\\)", "", (features[mdfeatures, 2]))
names(X) <-gsub("^t", "time", names(X))
names(X) <-gsub("^f", "frequency", names(X))
names(X) <-gsub("Acc", "Accelerometer", names(X))
names(X) <-gsub("Gyro", "Gyroscope", names(X))
names(X) <-gsub("Mag", "Magnitude", names(X))
names(X) <-gsub("BodyBody", "Body", names(X))
names(Y) <- "Activity"
names(S) <- "Subject"
data <- cbind(S,Y,X)

#5. Create summary dataset with means for each variable by each actifity and subject.

library(reshape2)
melted = melt(data, id.var = c("Subject", "Activity"))
tidydata = dcast(melted , Subject + Activity ~ variable, mean)

# Tidy data file
write.table(tidydata, file = "tidydata.txt", sep = " ", row.name = FALSE)
