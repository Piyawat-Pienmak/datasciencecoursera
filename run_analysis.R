library(dplyr)
features<-read.table("./data/UCI HAR Dataset/features.txt")
activity_labels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt",col.names = 'y')
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt",col.names = 'subject')
x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt",col.names = 'y')
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt",col.names = 'subject')

#no.1 Merge train and test data
train_merge<-cbind(x_train,y_train,subject_train)
test_merge<-cbind(x_test,y_test,subject_test)
all_merge<-rbind(train_merge,test_merge)

#no.2 Extracts mean and standard deviation by index
extract_index<-c(grep("mean|std",features$V2),562,563) #Get index Xmean, Xstd, y, subject.
extract<-select(all_merge,extract_index) #Extracts Xmean, Xstd, y, subject.

#no.3 Mapping values from 1 to 5 to activity name
extract$y[extract$y==1]<-"WALKING"
extract$y[extract$y==2]<-"WALKING_UPSTAIRS"
extract$y[extract$y==3]<-"WALKING_DOWNSTAIRS"
extract$y[extract$y==4]<-"SITTING"
extract$y[extract$y==5]<-"STANDING"
extract$y[extract$y==6]<-"LAYING"

#no.4 Naming columns variable.
colnames(extract)[1:79]<-features[grep("mean|std",features$V2),"V2"]
colnames(extract)[80]<-"activity"

#no.5 Average calculation grouped by activity and subject.
Avg <- extract %>% group_by(activity,subject) %>% summarise_all(list(mean))
