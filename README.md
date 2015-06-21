### Coursera - Getting and Cleaning Data

This is explain what the run_analysis.R did


1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Pre-requisite
Must Install packages("data.table") first
install.packages("data.table")
Must Install packages("reshape2") first
install.packages("reshape2")


### Steps
1. Load the activity labels to activity_labels
2. Load features lables to features
3. Use grepl to filter the required columns "mean|std" to extract_features
4. Load and process X_test & y_test data
5. Load and process X_train & y_train data
6. Merge test and train data using rbind
7. melt the data by "subject", "Activity_ID", "Activity_Label" - And the rest of column name as vars
8. Apply mean function to dataset using dcast function
9. write.table() using row.name=FALSE





