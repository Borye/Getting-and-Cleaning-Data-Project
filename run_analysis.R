## check working direction

getwd()

## reading data

features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "", header=FALSE)
x_train <- read.csv("./UCI HAR Dataset/train/x_train.txt", sep = "", header = FALSE)
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
x_test <- read.csv("./UCI HAR Dataset/test/x_test.txt", sep = "", header = FALSE)
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

## Step 1: merging data together

x_data <- rbind(x_train, x_test)
subject_data <- rbind(subject_train, subject_test)
y_data <- rbind(y_train, y_test)
complete_data <- cbind(subject_data, y_data, x_data)

## changing column names

colnames(complete_data)[1] <- "Subject"
colnames(complete_data)[2] <- "Activity"

## Step 3: replace the descriptive activity names

activity_labels$V2 <- as.character(activity_labels$V2)
for (i in seq_along(complete_data$Activity)) {
    for (j in seq_along(activity_labels$V2)) {
        if (complete_data$Activity[i] == activity_labels$V1[j]) {
            complete_data$Activity[i] <- activity_labels$V2[j] 
        }
    }
}

## Step 4: label the dataset with descriptive variable name

features$V2 <- as.character(features$V2)
colnames(complete_data)[3:563] <- features$V2

## Step 2: Extract the measurements on the mean and standard deviation

dataset1 <- complete_data[,c(1, 2, grep("std", colnames(complete_data)), grep("mean", colnames(complete_data)))]

## Step 5: creates a second, independent tidy data set with the average of each variable for each activity and each subject

dataset2 <- aggregate(dataset1, list(dataset1$Subject, dataset1$Activity), mean)
dataset2$Activity <- NULL
dataset2$Subject <- NULL
colnames(dataset2)[1:2] <- c("Subject", "Activity")

## wiriting data

write.table(dataset2, file = "./Data_tidy.txt", row.name = FALSE, sep = "\t")