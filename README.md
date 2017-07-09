# Getting And Cleaning Data Coursera
Johnny Jensen 2017-07-09

This assignment is about getting, cleaning and structuring mobile accelerometer and gyrometer data.

You can run the script run_analysis.R, as long as it is located in the unzipped UCI HAR Dataset folder.

Question 1 - Merges the training and the test sets to create one data set.
Step 1. The script reads all data from files into dataframes.
Step 2. Adds descriptive column names.
Step 3. Adds column names to large feature data frame, from dataframe "features".
Step 4. Results -> q1.data
Note : Not all column names in "features" data frame are unique and/or are using allowed characters.
This will hinder data manipulation and will be fixed for question 2.

Question 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
Step 1. We build unique columns for our feature data, using make.names function.
Step 2. We select only columns pertaining to mean or standard deviation, using regex expressions.
Step 3. Results -> q2.data
Note : We catch the most obvious mean() and std() columns, but also some angle columns that contain mean values.

Question 3 - Uses descriptive activity names to name the activities in the data set.
Step 1. Adding descriptive activity_label to dataset using dplyr left_join function.
Step 2. Results -> q3.data

Question 4 - Appropriately labels the data set with descriptive variable names.
Step 1. Through a series of gsub regex replacements, the dataset is formed into descriptive variable names.
Step 2. Results -> q4.data

Question 5 - From the data set in step 4, create a second, independent tidy data set, 
              with the average of each variable for each activity and each subject.
Step 1. Group data by subject and activity and calculate mean value for all variables.
Step 2. Change column names to descriptive names.
Step 3. Write file to disk - tidy_data.txt.
Step 4. Results -> q5.data

Some help data frames gets removed when the script runs, while others are left for the peer review.
Thanks for helping out ! /Johnny 
