rm(list = ls())  #clean memory
setwd("/Users/thibaultnidelet_boulot/Google Drive/BigData formation/Getting and Cleaning data/Week4/projet") #define working directory
if (!require("reshape2")) {install.packages("reshape2")};require("reshape2") #loading package "reshape2"

#loading general tables
activity_labels = read.table("activity_labels.txt") #loading table 
features = read.table("features.txt")

#loading "test" tables
X_test = read.table(paste(getwd(),"/test/","X_test.txt",sep="")) #Test set
subject_test = read.table(paste(getwd(),"/test/","subject_test.txt",sep="")) #loading tab of test subject
y_test = read.table(paste(getwd(),"/test/","y_test.txt",sep="")) #loading tab of coded activity 


names(X_test) = features[,2] #change X_test colnames by features names
X_test = X_test[,grepl("mean|std", names(X_test))] #Extract only the mean and standard deviation

#Bind data
data_test = data.frame(subject=subject_test[,1],activity_labels=activity_labels[y_test[,1],2] ,X_test)

#loading "train" tables
X_train = read.table(paste(getwd(),"/train/","X_train.txt",sep="")) #Training set
subject_train = read.table(paste(getwd(),"/train/","subject_train.txt",sep="")) #loading tab of test subject
y_train = read.table(paste(getwd(),"/train/","y_train.txt",sep="")) #loading tab of coded activity 


names(X_train) = features[,2] #change X_train colnames by features names
X_train = X_train[,grepl("mean|std", names(X_train))] #Extract only the mean and standard deviation

#Bind data
data_train = data.frame(subject=subject_train[,1],activity_labels=activity_labels[y_train[,1],2] ,X_train)

#Merge "test" and "train" data sets
data_total = rbind(data_test, data_train)

#change the names of the merged data set
names(data_total) <- gsub("\\(|\\)|-|,", "", names(data_total)) #supress "(" and ")" from names
names(data_total) <- gsub("BodyBody", "Body", names(data_total)) #replace "BodyBody" by "Body" to be consistent with names from features_info.txt

#sort the data by Subject and Activity
data_total = data_total[order(data_total$subject,data_total$activity_labels),] 


#create a long-form version of the data set
melt_data = melt(data_total, 
                 id = c("subject","activity_labels"), 
                 measure.vars = setdiff(colnames(data_total), c("subject","activity_labels")))

#Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + activity_labels ~ variable, mean)

#save the tidy data set
write.table(tidy_data, file = "./tidy_data.txt")











