# Downloading files from the internet
 fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
 download.file(fileUrl, destfile = "./Datasets/cameras.csv")
 list.files("./Datasets")

# Reading local data into R
cameraData <- read.csv("./Datasets/cameras.csv", sep=",", header = TRUE)
  
# XML files parsing:
library(XML)
# example 1
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)                           # this function parses the xml file; useInternal tells R to parse all the sub-nodes as well           
rootNode <- xmlRoot(doc)                                                # this function assigns the root node name to variable rootNode
xmlName(rootNode)
names(rootNode)
rootNode[[1]]                                                           # will extraxt the first root node and sub-node values
rootNode[[1]][[1]]                                                      # will extract the child node values of the first root node
xmlSApply(rootNode,xmlValue)                                            # will extract all values from the root nodes into a string
xpathSApply(rootNode,"//name",xmlValue)                                 # will extract all values from all nodes called "names"
xpathSApply(rootNode,"//price",xmlValue)
  
# HTML files parsing
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)                          # will parse html files
scores <- xpathSApply(doc,"//li[@class='score']", xmlValue)             # extracts values of those list objects with class "score"
teams <- xpathSApply(doc,"//li[@class='team-name']", xmlValue)
scores
teams
  
# JSON files parsing
data2 <- fromJSON("https://api.github.com/users/hadley/repos")
names(data2) <- data2$name                                              # it's a data frame
names(data2$owner)                                                      # which has a nested data frame
data2$owner$login
  
# SQL databases
library(RMySQL)
localhost <- dbConnect(MySQL(), host="localhost", port= 3306, 
                 user="root",password = "admin", dbname="Sakila")       # create connection to MySQL Sakila database
databases <- dbGetQuery(localhost, "show databases;");                  # shows all databases in MySQL localhost connection
databases
tables <- dbListTables(localhost)                                       # lists all tables in the database Sakila
tables
dbListFields(localhost, "country")                                      # lists all fields from Sakila 
dbGetQuery(localhost, "SELECT * FROM actor")                            # embedding SQL queries in R!
Actors <- dbReadTable(localhost, "actor")                               # same as above - read entire table
Actors
dbDisconnect(localhost)
  
ucscDb <- dbConnect(MySQL(),user="genome",                              # you can fetch data from online databases as well                        
            host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); 
dbDisconnect(ucscDb);                                                   # don't forget to close connections!
result
  
# HDF5 databases
library(rhdf5)
created = h5createFile("example.h5")
created
# creating groups for an HDF5 dataset
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa") 
# filling in data
h5ls("example.h5")
A = matrix(1:10,nrow=5,ncol=2)
h5write(A, "example.h5","foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5","foo/foobaa/B")
h5ls("example.h5")
# reading data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5","df")
readA
# writing and reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")
  
# Webscraping: programatically extracting data from the HTML code of websites
  
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")  
htmlCode = readLines(con)                                                 # extracting html from a webpage using readLines
close(con)                                                                # remember to close conections
htmlCode
  
# using the XML package
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)                            # you can also use XML
xpathSApply(html, "//title", xmlValue) 
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)
  
# using the httr package
library(httr); html2 = GET(url)                                           # get the contents of URL into variable html2                                  
content2 = content(html2,as="text")                                       # fetch content of html2 as text (raw data)
parsedHtml = htmlParse(content2,asText=TRUE)                              # parse html2 into html format
xpathSApply(parsedHtml, "//title", xmlValue)                              # extract text in the title header of the parsedHtml variable
content2
parsedHtml
  
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",                    # httr package can handle website authentication
            authenticate("user","passwd"))                                # Status: 200 means authentication passed
pg2
names(pg2)
  
google = handle("http://google.com")                                      # using handles means httr remember your authentication
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")
  
  
# API's
myapp = oauth_app("twitter",
                  key="yourConsumerKeyHere",secret="yourConsumerSecretHere")
sig = sign_oauth1.0(myapp,
                    token = "yourTokenHere",
                    token_secret = "yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]
  
  