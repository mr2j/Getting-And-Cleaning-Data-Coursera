
### ASSIGNMENT WEEK 4                 
### COURSERA GETTING AND CLEANING DATA
### JOHNNY JENSEN 2017-07-09


# CLEAN UP
rm(list=ls())

# MAKE SURE RUN_ANALYSIS.R IS IN UNZIPPED UCI HAR DATASET FOLDER


##################
### QUESTION 1 ###
##################

# Merges the training and the test sets to create one data set.

# READ DATA
# READ GENERIC DATA
features <- read.table("./features.txt", stringsAsFactors = FALSE) # FEATURE VECTOR
activity <- read.table("./activity_labels.txt", stringsAsFactors = FALSE) # ACTIVITY LABELS

# READ TRAINING DATA
train.subject <-  read.table("./train/subject_train.txt", stringsAsFactors = FALSE)  
train.activity <- read.table("./train/y_train.txt", stringsAsFactors = FALSE)        
train.data <-     read.table("./train/X_train.txt", stringsAsFactors = FALSE)        

# READ TEST DATA
test.subject <-  read.table("./test/subject_test.txt", stringsAsFactors = FALSE)  
test.activity <- read.table("./test/y_test.txt", stringsAsFactors = FALSE)        
test.data <-     read.table("./test/X_test.txt", stringsAsFactors = FALSE)        


# MODIFY 
# ADD COLUMN NAMES FOR READABILITY
colnames(features) = c("feature_id","feature_label")
colnames(activity) = c("activity_id","activity_label")

colnames(train.subject) = "subject_id"
colnames(train.activity) = "activity_id"
colnames(train.data) = features$feature_label   

colnames(test.subject) = "subject_id"
colnames(test.activity) = "activity_id"
colnames(test.data) = features$feature_label    


# NOT ALL COLUMNS IN FEATURES DATA SET ARE UNIQUE (FIX IN QUESTION 2)
length(features$feature_label)          # 561 COLUMN NAMES
length(unique(features$feature_label))  # 477 UNIQUE COLUMNS NAMES


# MERGE AND COMBINE 
# MERGE TRAINING AND TEST DATA TO NEW DATA FRAMES
train.complete <- cbind(train.subject,train.activity,train.data)
test.complete <- cbind(test.subject,test.activity,test.data)

# COMBINE TRAINING AND TEST DATA 
q1.data <- rbind(train.complete,test.complete)


##################
### QUESTION 2 ###
##################

### Extracts only the measurements on the mean and standard deviation for each measurement.

# Not all columns in final.data are unique, or using allowed characters.
# This creates a problem for further data manipulation, so make them unique:

# BUILD UNIQUE COLUMNS DF
unique_columns <- as.data.frame(make.names(names(q1.data), unique = TRUE))

# SET COLUMN NAME FOR UNIQUE_COLUMNS DF
colnames(unique_columns) = "unique_column"

# APPLY UNIQUE COLUMN NAMES TO Q1.DATA
colnames(q1.data) = unique_columns$unique_column

# Now we can use dplyr for further data manipulation ->

# LOAD DPLYR
library(dplyr)

# CONVERT FINAL.DATA TO TIBBLE FOR BETTER OVERVIEW
q1.data <- tibble::as.tibble(q1.data)

# SELECT THE COLUMNS WE WANT (MEAN AND STANDARD DEVIATION)
q2.data <- select(q1.data, subject_id, activity_id, matches("mean\\.|std\\.|Mean", ignore.case = FALSE))

# The above regex expression gets the more obvious mean() and std() columns,
# but also the angle column variables that also contain a mean value.

# CLEAN UP
rm(unique_columns)


##################
### QUESTION 3 ###
##################

### Uses descriptive activity names to name the activities in the data set.

# ADDING DESCRIPTIVE ACTIVITY_LABEL TO Q3 DATA FRAME
q3.data <- left_join(q2.data, activity, by = "activity_id")


##################
### QUESTION 4 ###
##################

### Appropriately labels the data set with descriptive variable names.

# TRANSFER DATA
q4.data <- q3.data

# SEARCH AND REPLACE COLUMN NAMES BY EACH REGEX EXPRESSION BELOW
change <- gsub("\\.\\.\\.","\\.",names(q4.data)); colnames(q4.data) = change
change <- gsub("\\.\\.","\\.",names(q4.data)); colnames(q4.data) = change
change <- gsub("std","StdDev",names(q4.data)); colnames(q4.data) = change
change <- gsub("mean","Mean",names(q4.data)); colnames(q4.data) = change
change <- gsub("^t","time\\.",names(q4.data)); colnames(q4.data) = change
change <- gsub("^f","freq\\.",names(q4.data)); colnames(q4.data) = change
change <- gsub("\\.$","",names(q4.data)); colnames(q4.data) = change
change <- gsub("angle.t","angle.time",names(q4.data)); colnames(q4.data) = change
change <- gsub("\\.gravity","\\.Gravity",names(q4.data)); colnames(q4.data) = change

# CLEAN UP
rm(change)

# CHECK CHANGED COLUMN NAMES
# names(q4.data)


##################
### QUESTION 5 ###
##################

### From the data set in step 4, creates a second, independent tidy data set
### with the average of each variable for each activity and each subject.

# TRANSFER DATA
q5.data <- q4.data

# GROUP DATA BY SUBJECT AND ACTIVITY AND CALCULATE MEAN VALUE FOR ALL VARIABLES
q5.data <- aggregate(x = q5.data[, 3:75], by = list(q5.data$subject_id, q5.data$activity_label), FUN = "mean")

# CHANGE COLUMN NAMES TO DESCRIPTIVE NAMES
colnames(q5.data)[1] <- "subject"
colnames(q5.data)[2] <- "activity"

# WRITE FILE TO SUBMIT
write.table(q5.data, "./tidy_data.txt", row.names = FALSE)
