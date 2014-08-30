###########################################################################
library(ggplot2)      # the plotting package 
library(ggthemes)     # themes for colors, styles etc.
library(gridExtra)    # for faceting many different visualizations
library(scales)       # # used for scale layer functions in ggplot
library(reshape2)     # For melt() to reshape data (long/wide etc.)
library(dplyr)        # to aggregate datasets   
library(GGally)       # brute force EDA
library(memisc)
library(lattice)
library(MASS)
library(gcookbook)    # for codesnippets from the 'R Cookbook' books
setwd('D:/Google Drive/Documents/Analytics/R/Datasets')
###########################################################################
statesInfo <- read.csv("stateData.csv", header=TRUE, sep=",")
reddit <- read.csv("reddit.csv", header = TRUE)
pf <- read.csv('pseudo_facebook.tsv', sep = '\t')
yo <- read.csv('yogurt.csv')
data(diamonds)
diamonds
data(heightweight)
heightweight

#####################################################
# 1. DESCRIPTIVE STATISTICS                          
#####################################################

table(pf$gender)                                                    # generates counts for categorical variables
by(pf$friend_count, pf$gender, summary)                             # summary statistics for friend_count variable BY gender, can also usemin, max,median etc.
by(pf$www_likes, pf$gender, sum)                                    # counts for likes variable BY gender
summary(pf$friend_count, digits=10)                                 # the digits option prevents unwanted rounding of numbers
with(subset(pf, tenure>=1), summary(friend_count/tenure))           # using 'with' to do conditional summaries

# Descriptive Statistics by variable
library(dplyr)
pfg <- group_by(pf, age)
summarise(pfg, 
          n = n(),
          mean = mean(friend_count),
          median = median(friend_count),
          sd= sd(friend_count))

# Aggregating data
pf <- group_by(pf, gender)
summarise(pf,
          mean_friend_count = mean(friend_count))

# R equvalent of PROC FREQ using gmodels
library(gmodels)
CrossTable(diamonds$price, diamonds$color, prop.r=T, prop.c=T, prop.t=T)


CrossTable(log282$Call.Data.Attribute)

#####################################################
# 2. STATISTICAL TESTS                       
#####################################################
# Let's begin by importing the HSB dataset into R. This is the ame dataset that we used in the SAS: Statistical analysis section. 
hsb <- read.csv('HSB.csv') 

# It's always a good idea to convert categorical variables to factors in R, incase we decide to build models later.

hsb$race <- as.factor(hsb$race)
hsb$schtyp <- as.factor(hsb$schtyp)
hsb$prog <- as.factor(hsb$prog)


# In order to make generalized observations about the entire population 
# based on this sample, we first need to make sure those observations are statistically significant. 
# In general we will use a 95% confidence interval and our p-values need to be <= .05 to accept the null or primary hypothesis.

#####################
# ONE-SAMPLE T-TEST
#####################

# To test whether the 'Write' scores differ significantly from 50;
# Our hypothesis: the write scores do not differ from 50 (mu or population mean) in a statistically significant way.

t.test(hsb$write, mu = 50)

#Since our p-value< 1 we reject our hypothesis and conclude  that mean write scores do differ 
# significantly from 50. We accept the value of 52.775.

#################################################
# TWO-SAMPLE T-TEST (FOR INDEPENDENT VARIABLES)
#################################################

#We wish to test whether our hypothesis, that write mean is the same for males and females is statistically significant.

t.test(hsb$write ~ hsb$female)

# The results indicate that there is a statistically significant difference between the mean writing score for males and females (t = -3.73, p = .0003). In other words, females have a statistically significantly higher mean score on writing (54.09) than males (51.45).

###################################################
# TWO-SAMPLE T-TEST (PAIRED/DEPENDENT VARIABLES)
###################################################

# Since write/read values are for the same student they are dependent.
# Our hypothesis: There is no differences in means for write/read.

t.test(hsb$write, hsb$read, paired = TRUE)

# Since our p-value=0.38 we accept our null hypothesis, that there is no statistically 
# significant difference between read and write scores.

##################################################
ONE-SAMPLE BINOMIAL TEST (TEST OF PROPORTIONS)
##################################################

# To see whether the proportion of females differs significantly from 50%
# Our hypothesis: female proportion is 50%
# The alternate hypothesis: female proportion is not 50%

prop.test(sum(hsb$female), length(hsb$female), p = 0.5)   #p = 0.5 for 50% proportion

# We find that our two-tailed p-value is 0.545 (much higher than a .05 cutoff for 95% confidence intervals) 
# and we accept that the female proportion is 50%.

#########################
# CHI-SQUARE TESTS
#########################

# Chi-Square tests can be used to test statistical significance in two or 
# more variables. In the case of T-tests, you are limited to two variables. Furthermore, it can also be used to test associations between categorical as well as character variables.

##############################
CHI-SQUARE GOODNESS OF FIT
##############################

# Test our hypothesis that the sample dataset contains races in expected proportions of 10% Hispanic,
# 10% Asian, 10% African American and 70% Caucasian

chisq.test(table(hsb$race), p = c(10, 10, 10, 70)/100)  #nice thing is that math operations are also vectorized

# Since our p-value = 0.1697 we accept our hypothesis  that the observations are in the expected proportions

###################################
CHI-SQUARE: TEST OF ASSOCIATION
###################################

# To test whether there is a relationship between type of school attended and gender
# Note: The null hypothesis in a Chi-Sqr test is always stating independence and we use the two-sided p-value.

chisq.test(table(hsb$female, hsb$schtyp))

# Since our p-value=0.9815, we accept the null hypothesis that they are independent at the 95% confidence level.

################################
# CORRELATION
################################

# Let's say we want to know whether math and science scores are correlated.

cor.test(hsb$math,hsb$science, 
         method = "pearson")        #other options: "kendall", "spearman" 

# It seems that Math and Science scores have a moderately strong positive 
# of 0.6. Also, this is statistically significant with a p-value that is minute.

####################
# TWO-WAY ANOVA
####################

# ANOVA can be used to assess the effects on one variable by a combination of other variables.

# For example, for a retail store dataset,sIs there an impact on Brand A from aisle and shelf placement of Brand A's  product?

# To do TWO-WAY Anova, first figure out the response variable and the influencer variables. Let's simulate some data for Sales, Aisle and Shelf placement of product Brand A.
# Influencer Variables: Shelf, Aisle
# Response Variable: Sales

# We wish to study the effects of aisle and shelf placements on sales (our response variable). In order to do this we will conduct a 2-way anova to assess the effects of shelf and aisle on sales. In
# addition we will assess whether there is any interaction between shelf and aisle.

# H0: The population means of the sales are same across the three shelves (does not affect Sales)
# H0: The population means of the sales are same across the three aisles (does not affect Sales)
# H0: There are no dependencies between aisles and shelves (does not affect Sales)

# We accept H0 if the p-value is >.05
                                              
# Let's first Simulate the Sales Data:

Sales_Data <- data.frame(
    Sales = c(10.7,10.9,11.3,11.2,11.6,10.9,10.8,11.1,10.7,11.9,12.2,11.7,12.2,12.3,12.5,10.9,11.6,11.9), 
    Aisle = c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3),
    Shelf = c(1,1,1,2,2,2,1,1,1,2,2,2,1,1,1,2,2,2))
Sales_Data

# In R, we do a two-way ANOVA using the lm function (which is also used for linear regression)
# The Sales_Data$Aisle*Sales_Data$Shelf expression is to evaluate the efects of the interaction of Shelf and Aisle

results <- lm(Sales_Data$Sales ~ Sales_Data$Aisle + Sales_Data$Shelf + Sales_Data$Aisle*Sales_Data$Shelf)
anova(results)

# Looking at the p-values:

# Aisle: .01       (reject Ho)
# Shelf: 0.497     (accept Ho)
# Aisle*Shelf: .06 (reject Ho)

# It seems that combined, aisle and shelf does have an impact on Sales. However, Shelf placement 
# by itself does not seem to impact sales but Aisle placement does.










