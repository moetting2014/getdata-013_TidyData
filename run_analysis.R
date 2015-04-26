# Matt Oetting - Assignment 3    Date:4/20/15
# Set working directory to: "UCI HAR Dataset" uncompressed folder location


run_analysis <- function(folder="UCI HAR Dataset",
                         id_test="./test/subject_test.txt",
                         id_train="./train/subject_train.txt",
                         table_test="./test/X_test.txt",
                         table_train="./train/X_train.txt",
                         test_activity="./test/y_test.txt",
                         train_activity="./train/y_train.txt",
                         measurement_features="./features.txt"
)   
    {
    ## Load the appropiate libraries
    library(plyr)
    library(dplyr)
    library(gdata)
    
    ## ------------- Question 1
    ## The code will create 4 Data Frames. The 4 DFs will be divided into Groups. These Groups will then 
    ## be RBIND and CBIND to be consolidated into 2 DFs that will contain either the TEST or TRAIN datasets.
    ## The TEST and TRAIN datasets will be combined into 1 big DF called "final.df". 
    
    ## The Group DFs will be labeled as thus:
    ## Group 1 of Data Frames will be: Subject_IDs
    ## Group 2 of Data Frames will be: Activity_Labels
    ## Group 3 of Char Vector will be: Measurement Variables Names
    ## Group 4 of Data Frames will be: Recorded measurement values 
        
    ## Group 1:
    subid_test.df <- read.table(id_test)                # A df of: 2947 rows x 1 col
    subid_train.df <- read.table(id_train)              # A df of: 7352 rows x 1 col

    ## Renaming the Column name from: "V1" to Subject_ID    
    names(subid_test.df)[names(subid_test.df)=="V1"] <- "Subject_ID"
    names(subid_train.df)[names(subid_train.df)=="V1"] <- "Subject_ID"
  
    ## Group 2:
    test_activity.df <- read.table(test_activity)       # A df of: 2947 rows x 1 col
    train_activity.df <- read.table(train_activity)     # A df of: 7352 rows x 1 col
    
    ## Renaming the Column name from: V1 to Activity
    names(test_activity.df)[names(test_activity.df)=="V1"] <- "Activity"
    names(train_activity.df)[names(train_activity.df)=="V1"] <- "Activity"

    ## Group 3:
    con <- file(measurement_features,"r")
    col_names <- readLines(con)                         # A Char vector of length 561
    close(con)
    
    ## Group 4:
    table_test.df <- read.table(table_test)             # A df of: 2947 rows x 561 col
    table_train.df <- read.table(table_train)           # A df of: 7352 rows x 561 col 

    ## Renaming the Column names from: V1/V561 to "measurement_features.txt" Char Vector
    colnames(table_test.df) <- col_names
    colnames(table_train.df) <- col_names

    ## Combine Group 1, 2, and 4 DFs
    test.df <- cbind(subid_test.df,test_activity.df,table_test.df)      # A df of: 2947 rows x 563 col
    train.df <- cbind(subid_train.df,train_activity.df,table_train.df)  # A df of: 7352 rows x 563 col

    ## Combine the TEST/TRAIN DFs
    final.df <- rbind(test.df,train.df)                 # A df of: 10299 rows x 563 col
    final.df <- final.df[order(final.df$Subject_ID,final.df$Activity,final.df$"1 tBodyAcc-mean()-X"),]
  

    ## ------------- Question 2    
    ## From the Char Vector captured in "measurement_features", extract only the measurements that pertain 
    ## to "MEAN" and "STD" and create a new DF with only those said columns.  The new DF will be called
    ## "mean_std.df"  
    patterns <- c("mean","std")
    matches_col <- unique(grep(paste(patterns,collapse="|"),col_names,value=FALSE))  # isolate columns with MEAN and STD

    data_set.df <- final.df[,3:563]             # The 'data_set.df' is: 10299 rows x 561 col
    data_set.df <- data_set.df[,matches_col]    # Extract only the MEAN and STD columns. The df is: 10299 rows x 79 col
    mean_std.df <- cbind(final.df$"Subject_ID",final.df$"Activity",data_set.df)  # The df is: 10299 rows x 81 col

    ## Cleaning up the names of the Columns in MEAN_STD.DF
    names(mean_std.df)[names(mean_std.df)=="final.df$Subject_ID"] <- "Subject_ID"
    names(mean_std.df)[names(mean_std.df)=="final.df$Activity"] <- "Activity"

    
    ## ------------- Question 3 and 4
    ## Renaming the values in the "Activity" column to more descriptive names other than 
    ## integer values. A value of 1 will correspond to "Walking", 2 to "W. Upstairs",
    ## 3 to "W. Downstairs", 4 to "Sitting", 5 to "Standing, and 6 to "Laying".
    ## The new DF will be called: "mean_std_desc.df"
    activity_label <- as.factor(mean_std.df$"Activity")
    activity_label <- revalue(activity_label,c("1"="Walking",
                                               "2"="W. Upstairs",
                                               "3"="W. Downstairs",
                                               "4"="Sitting",
                                               "5"="Standing",
                                               "6"="Laying"))
    mean_std_desc.df <- mean_std.df
    mean_std_desc.df$"Activity" <- activity_label
    mean_std_desc.df    
    
    ## ------------- Question 5
    ## Create a new DF, called 'tidy.df', for only the average of each variable in "mean_std_desc.df" 
    ## for each Activity and each Subject. 
    
    ## 1) the "mean_std.df" will be split twice! The first split will be into a LIST based on 
    ## 30 Subject_IDs. The second split will based on the 6 Activities per Subject_ID. The result
    ## will be a LIST of Activities within the LIST of Subject_IDs.
    ## 2) a FOR loop will be created to cycle through the LIST of 30 Subject_IDs.
    ## 3) within the FOR loop, SAPPLY will calculated the Mean value of each variable within 
    ## the Subject_ID.
    ## 4) SAPPLY will calculate the mean of the ACTIVITY and display the result in the first row.
    ## This is an unnecessary row and is removed.
    ## 5) The variable names are relabeled from 1 to "Walking", etc.
    ## 6) An additional Subject_ID column is appended to the tidy.df.
    ## 7) Write.fwf is used to output the tidy.df to a text file.
    x.df <- lapply(split(mean_std.df[,2:81],mean_std.df$Subject_ID),function(x) split(x,x$Activity))
    coln <- c("Walking","W. Upstairs","W. Downstairs","Sitting","Standing","Laying")
    
    i <- 1                                  # Index for the FOR loop. 
    tidy.ds <- sapply(x.df[[i]],colMeans)   # Calculate the Mean for every "MEAN" and "STD" column
    tidy.ds <- tidy.ds[-c(1),]              # Remove the 1st row (which is a numeric value for Activity)
    colnames(tidy.ds) <- coln               # Rename the variables to: "Walking", etc
    tidy.df <- as.data.frame(tidy.ds)
    tidy.df$Sub_ID <- i
   
    for(i in 2:30){
        y <- sapply(x.df[[i]],colMeans)      # Calculate the Mean for every "MEAN" and "STD" column
        y <- y[-c(1),]                       # Remove the 1st row (which is a numeric value for Activity)
        colnames(y) <- coln                  # Rename the variables to: "Walking", etc
        y.df <- as.data.frame(y)
        y.df$Sub_ID <- i
        tidy.df <- rbind(tidy.df,y.df)
        } 
    
    
    write.fwf(tidy.df,"./tidy_data.txt")
    tidy.df
}
