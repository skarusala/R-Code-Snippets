################################################
# INSTALL COMMON PACKAGES
################################################

install.packages('car')
install.packages("caret")
install.packages('ggplot2')
install.packages('ggthemes')
install.packages('gridExtra')
install.packages('gmodels')
install.packages('dplyr')
install.packages('e1071')
install.packages('GGally')
install.packages('MASS')
install.packages('memisc')
install.packages('lattice')
install.packages('leaps')
install.packages("lubridate")
install.packages('pROC')
install.packages('randomForest')
install.packages('rjson')
install.packages("shiny")
install.packages('tree')
install.packages('XML')
inxtall.packages('rJava')  # needed for xlsx
install.packages('xlsx')


# Code companion for books:
install.packages("AppliedPredictiveModelling")
install.packages("gcookbook")   # R Cookbook
install.packages('ISLR')        # Introduction to Statistical Learning



#############################################
# LOAD LIBRARIES
#############################################

library(car)          # for certain regression diagnostic tools - outlier and multicollinearity tests
library(caret)        # predictive modelling tools
library(e1071)        # needed by 'caret' for certain functions
library(foreign )     # for importing SAS and other datasets
library(gcookbook)    # for codesnippets from the 'R Cookbook' books
library(GGally)       # brute force EDA
library(ggplot2)      # the plotting package 
library(ggthemes)     # themes for colors, styles etc.
library(grid)         # the Grid graphics package
library(gridExtra)    # for faceting many different 
library(gmodels)      # crosstables and other tools
library(htmltools)    # required for knitr
library(knitr)        # HTML/PDF/WORD publishing
library(labeling)     # for axis labeling
library(lattice)      # for lattice graphs
library(leaps)        # for variable selection and other predictive modelling tools
library(lubridate)    # for manipulating date variables
library(MASS)         # tool for checking regression model residuals
library(memisc)       # tools for managing data and graphs
library(markdown)     # for R Markdown and required by knitr
library(plyr)         # required dependencies
library(dplyr)        # to aggregate datasets (load after loading plyr)  
library(pROC)         # for generating ROCs
library(reshape2)     # For melt() to reshape data (long/wide etc.)
library(rjson)        # for handling JSON files
library(rmarkdown)    # for R Markdown
library(RColorBrewer) # for colorful charts
library(randomForest) # Random Forest algorithm
library(scales)       # used for scale layer functions in ggplot
library(shiny)        # Shiny!
library(tree)         # for classification and regression trees
library(XML)          # for handling XML files
library(yaml)         # required for knitr
library(gmodels)      # for generating crosstables like PROC FREQ in SAS
library(xlsx) # to export to excel

