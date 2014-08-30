==========================================================================
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
==========================================================================
statesInfo <- read.csv("stateData.csv", header=TRUE, sep=",")
reddit <- read.csv("reddit.csv", header = TRUE)
pf <- read.csv('pseudo_facebook.tsv', sep = '\t')
yo <- read.csv('yogurt.csv')
data(diamonds)
diamonds
data(heightweight)
heightweight

#####################################################
# 1. DATA VISUALIZATION                             
#####################################################
# Quick and dirty histograms
hist(log10(diamonds$price))

################################
#qplot
################################
# Histograms 
qplot(x = friend_count,  
      data=subset(pf, !is.na(gender)), 
      binwidth=25,                                                 # binwidth adjusts the histogram width 
      xlab='Friend Count',                                         # x-axis label
      ylab='Count of People',                                      # y-axis label
      fill=gender) +                                               # specify fill for stacked columns by variable
    scale_x_continuous(limits=c(1,1000),                           # limits sets the upper and lower limits of the x axis
                       breaks=seq(0,1000,50)) +                    # breaks sets the units of the x axis with marks every 50 units
    facet_wrap(~dob_month)                                         # create facets of charts by variable

# Histograms with different transformations all in one multi-plot
p1 <- qplot(x=friend_count, 
            data=subset(pf, !is.na(pf$gender)))     
p2 <- qplot(x=friend_count, 
            data=subset(pf, !is.na(pf$gender))) + 
    scale_y_log10()                                                # a log10 transformation                                                                                                     
p3 <- qplot(x=friend_count, 
            data=subset(pf, !is.na(pf$gender))) + 
    scale_x_sqrt()
grid.arrange(p1, p2, p3, ncol=1)

# Line Plots
qplot(x=www_likes, y=..count../sum(..count..),                     # the 'y' assignment makes counts into proportions
      data=subset(pf, !is.na(gender)), 
      ylab = 'Proportion of Total Count',
      binwidth=50, geom='freqpoly', color=gender) +                # use geom to set line chart and color to asign BY variable
    scale_x_continuous(lim=c(0,500), breaks=seq(0,500,50))

# Box Plots
qplot(x=gender, y=friend_count,
      data=subset(pf,!is.na(gender)),
      geom='boxplot',
      xlab='Gender', ylab='Likes')


###############################
# ggplot
###############################
#Bar Charts
ggplot(data=diamonds, aes(x=cut, color=color, fill=color)) + 
    geom_bar(stat='bin')                                           # counts of the x variable, y set to null 

ggplot(data=diamonds, aes(x=cut,y=price)) +
           geom_bar(stat='identity', color='blue') +                # bar heights represent the y variable
    
       
# Line plots
ggplot(data=subset(pf, !is.na(gender)),
       aes(x=age, y=friend_count)) +
    geom_line(aes(color=gender),stat='summary', fun.y=median)      # use the aes wrapper to get color by gender and friend_count by median  
    stat_summary(fun.y=mean, geom='line', shape=4)                 # use stat_summary to overlay the mean of the y variable

# Scatter plots: limiting data by percentiles/quantiles
ggplot(data=pf, aes(x=www_likes_received, y=likes_received)) +
    geom_point (alpha=.3, color='blue') +                          # alpha sets the size of the datapoints relative to the default size
    xlim(0, quantile(pf$www_likes_received, 0.95)) +               # limit scatterplot to 95th percentile points 
    ylim(0, quantile(pf$likes_received, 0.95)) 
    geom_smooth(method = 'lm', color = 'red')                      # linear trendline (default:loess non-linear model)

# Scatter plots: colors, shapes, point sizes
ggplot(data=heightweight, aes(x=ageYear, y=heightIn, 
                              shape=sex, colour=sex)) +
    geom_point(alpha=1) +
    scale_colour_brewer(palette="Set1")  

# Scatter plots: transformations
    # There are two ways of transforming an axis. One is to use a scale transform, 
    # and the other is to use a coordinate transform. With a scale transform, the data 
    # is transformed before properties such as breaks (the tick locations) and range of 
    # the axis are decided. With a coordinate transform, the transformation happens after 
    # the breaks and scale range are decided. This results in different appearances, as shown below.

p1 <- ggplot(aes(x = carat, y = price, 
                color = cut, shape=cut), data = diamonds) + 
    geom_point(alpha = 0.5, size = 1, position = 'jitter') +
    scale_x_continuous(breaks=seq(0.2,3.0, 0.3), 
                       limits=c(0,3.0)) +
    ggtitle('Linear')

p2 <- ggplot(aes(x = carat, y = price, 
                 color = cut, shape=cut), data = diamonds) + 
    geom_point(alpha = 0.5, size = 1, position = 'jitter') +
    scale_x_continuous(breaks=seq(0.2,3.0, 0.3), 
                       limits=c(0,3.0)) + 
    coord_trans(y='log10') +                                        # other functions: log2_trans(), sqrt_trans() 
    ggtitle('Log - coord_trans: does not delete datapoints')

p3 <- ggplot(aes(x = carat, y = price, 
           color = cut, shape=cut), data = diamonds) + 
    geom_point(alpha = 0.5, size = 1, position = 'jitter') +
    scale_x_continuous(breaks=seq(0.2,3.0, 0.3), 
                       limits=c(0,3.0)) + 
    scale_y_continuous(trans=log10_trans())  +                       # other functions: log2_trans(), sqrt_trans() 
    ggtitle('Log - scale_y_continuous: with log tranformation function')

grid.arrange(p1,p2,p3)

# Box Plots
ggplot(data=subset(pf, !is.na(gender)),
       aes(x=gender, y=age)) +
    geom_boxplot() +
    stat_summary(fun.y=mean, geom='point', shape=4)                   # stat_summary adds a marker for the mean value in the boxplot

###############################
# GGally for brute-force EDA
###############################
# !WARNING! the brute-force approach takes a long 
# time to process so use a sample of the dataframe!
set.seed(1836)                                                        # setting seed for reproducible results
pf_subset <- pf[, c(2:15)]                                            # creating a subset to remove unwanted variables
pf_sample <- pf_subset[sample(1:length(pf_subset$age), 50),]          # taking 50 samples from the dataframe                                           
ggpairs(pf_sample)                                                    # plotting every variable in the subset dataframe even 50 obs. takes time!

########################################
# GPairs for pair-wise brute-force EDA
########################################
# ggpairs plots pairs of all variables in the dataset. 
# Qualitative-Qualitative pairs: histograms 
# Quantitative-Quantitative pairs: scatterplots & correlation
# Qualitative-Quantitative pairs: boxplots
library('scales')
library('memisc')
library('lattice')
library('MASS')
library('car')

set.seed(20022012)
diamond_samp <- diamonds[sample(1:length(diamonds$price), 10000), ]
ggpairs(diamond_samp, params = c(shape = I('.'), outlier.shape = I('.')))


table(diamonds$cut)






