#this script is designed to collect, merge and organize the data into a tidy dataset

#Merging the two data sets:

  #To get the training & test data
  trainData <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
  testData <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
  
  #To get the subject numbers for training & test data
  trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
  testSub <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
  
  #To get activity numbers for training & test data
  trainActivity <- read.table("UCI HAR Dataset/train/Y_train.txt", header=FALSE)
  testActivity <- read.table("UCI HAR Dataset/test/Y_test.txt", header=FALSE)
  
  #Merging training data columns:
  train <- cbind(trainSub,trainActivity, trainData)
  
  #Merging test data
  test <- cbind(testSub,testActivity,testData)
  
  #Merging training & test data
  fullData <- rbind(train,test)
  
#Adding column names and extracting mean and std for each measurement.
  #loading in the measurement names
  measure <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
  colnames(fullData) <-c("subject","activity",as.character(measure$V2))
  #getting the index for mean and std dev
  names <- grep("mean|std",as.character(measure[,2]))
  #Adjusting for two new columns
  names <- names + 2
  data <- fullData[,append(c(1,2),names)]
  
#Swiching activity names from numbers to descriptions
  
  labels <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)
  data$activity <- labels[data$activity,2]
  
#Create new data set with means of all variables grouped by subject & activity
  newData <- aggregate(. ~ subject + activity, data = data, mean)
  
  write.table(newData,"tidydata.txt",row.name=FALSE)