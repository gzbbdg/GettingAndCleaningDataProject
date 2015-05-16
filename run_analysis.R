# read features
features<-read.table("rawData/features.txt")

# read activity labels 
a_labels<-read.table("rawData/activity_labels.txt")

# read training set
train<-read.table("rawData/X_train.txt")
a_train<-read.table("rawData/y_train.txt")

# read subject
subject_train<-read.table("rawData/subject_train.txt")
subject_test<-read.table("rawData/subject_test.txt")


# read test set
test<-read.table("rawData/X_test.txt")
a_test<-read.table("rawData/y_test.txt")

# extract features on the mean and standard deviation for each measurement
columns<-features[grep(pattern = "mean\\(\\)|std\\(\\)",x=features$V2,perl = TRUE),]


# filter columns on training and test set
train_filter<-train[,columns$V1]
test_filter<-test[,columns$V1]

# set column names
names(train_filter)<-columns$V2
names(test_filter)<-columns$V2

# merge activities with names
a_train<-merge(a_train,a_labels,by.x="V1",by.y="V1")
a_test<-merge(a_test,a_labels,by.x="V1",by.y="V1")

# merge sets with activity and subject
train_filter<-cbind(train_filter,subject=subject_train$V1,activity=a_train$V2)
test_filter<-cbind(test_filter,subject=subject_test$V1,activity=a_test$V2)

# merge test and training sets 
final_set<-rbind(train_filter,test_filter)

# create independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
summary<-final_set %>% group_by(activity,subject) %>% summarise_each(funs(mean))
write.table(summary,"tidydataset.txt",row.name=FALSE)