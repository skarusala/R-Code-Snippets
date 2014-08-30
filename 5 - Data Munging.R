library(ggplot2)
library(ggthemes)
library(scales)
library(reshape2)     # For melt()
library(dplyr)

pf <- read.csv('pseudo_facebook.tsv', sep = '\t')
yo <- read.csv('yogurt.csv')
statesInfo <- read.csv('stateData.csv')
data('airquality')
airquality

#####################################################
# 1. LOOKING AT THE DATA                            
#####################################################

# About a dataset
str(statesInfo)                                                      # shows metadata of a dataset
nrow(statesInfo)                                                     # count rows
names(statesInfo)                                                    # lists the column names in a dataframe
ncol(statesInfo)                                                     # count columns
head(statesInfo)                                                     # shows first few rows of dataset
unique(statesInfo$X)                                                 # shows unique values in the variable


# Indexing/Subsetting columns of a dataframe
subset(statesInfo, state.region == 2  )                              # subset function by selecting column headers
statesInfo[,c(1,2,5)]                                                # subsetting: the numbers are the column number
statesInfo[,c("X","income")]                                         # subsetting: based on column headers
statesInfo$population                                                # subsetting a column into a vector
statesInfo[c(1,2,5),]                                                # subsetting ROWS
statesInfo[(statesInfo$state.region == 2 
            & statesInfo$life.exp > 69),]                            # subsetting based on conditionals


# Ordering levels in factors within a dataframe
levels(reddit$age.range)                                             # lists all the levels for the factor age.range
reddit$age.range <- 
    ordered(reddit$age.range,                                        # re-orders the age.range variable factor levels in the reddit dataset
            levels = c( "Under 18", "18-24", 
                        "25-34", "35-44", "45-54",
                        "55-64", "65 or Above"))

reddit$age.range <- 
    factor(reddit$age.range,                                         # does the same as above, using the factor function
           levels = c("Under 18", "18-24", 
                      "25-34", "35-44", "45-54",
                      "55-64", "65 or Above"),
           ordered = TRUE)

#recoding variables with dplyr
applicants <- read.csv("D:/Google Drive/Documents/Analytics/R/Datasets/collegeadmit.csv")
applicants$rank2 <- as.factor(applicants$rank)
library(plyr)
applicants$rank2 <- revalue(applicants$rank2, 
                            c("1" = "Tier1","2" = "Tier2",
                              "3" = "Tier3","4" = "Tier4"))

#####################################################
# 2. DEALING WITH ROWNS, COLUMNS AND VALUES            
#####################################################

# Reordering columns based on their index
aql <- airquality[c(5:6, 1:4)]

# Add/Drop variables
noFrost <- subset(statesInfo, select = -frost)                       # dropping the frost variable

# Removing row.names variable
row.names(statesInfo) <- NULL                                        # removing artificially created row names

# Extracting records with NA's
NAS <- statesInfo[!complete.cases(statesInfo),]                      # to see all records that contain atleast one NA

# Dealing with NA's 
Clean_Data <- pf[complete.cases(pf), ]                               # removing all observations with NA
Clean_Data2 <- pf[complete.cases(pf[,1:2]),]                         # only keeping obs that have no NA's in Column 1 and 2

# Counting NA's
myNA <- is.na(pf)                                                    # is.na checks for missing data points and flags them as TRUE/FALSE
sum(myNA)                                                            # summing these logical flags yields the total number of mising points
 
# Sorting data
X[order(X$var1,X$var3),]
aql <- arrange(aql, Ozone)                                           # using the dplyr package for sorting

# adding columns together for each observation using transform
yo <- transform(yo, 
                all.purchases=(strawberry+blueberry+
                       pina.colada+plain+mixed.berry))

#####################################################
# 2. DATA LONG/WIDE FORMATS                            
#####################################################

# Converting dataframe to long format
library('reshape2')
aql <- melt(airquality)                                              # melt essentially converts data to long format but you need to fine tune it

aql <- melt(airquality, 
       id.vars = c("Month", "Day"),                                  # ID variables are the variables that identify individual rows of data.
       variable.name = "Climate_variable",                           # this names the new created variable
       value.name = "Climate_value")                                 # and fills it with the values

# Converting dataframe to wide format
aqlm <- dcast(aql, Month+Day ~ Climate_variable,                     # left of ~: key, right of ~: column to convert to row
              value.var="Climate_value")                             # data that goes into new columns


#####################################################
# 3. DATA TRANSPOSING                           
#####################################################

# Transposing dataframes that have strings in the first column. In these cases a smple transpose will 
#cause the whole dataframe to convert into a character:
gdp <- read.csv('gdp.csv', header = TRUE)

gdp2 <- t(gdp)                                                       # converts the whole dataframe into a character
is.character(gdp2)    
is.data.frame(gdp2)


#Storing the country names in column X from the gdp dataframe 
n <- as.vector(gdp$X)            #country column names are converted to a vector
n <- c('year', n)                #'year' is added to the vector
names <- factor(n, levels=n)     #'year' is added as a level

# transpose all but the first column(X)
gdp2 <- as.data.frame(t(gdp[,-1]))                                   # transposing the dataframe
gdp2$year <- row.names(gdp2)                                         # assigning 'gdp' rownames(first column) as a column name to'year'
gdp2 <- gdp2[c(189, 1:188)]                                          # re-positioning columns in the new data frame
gdp2$year <- (substring(gdp2$year,2,nchar(gdp2$year)))               # removing the "x" in year to convert to numeric format
colnames(gdp2) <- names                                              # assigning column names to new dataset from the 'names' factor
row.names(gdp2) <- NULL                                              # resetting row headers in 'gdp2'


#####################################################
# 3. BINNING, FACTORING $ SAMPLING                         
#####################################################

# Converting a continuous variable to a binary variable
summary(pf$mobile_likes)
mobile_check_in <- NA
pf$mobile_check_in <- ifelse(pf$mobile_likes > 0,1,0)                # if likes>0, assign 1 else assign 0
pf$mobile_check_in <- factor(pf$mobile_check_in)                     # converting to a factor
summary(pf$mobile_check_in)

# Creating class intervals for age buckets
pf$year_joined.bucket <- cut(pf$dob_year,                           # specify column for bucketing
                             breaks= seq(1900,2000,10),              # specify class interval width - can be non-equal
                             labels = NULL,                          # the bins are stored as a factor and levels can be labelled
                             include.lowest = TRUE, right = TRUE,    # specify whether class interval is closed on the right ( ] ) or lefe ( [ )
                             ordered_result = TRUE)

# Sampling a dataframe
pf_sample<- pf[sample(1:length(pf$age), 10000),]                     # to obtain 10,000 random samples
sample.ids <- sample(levels(yo$id),16)                             # creates a sample from our original yogurt dataframe
ggplot(data=(subset(yo, id%in% sample.ids)),  
