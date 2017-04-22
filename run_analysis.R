library(dplyr)

fileName <- "./data/Dataset.zip"

#Create a subfolder to hold the base data downloaded
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")

unzip(fileName,overwrite = TRUE)

# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')



colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
total_data <- rbind(mrg_train, mrg_test)


colNames <- colnames(total_data)
-----------------FIX
names(total_data)<-gsub("^t", "time", names(total_data))
names(total_data)<-gsub("^f", "frequency", names(total_data))
names(total_data)<-gsub("Acc", "Accelerometer", names(total_data))
names(total_data)<-gsub("Gyro", "Gyroscope", names(total_data))
names(total_data)<-gsub("Mag", "Magnitude", names(total_data))
names(total_data)<-gsub("BodyBody", "Body", names(total_data))
---------------------
  
  
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "tidy.txt", row.name=FALSE)
