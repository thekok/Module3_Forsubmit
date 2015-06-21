
## This run_analysis.R does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



# Must Install packages("data.table") first
#  install.packages("data.table")

# Must Install packages("reshape2") first
#  install.packages("reshape2")


require("data.table")
require("reshape2")

sDataDir <- "./UCI HAR Dataset/"

# Load the activity labels
# 1 WALKING 2 WALKING_UPSTAIRS 3 WALKING_DOWNSTAIRS 4 SITTING 5 STANDING 6 LAYING
activity_labels <- read.table( paste(sDataDir, "activity_labels.txt", sep="") ) [,2]

# Load the data column names
# All together 561 columns
features <- read.table( paste(sDataDir, "features.txt", sep="") )[,2]

# Requirement : Extract only the measurements on the mean and standard deviation
extract_features <- grepl("mean|std", features)


# First block : Load and process X_test & y_test data.
  X_test <- read.table( paste(sDataDir, "test/X_test.txt", sep="") )
  y_test <- read.table( paste(sDataDir, "test/y_test.txt", sep="") )
  subject_test <- read.table( paste(sDataDir, "test/subject_test.txt", sep="") )

  # Load activity labels
  # y_test - initially only have 1 column - Activity_ID
  y_test[,2] = activity_labels[y_test[,1]]

  #Apply column names to the data accordingly
  names(X_test) = features
  names(y_test) = c("Activity_ID", "Activity_Label")
  names(subject_test) = "subject"

  # Requirement : Extract only the measurements on the mean and standard deviation
  X_test = X_test[,extract_features]


  # 'subject_train.txt': 
  # Each row identifies the subject who performed the activity for each window sample. 
  # Its range is from 1 to 30. 

  # 'y_train.txt': Training labels.

  # Join/Bind data - cbind - column bind
  test_data <- cbind(as.data.table(subject_test), y_test, X_test)




# Second Block Load and process X_train & y_train data.
  X_train <- read.table( paste(sDataDir, "train/X_train.txt", sep="") )
  y_train <- read.table( paste(sDataDir, "train/y_train.txt", sep="") )
  
  subject_train <- read.table( paste(sDataDir, "train/subject_train.txt", sep="") )

  # Load activity data
  # y_train - initially only have 1 column - Activity_ID
  y_train[,2] = activity_labels[y_train[,1]]

  #Apply column names to the data accordingly
  names(X_train) = features
  names(y_train) = c("Activity_ID", "Activity_Label")
  names(subject_train) = "subject"

  # Requirement : Extract only the measurements on the mean and standard deviation
  X_train = X_train[,extract_features]


  # Join/Bind data - cbind - column bind
  train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Union/Merge test and train data rbind - row bind
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
# melt the data by "subject", "Activity_ID", "Activity_Label" - And the rest of column name as vars
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# write.table() using row.name=FALSE
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
