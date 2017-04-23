# CodeBook

This is a technical description of the data for the project. It describes the variables, the data, and any transformations performed to clean up the data.

## Background to Data
The base data is on human activity recognition using smartphones.The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. They performed a protocol of activities composed of six basic activities: three static postures (standing, sitting, lying) and three dynamic activities (walking, walking downstairs and walking upstairs). The experiment also included postural transitions that occurred between the static postures. These are: stand-to-sit, sit-to-stand, sit-to-lie, lie-to-sit, stand-to-lie, and lie-to-stand. All the participants were wearing a smartphone (Samsung Galaxy S II) on the waist during the experiment execution. We captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz using the embedded accelerometer and gyroscope of the device. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of 561 features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

More information can be found [here](http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions)

## Transforms
1) Read in data
```
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
```

2) Apply names to data
```R
#Assign column and to test and train and get read for merge
colnames(xtrain) <- features_table[,2] 
colnames(ytrain) <-"activityId"
colnames(subject_train_set) <- "subjectId"
colnames(xtest) <- features_table[,2] 
colnames(ytest) <- "activityId"
colnames(subject_test_set) <- "subjectId"
colnames(activity_labels) <- c('activityId','activityType')
```

3) Merge data
```R
merge_train <- cbind(y_train, subject_train_set, xtrain)
merge_test <- cbind(y_test, subject_test_set, xtest)
total_data <- rbind(merge_train, merge_test)
```
4) Clean up variable names
```
#Now clean up the column names
col_names <- colnames(total_data)
names(total_data)<-gsub("^t", "time", names(total_data))
names(total_data)<-gsub("^f", "frequency", names(total_data))
names(total_data)<-gsub("Acc", "Accelerometer", names(total_data))
names(total_data)<-gsub("Gyro", "Gyroscope", names(total_data))
names(total_data)<-gsub("Mag", "Magnitude", names(total_data))
names(total_data)<-gsub("BodyBody", "Body", names(total_data))

```

5) Narrow down set
```

#Get index for items we are interested in
mean_and_std_col <- (grepl("activityId" , col_names) | 
                   grepl("subjectId" , col_names) | 
                   grepl("mean.." , col_names) | 
                   grepl("std.." , col_names) 
)
#Narrow down from main set and merge with activyt
set_for_mean_std <- total_data[ , mean_and_std_col == TRUE]
activity_names_set <- merge(set_for_mean_std, activity_labels,
                              by='activityId',
                              all.x=TRUE)
```

6) Order data and write tidy data out
```
#Aggregate data abd remove subjectid. Order data and then write
tidy <- aggregate(. ~subjectId + activityId, activity_names_set, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]

write.table(tidy, "tidy.txt", row.name=FALSE)


```

## Variables 

Tidy data contains 180 rows and 68 columns. Each row has averaged variables for each subject and each activity.

Subject column is numbered sequentially from 1 to 30. Activity column has 6 types as listed below.

1) WALKING
2) WALKING_UPSTAIRS
3) WALKING_DOWNSTAIRS
4) SITTING
5) STANDING
6) LAYING

Names of Features are labelled using descriptive variable names.

1) t is replaced by time
2) acc is replaced by accelerometer
3) gyro is replaced by gyroscope
4) prefix f is replaced by frequency
5) mag is replaced by magnitude
6) BodyBody is replaced by body

This give us the feature names:

 [1] "timeBodyAccelerometer-mean()-X"                
 [2] "timeBodyAccelerometer-mean()-Y"                
 [3] "timeBodyAccelerometer-mean()-Z"                
 [4] "timeBodyAccelerometer-std()-X"                 
 [5] "timeBodyAccelerometer-std()-Y"                 
 [6] "timeBodyAccelerometer-std()-Z"                 
 [7] "timeGravityAccelerometer-mean()-X"             
 [8] "timeGravityAccelerometer-mean()-Y"             
 [9] "timeGravityAccelerometer-mean()-Z"             
[10] "timeGravityAccelerometer-std()-X"              
[11] "timeGravityAccelerometer-std()-Y"              
[12] "timeGravityAccelerometer-std()-Z"              
[13] "timeBodyAccelerometerJerk-mean()-X"            
[14] "timeBodyAccelerometerJerk-mean()-Y"            
[15] "timeBodyAccelerometerJerk-mean()-Z"            
[16] "timeBodyAccelerometerJerk-std()-X"             
[17] "timeBodyAccelerometerJerk-std()-Y"             
[18] "timeBodyAccelerometerJerk-std()-Z"             
[19] "timeBodyGyroscope-mean()-X"                    
[20] "timeBodyGyroscope-mean()-Y"                    
[21] "timeBodyGyroscope-mean()-Z"                    
[22] "timeBodyGyroscope-std()-X"                     
[23] "timeBodyGyroscope-std()-Y"                     
[24] "timeBodyGyroscope-std()-Z"                     
[25] "timeBodyGyroscopeJerk-mean()-X"                
[26] "timeBodyGyroscopeJerk-mean()-Y"                
[27] "timeBodyGyroscopeJerk-mean()-Z"                
[28] "timeBodyGyroscopeJerk-std()-X"                 
[29] "timeBodyGyroscopeJerk-std()-Y"                 
[30] "timeBodyGyroscopeJerk-std()-Z"                 
[31] "timeBodyAccelerometerMagnitude-mean()"         
[32] "timeBodyAccelerometerMagnitude-std()"          
[33] "timeGravityAccelerometerMagnitude-mean()"      
[34] "timeGravityAccelerometerMagnitude-std()"       
[35] "timeBodyAccelerometerJerkMagnitude-mean()"     
[36] "timeBodyAccelerometerJerkMagnitude-std()"      
[37] "timeBodyGyroscopeMagnitude-mean()"             
[38] "timeBodyGyroscopeMagnitude-std()"              
[39] "timeBodyGyroscopeJerkMagnitude-mean()"         
[40] "timeBodyGyroscopeJerkMagnitude-std()"          
[41] "frequencyBodyAccelerometer-mean()-X"           
[42] "frequencyBodyAccelerometer-mean()-Y"           
[43] "frequencyBodyAccelerometer-mean()-Z"           
[44] "frequencyBodyAccelerometer-std()-X"            
[45] "frequencyBodyAccelerometer-std()-Y"            
[46] "frequencyBodyAccelerometer-std()-Z"            
[47] "frequencyBodyAccelerometerJerk-mean()-X"       
[48] "frequencyBodyAccelerometerJerk-mean()-Y"       
[49] "frequencyBodyAccelerometerJerk-mean()-Z"       
[50] "frequencyBodyAccelerometerJerk-std()-X"        
[51] "frequencyBodyAccelerometerJerk-std()-Y"        
[52] "frequencyBodyAccelerometerJerk-std()-Z"        
[53] "frequencyBodyGyroscope-mean()-X"               
[54] "frequencyBodyGyroscope-mean()-Y"               
[55] "frequencyBodyGyroscope-mean()-Z"               
[56] "frequencyBodyGyroscope-std()-X"                
[57] "frequencyBodyGyroscope-std()-Y"                
[58] "frequencyBodyGyroscope-std()-Z"                
[59] "frequencyBodyAccelerometerMagnitude-mean()"    
[60] "frequencyBodyAccelerometerMagnitude-std()"     
[61] "frequencyBodyAccelerometerJerkMagnitude-mean()"
[62] "frequencyBodyAccelerometerJerkMagnitude-std()" 
[63] "frequencyBodyGyroscopeMagnitude-mean()"        
[64] "frequencyBodyGyroscopeMagnitude-std()"         
[65] "frequencyBodyGyroscopeJerkMagnitude-mean()"    
[66] "frequencyBodyGyroscopeJerkMagnitude-std()"     
[67] "subject"                                       
[68] "activity"
