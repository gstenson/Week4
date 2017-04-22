**Week 4 Project for Getting and Cleaning Data**
=================================================

**Overview**
-------------
This project is demonstrate ones ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

The data for the project represent data collected from the accelerometers from the Samsung Galaxy S smartphone. It can be found Get the dataset from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

This project contains an R script called run_analysis.R that does the following: 

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

**Steps Involved**
--------------------
This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1) Download the raw data file
2) Unzip file into data folder
3) Extract data using unzip
4) Read training, test and activity label data
5) Applies activity and subjectid columms in prepartion of merge
6) Merge data
7) Apply meaningful variables names to data
8) Writes out tidy datat set.

**What is in this folder**
---------------------------

1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data [here](https://github.com/gstenson/Week4/blob/master/CodeBook.md). 

