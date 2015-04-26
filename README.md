# getdata-013_TidyData
# Getting and Cleaning Data Course Project

# Matt Oetting - Assignment 3    Date:4/26/15
# Set working directory to: "UCI HAR Dataset" uncompressed folder location
## ------------- Question 1
    ## The code will create 4 Data Frames. The 4 DFs will be divided into Groups. These Groups will then 
    ## be RBIND and CBIND to be consolidated into 2 DFs that will contain either the TEST or TRAIN datasets.
    ## The TEST and TRAIN datasets will be combined into 1 big DF called "final.df". 
    
    ## The Group DFs will be labeled as thus:
    ## Group 1 of Data Frames will be: Subject_IDs
    ## Group 2 of Data Frames will be: Activity_Labels
    ## Group 3 of Char Vector will be: Measurement Variables Names
    ## Group 4 of Data Frames will be: Recorded measurement values 

## ------------- Question 2    
    ## From the Char Vector captured in "measurement_features", extract only the measurements that pertain 
    ## to "MEAN" and "STD" and create a new DF with only those said columns.  The new DF will be called
    ## "mean_std.df" 
    
## ------------- Question 3 and 4
    ## Renaming the values in the "Activity" column to more descriptive names other than 
    ## integer values. A value of 1 will correspond to "Walking", 2 to "W. Upstairs",
    ## 3 to "W. Downstairs", 4 to "Sitting", 5 to "Standing, and 6 to "Laying".
    ## The new DF will be called: "mean_std_desc.df"
    
## ------------- Question 5
    ## Create a new DF, called 'tidy.df', for only the average of each variable in "mean_std_desc.df" 
    ## for each Activity and each Subject. 
    
    ## 1) the "mean_std.df" will be split twice! The first split will be into a LIST based on 
    ## 30 Subject_IDs. The second split will based on the 6 Activities per Subject_ID. The result
    ## will be a LIST of Activities within the LIST of Subject_IDs.
    ## 2) a FOR loop will be created to cycle through the LIST of 30 Subject_IDs.
    ## 3) within the FOR loop, SAPPLY will calculated the Mean value of each variable within 
    ## the Subject_ID.
    ## 4) SAPPLY will also calculate the mean of the ACTIVITY and display the result in the first row.
    ## This is an unnecessary row and is removed.
    ## 5) The variable names are relabeled from 1 to "Walking", etc.
    ## 6) An additional Subject_ID column is appended to the tidy.df. 
    ## 7) Write.fwf is used to output the tidy.df to a text file.
