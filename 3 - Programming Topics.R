# Conditional statements
 x <- 6
 if(x>3) {
   y <- 10
 } 
 else {                                              # the else sub-statement is not required
   y <- 0
 }          
 y <- if(x<4) {
   y <- 10
 } 
 else {
   y <- 2
 }
---------------------------------------------------------------------------------------------------
# FOR loops
  for (i in 1:10) {
    print(i)
  }

 x <- c("a", "b", "c", "d")
 for(i in 1:4) { 
   print(x[i]) 
 }

 for(i in seq_along(x)) { 
   print(x[i]) 
 }
 for(letter in x) { 
   print(letter) 
 }

# Nesting loops
 x <- matrix(1:6, 2,3)
 for(i in seq_len(nrow(x))) { 
   for(j in seq_len(ncol(x))) {
     print(x[i,j]) 
   }
 } 

# FOR-NEXT:
 for (i in 1:100) {
   if(i<=90) {
     next                                               # the next function skips the first 90 iterations
   } else {
     print("A")
   }
 }  

#WHILE loops
 count <- 0
 while(count<=10) {
   print(count) 
   count <-count+1
 }
---------------------------------------------------------------------------------------------------
# Loop functions in R
  
# lapply always returns a list
 x <- list(a=1:5, b=rnorm(10))
 y <- lapply(x, mean)                                   # lapply applies the function "mean" to all elements in the list x
 a <- 1:4
 lapply(a, runif,min=0, max=10)                         # arguments to functions can be set in this way 

 x <- list(a=matrix(1:4,2,2), b=matrix(5:8,2,2))
 # you can create an empty function to do something,
 # in this case subsetting 
 lapply(x, function(dummy) dummy[,1]) 

# sapply:
#same as lapply except: 
#if result is a list where every element is of length 1, a vector is returned
#if result is a list where every element vector is same length, a matrix is returned
#If R is unclear, a list is returned

 a <- 1:4
 sapply(a, mean)                                         # a vector is returned                        

# apply
# useful in doing row or column calculations; 
# the second argument is used to specify location

 m <- matrix(rnorm(200),20,10)
 apply(m,2,quantile, probs=c(0.25,0.75))                 # 'apply' applies the quantile function to the first dimension of the matrix - i.e rows

 a <- array(1:200, c(2,2,10))                            # creates a 2x2x10 3d array
 apply(a, c(1,2), mean)                                  # 'apply' applies the mean function to the first and third dimensions

# tapply:
 x <- c(rnorm(10), rnorm(10,1))                          # creating a vector of two groups, 10 elements per group
 f <- gl(2,10)                                           # use gl function to create a factor of two levels with ten replications
 tapply(x,f,mean)                                        # tapply applies the mean function to x based on the two levels; output is a vector
---------------------------------------------------------------------------------------------------
# split
# split is useful in splitting datasets
 x <- c(rnorm(10), rnorm(10,1))            
 f <- gl(2,10)      
 split(x,f)                                              # splits the x vector based on the factors determined in the factor f

library(datasets)
 s <- split(airquality, airquality$Month)                # splits the airquality dataset into a list of datasets based on the month column
 sapply(s, function(dummy)                               # calculates means of the Ozone and Wind columns for the tables in the list s
   colMeans(dummy[,c("Ozone", "Wind")],
            na.rm=TRUE))

#splitting on multiple levels
 x <- rnorm(10)
 f1 <- gl(2,5)                                           # a two level factor
 f2 <- gl(5,2)                                           # a five level factor
 str(split(x, list(f1,f2), drop=TRUE))                   # splits x with f1 levels and f2 sub levels; empty levels are dropped 

---------------------------------------------------------------------------------------------------

#Building Functions
   columnmean <- function(y, removeNA = TRUE) {          # "y"  and "removeNA stores arguments for the function columnmean 
     nc <- ncol(y)                                       # counter for number of columns
     means <- numeric(nc)                                # creates a vector means of length equal to number of columns             
     for(i in 1:nc) {
       means[i] <- mean(y[, i], na.rm = removeNA)        # loop calculates means of each column by way of a loop
     }
     means
   }
 columnmean(airquality)
  
  
  