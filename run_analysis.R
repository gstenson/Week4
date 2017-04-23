library(dplyr)

fileName <- "./data/Dataset.zip"

#Create a subfolder to hold the base data downloaded
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")

unzip(fileName,overwrite = TRUE)

# Reading trainings tables:
xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train_set <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test_set <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features_table <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assign column and to test and train and get read for merge
colnames(xtrain) <- features_table[,2] 
colnames(ytrain) <-"activityId"
colnames(subject_train_set) <- "subjectId"
colnames(xtest) <- features_table[,2] 
colnames(ytest) <- "activityId"
colnames(subject_test_set) <- "subjectId"
colnames(activity_labels) <- c('activityId','activityType')

merge_train <- cbind(y_train, subject_train_set, xtrain)
merge_test <- cbind(y_test, subject_test_set, xtest)
total_data <- rbind(merge_train, merge_test)

#Now clean up the column names
col_names <- colnames(total_data)
names(total_data)<-gsub("^t", "time", names(total_data))
names(total_data)<-gsub("^f", "frequency", names(total_data))
names(total_data)<-gsub("Acc", "Accelerometer", names(total_data))
names(total_data)<-gsub("Gyro", "Gyroscope", names(total_data))
names(total_data)<-gsub("Mag", "Magnitude", names(total_data))
names(total_data)<-gsub("BodyBody", "Body", names(total_data))


#Get index for items we are interested in
mean_and_std_col <- (grepl("activityId" , col_names) | 
                   grepl("subjectId" , col_names) | 
                   grepl("mean.." , col_names) | 
                   grepl("std.." , col_names) 
)
#Narrow down from main set and merge with activyt
set_for_mean_std <- tota_data[ , mean_and_std_col == TRUE]
activity_names_set <- merge(set_for_mean_std, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#Aggregate data abd remove subjectid. Order data and then write
tidy <- aggregate(. ~subjectId + activityId, activity_names_set, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]

write.table(tidy, "tidy.txt", row.name=FALSE)
