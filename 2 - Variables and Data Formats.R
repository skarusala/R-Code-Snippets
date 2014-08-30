#####################################################
# 1. BASIC VARIABLES
#####################################################

# Use class to find out they type of variable:
class(c(TRUE, FALSE))

#Classes of variables:
class(sqrt(1:10))                                                  # numeric
class(3 + 1i)                                                      # "i" creates imaginary components of complex numbers
class(1)                                                           # although this is a whole number, it has class numeric
class(1L)                                                          # add a suffix of "L" to make the number an integer
class(0.5:4.5)                                                     # the colon operator returns a value that is numeric...
class(1:5)                                                         # unless all its values are whole numbers
class(c("she", "sea", "shore"))                                    # character  
  
# Factors: R is capable of treating categorical data into classes or levels:
(gender <- factor(c("male", "female", "age", "income")))
levels(gender)                                                     # lists the different levels in variable 'gender'. Note: levels are assigned alphabetically
nlevels(gender)                                                    # lists the count of levels in variable 'gender'
as.integer(gender)                                                 # This is what the factors look like under the bonnet)
as.character(gender)                                               # shows all the factors in character form
  
# Changing Variable types
x <- "126"                                                         # this is a character
y <- as.numeric(x)                                                 # converts "126" to numeric and stores in y
is.numeric(y)
  
# is: a useful fnction to check the type of variable
is.character("red lorry, yellow lorry")
is.logical(FALSE)
is.list(list(a = 1, b = 2))           
ls(pattern = "^is", baseenv())                                     # list of 'is' functions
is.na(x)                                                           # test to see if x is a missing value
is.nan(x)                                                          # test to see if x is "not a number"
identical(x,y)                                                     # check to see if two vectors are identical

# To clear/delete a variable:
rm(x)
rm(x,y,a,axe)           
rm(list=ls())                                                      # this will delete all variables stored
  
# Consolidating character variables
my_char <- c("My", "name", "is")
paste(my_char, collapse = " ")                                     # combines into a single vector with a space between words
 
# Dates in R: 
x <- as.Date("1970-01-01")                                         # converts characters to date 1970 is the reference date in R
x <- Sys.time()           
p <- as.POSIXct(x)                                                 # coerces character into time format
q <- as.POSIXlt(x)                                                 # with the POSIXlt format, you can refer to data parameters as a string
p$year                                                             # this will give an error
q$year
date <- c("January 10, 2012 10:40")  
x <- strptime(date, "%B %d, %Y %H:%M")                             # use strptime to extract dates in non standard formats
x <- as.POSIXlt(x)
x-p                                                                # you can add/subtract dates
  
#####################################################
# 2. VECTORS
#####################################################


# Vectors: can be created by specifying ranges or using the concatenation 'c' function:
8.5:4.5                                                            # sequence of numbers from 8.5 down to 4.5
c(1, 1:3, c(5, 8), 13)                                             # values concatenated into single vector
seq(0,10, BY=0.5)                                                  # create sequence seperated by 0.5
seq(0,10, LEGNTH=30)                                               # create sequence of 30 numbers
 
# Vector Coercion: 
y <- c("a", TRUE)                                                  # With mixed objects, R converts all elements into one type
class(y)                                                           # in this case R converts the logical variable TRUE to a character

# Naming Vectors:
n <- 1:3
names(n) <- c("Col1", "Col2", "Col3")
n

# Use 'vector' function to create vectors:
vector("numeric", 5)                                               # create 5 numeric elements in a vector
numeric(5)
vector("complex", 5)                                               # create 5 complex elements in a vector
complex(5)
vector("logical", 5)                                               # create 5 logical elements in a vector
logical(5)
vector("character", 5)                                             # create 5 character elements in a vector
character(5)
vector("list", 5)                                                  # create 5 list elements in a vector note: list(5) does something different!

# Creating vectors with repeated elements
rep(1:5, 2)                                                        # the '2' tells R to repeat the vector twice
rep(1:5, each=2)                                                   # repeat each element 
rep(1:5, times=1:5)                                                # repeat each element based on the range 1:5
rep(1:5, length.out=8)                                             # repeat elements until total vector length is 8

# Creating sequences:
seq.int(1,10)
seq.int(0.1,.01,-.01)                                              # in this case, the last number -.01 tells R the distance between elements

# Lengths
length(1:5)                                                        # specifies length of the vector
sn <- c("Jason","Bob","Ma") 
length(sn)                                                         # also works for character vectors
nchar(sn)                                                          # Calculates length of individual elements in vector

# Naming elements in vectors:
c(apple = 1, banana = 2, "kiwi fruit" = 3, 4)                      # format is: name = element value
# Naming can also be done after the vector has been created:
x <- 1:4 
names(x) <- c("apple", "bananas", "kiwi fruit", "")
x
names(x)                                                           # once names are assigned they can be invoked like this

# Indexing/Subsetting Vectors:
x <- (1:5) ^ 2
x[c(1, 3, 5)]                                                      # Only the 1st, 3rd, and 5th element will be recalled)
x[-c(2, 4)]                                                        # adding -ive will ignore elements 2 and 4
x[c(TRUE, FALSE, TRUE, FALSE, TRUE)]                               # the third method uses logical operators
which(x>10)                                                        # the 'which' function returns locations where the condition in bracket is true
which.min(x)                                                       # recalls the minimum location
which.max(x)                                                       # recalls the maximum location
x[!is.na(x)]                                                       # recalls all non-NA elements in vector x
x[x<6] <- 0                                                        # any element <6 will be replaced with zero
x[c("apple", "bananas")]                                           # recall element by name if any

# Simulation
set.seed(20)                       
x <- rnorm(100)                                                    # rnorm generates numbers from a normal distribution
e <- rnorm(100, 0, 2)                                              # arguments: rnorm(n, mean, sd)
y <- 0.5 + 2*x + e
plot(x,y)


#####################################################
# 3. ARRAYS AND MATRICES
#####################################################

#Creating a 3-d array:
(three_d_array <- array(1:24,                                      # creates array and data is entered column-wise
                        dim = c(4, 3, 2),                          # elements per dimension - rows, columns and 3rd dimension
                        dimnames = list(
                            c("one", "two", "three", "four"),      # row names
                            c("ein", "zwei", "drei"),              # column names
                            c("uno", "dos"))))                     # 3rd dimension names

# Creating a 2-d matrix: a matrix is a type of dataset

(a_matrix <- matrix(1:12, nrow=4, ncol=3,                                                      
                    dimnames = list(
                        c("one", "two", "three", "four"),          # row names
                        c("ein", "zwei", "drei"))))                # column names

(b_matrix <- matrix(13:24, nrow=4, ncol=3,
                    dimnames = list(
                        c("five", "six", "seven", "eight"),
                        c("vier", "funf", "sechs"))))

# A matrix is simply a vector with a dimension attribute
# Creating the same 2-d matrix structure using arrays:
(two_d_array <- array(                                             # creates a 2-d aray called "two_d_array"
    1:12,                                                          # data to be entered column-wise
    dim = c(4, 3),                                                 # elements per dimension - rows, columns and 3rd dimension
    dimnames = list(
        c("one", "two", "three", "four"),                          # row names
        c("ein", "zwei", "drei"))))                                # column names

identical(two_d_array, a_matrix)                                   # the matrix and array are identical!

# Filling data in a matrix row-wise (column-wise is default):
matrix(1:12, nrow=4, ncol=3, byrow=TRUE,
       dimnames = list(
           c("one", "two", "three", "four"),
           c("ein", "zwei", "drei")))

# Naming fucnctions for rows, columns in arays, matrices and dataframes
rownames(a_matrix) <- c("one", "two", "three", "four")             # this renames rows
colnames(a_matrix) <- c("ein", "zwei", "drei")                     # this renames columns
dimnames(a_matrix)                                                 # to recall names
rownames(three_d_array)                                            # to recall names
colnames(three_d_array)                                            # to recall names
dimnames(three_d_array)                                            # to recall names

# Indexing/Subsetting Arays:
a_matrix[1, c("zwei", "drei")]                                     # elements in 1st row, 2nd and 3rd columns
a_matrix[1,2:3]                                                    # same as above 

# To include all of a dimension, leave the corresponding index blank:
a_matrix[1, ]                                                      # all of the first row
a_matrix[, c("zwei", "drei")]                                      # all of the second and third columns

# Getting back a matrix as opposed to a Vector when 
# indexing a single element/row/column:
a_matrix[2,3]                                                      # this returns a vector
a_matrix[2,3, drop=FALSE]                                          # this will return a matrix
a_matrix[ ,2]                                                      # returns second column as a vector
a_matrix[ ,2, drop=FALSE]                                          # will return the second column as a matrix

# Merging matrices:
a_matrix
b_matrix
cbind(a_matrix, b_matrix)                                          # horizontal merging of matrices
rbind(a_matrix, b_matrix)                                          # vertical merging of matrices

# Math operations on matrices:
a_matrix + b_matrix

# Transposing matrices:
t(a_matrix)

# Inner and outer multiplication of matrices
a_matrix %*% t(a_matrix)                                           # inner multiplication
1:3 %o% 4:6                                                        # outer multiplication
outer(1:3, 4:6)                                                    # same

#####################################################
# 4. LISTS, FACTORS AND DATAFRAMES
#####################################################


# Lists are vectors that have mixed variable type elements:

a_list <- list(c(1,1,2,5,14,42), 
               month.abb,                # useful function to recall abbreviated months
               matrix(c(3,-8,1,-3), nrow=2),
               asin)

# Like vectors, lists can be named later
names(a_list) <- c("catalan", "months", "involuntary", "arcsin")
a_list

# Lists can be nested within lists:
(main_list <- list(
    middle_list = list(
        element_in_middle_list = diag(3),
        inner_list = list(
            element_in_inner_list         = pi ^ 1:4,
            another_element_in_inner_list = "a")),
    element_in_main_list = log10(1:10)))

# Factors are used to represent multi-level categorical data:
factor <- factor(c("yes", "yes", "no", "yes", "no"),
                 levels = c("no", "yes"))                   
factor                                                               # this factor has two levels: 'yes' and 'no', where 'no' is the first level
table(factor)                                                        # converts the factor to a table and gives freq. count of each level
unclass(factor)                                                      # strips the categorical data into simple codes: yes=2 no=1
attr(,"levels")

# Data Frames:
dataframe1 <- data.frame(
    foo = 1:4, 
    bar=c(T,T,F,F))
dataframe1                                                           # this dataframe has two variables: foo and bar

# Indexing/Subsetting Lists:
list1 <- list(foo = 1:12, bar=month.abb, baz="Hello!")
list1[1]                                                             # indexes the first element in the list: foo, as a list
list1[[1]]                                                           # indexes the first element in the list: foo, as a vector  
list1$bar                                                            # searches for an element called "bar" in all stored lists
list1[c(1,3)]                                                        # indexes the specified elements in the list

# Indexing: $ is literal, [[]] is more flexible
x <- list(foo = 1:4, bar = 0.6)
name <- "foo"
x[[name]]                                                            # computes index for "foo"
x$name                                                               # won't work for R literally searches for an element named "names"

# Indexing Nested Lists
x <- list(list(1,2,3), b = c(7:10))
x[[c(1,2)]]                                                          # indexes the second element from the first list
x[[c(2,3)]]                                                          # indexes the third element from the second list

# Indexing Shortcut for lists
x <- list(bergundy = 1:10, bad = "Check")
x$b
x[["a", EXACT = FALSE]]                # either of these codes will index elements in "bergundy" b: first letter of first element

#Indexing/Subsetting columns of a dataframe
Data <- read.table("D:/Dropbox/Documents/Analytics/R/Datasets/hw1_data.csv", 
                   header=TRUE, sep=",")
subset(Data, select=c("Wind", "Month"))                              # subset function by selecting column headers
Data[,c(1,2,5)]                                                      # subsetting: the numbers are the column number
Data[,c("Wind","Month")]                                             # subsetting: based on column headers
Data$Wind                                                            # subsetting a column into a vector
Data[c(1,2,5),]                                                      # subsetting ROWS
Data[(Data$Temp <= 60 & Data$Month <= 8),]                           # subsetting based on conditionals


# Use "complete.cases" to deal with missing values 
Clean_Data <- Data[complete.cases(Data), ]                           # removing all observations with NA
Clean_Data2 <- Data[complete.cases(Data[,1:2]),]                     # only keeping obs that have no NA's in Column 1 and 2

x <- c(1,2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, "f")
good <- complete.cases(x,y)                                          # complete cases does flags NA as False
good
x[good]
y[good]




