# SIMPLE LINEAR REGRESSION

# The basic syntax structure for linear regression in R is pretty easy to follow. It makes use of the lm function. One of the nice things about R is that you can code categorical data into factors. In SAS on the other hand, you would have to create dummy variables for incorporation into the model. Let's use the database that comes with the ggplot2 package called 'diamonds'
# Let's say we want to create a diamond pricing model


library(ggplot2)
head(diamonds)

linmodel <- lm(price ~ cut + color + clarity + (x*y*z),
            data = diamonds)
summary(linmodel)  # to show the results
diamonds$predictedPrice <- fitted(linmodel) # to add predicted values to the dataset
diamonds$residuals <- residuals(linmodel,type="working") # to add residuals to the dataset
coef(linmodel) # extracts the linear model betas

We can create some diagnostic plots fairly easily 

layout(matrix(c(1,2,3,4),2,2)) # to facet all graphs on one page
plot(linmodel)

# For checking outliers and residuals; we will need the these packages:
# car, MASS, stats


# Using the car package
library(car)
outlierTest(linmodel)                 # Bonferonni p-value for most extreme obs
leveragePlots(linmodel)               # leverage plots


# For checking the residuals:

# distribution of studentized residuals using the MASS package
library(MASS)
sresid <- studres(linmodel) 
hist(sresid, freq=FALSE,xlim = c(-4,4), ylim = c(0,0.45), 
     main="Distribution of Studentized Residuals")

xfit<-seq(min(sresid),max(sresid),length=40) 
yfit<-dnorm(xfit) 
lines(xfit, yfit)


# To check for multicolinearity with the CAR package:

library(car)     # for outlier and multicollinearity tests
vif(linmodel)    # variance inflation factor



# LOGISTIC (BINOMIAL) REGRESSION

# In R, we can do a logistic regression with the same glm package by specifying the family = binomial option. For this example, lets use the sample data that comes with the MASS package. 

library(MASS)
data(menarche)
menarche


# The dataset is called 'menarche' containing the following data:
# Age: average age of groups of girls.
# Total: The total number rof girls in each group.
# Menarche: the number of girls in the group who have been to menarche.

head(menarche)

# This dataset lends itself nicely for a logistic regression (if we choose Menarche/Total as the dependent variable. Notice how we have a nice S/logit curve:

library(ggplot2)
qplot(data=menarche, x=menarche$Age, y=Menarche/Total)

logmodel <- glm(Menarche/Total ~ Age,
                data = menarche, 
                family=binomial())
summary(logmodel)                    # to show the results
confint(logmodel)                    # 95% CI for the coefficients
menarche$predicted <- fitted(logmodel, type="response")   # predicted values
menarche$residual <- residuals(logmodel, type="deviance")  # residuals

# And finally the model:

ggplot(data=menarche, aes(x=Age, y= Menarche/Total))+                
    geom_point(color = 'blue', shape=1,size=3) +
    geom_line(aes(x = Age, y = predicted, color='red'))+
    theme(legend.position = 'none')    

ggplot(data=diamonds, aes(x=table,y=price))+                
    geom_point(color = 'blue') +
    geom_line(aes(y = diamonds$predictedPrice, color='red'))
     

