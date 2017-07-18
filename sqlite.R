# import ecommerce data from github
ecom <- readr::read_csv('https://raw.githubusercontent.com/rsquaredacademy/datasets/master/web.csv')

# load libraries
#================================================
library(dbplyr)
library(dplyr)
library(DBI)
library(RSQLite)


# connect to database
#================================================
con <- DBI::dbConnect(RSQLite::SQLite(), 
                      dbname = "J:/gist/dbplyr_tutorial/mydatabase.db")

# connection summary
summary(con)

# database information
DBI::dbGetInfo(con)

# copy local data frame to database
DBI::dbWriteTable(con, "ecom", ecom)

# get info about tables in database
#================================================

# list tables in mydatabase.db
dbListTables(con)

# list fields in a table
DBI::dbListFields(con, "ecom")

# query data
#================================================
# read entire table
DBI::dbReadTable(con, 'ecom')

# read a few lines from the table
DBI::dbGetQuery(con, "select * from ecom limit 10")

# read data in batches
query <- DBI::dbSendQuery(con, 'select * from ecom')
result <- DBI::dbFetch(query, n = 30)

# check if the above operations have been completed
DBI::dbHasCompleted(query)
DBI::dbHasCompleted(result)

# query 
#================================================
# query information
DBI::dbGetInfo(query)

# latest query executed
DBI::dbGetStatement(query)

# number of rows fetched from database
DBI::dbGetRowCount(query)

# number of rows affected in the database
DBI::dbGetRowsAffected(query)

# column info of table in query
DBI::dbColumnInfo(query)

# resources
#================================================
# clear all results from previous queries
DBI::dbClearResult(query)


# write table to database
#================================================
# create table in the database     
x <- 1:10
y <- letters[1:10]
trial <- tibble::tibble(x, y)
DBI::dbWriteTable(con, "trial", trial)

# check if table is created in database
DBI::dbListTables(con)
DBI::dbExistsTable(con, "trial")

# query sample data from table
DBI::dbGetQuery(con, "select * from trial limit 5")

# overwrite table in the database
x <- sample(100, 10)
y <- letters[11:20]
trial2 <- tibble::tibble(x, y)
DBI::dbWriteTable(con, "trial", trial2, overwrite = TRUE)

# query sample data from table to see if it has been overwritten
DBI::dbGetQuery(con, "select * from trial limit 5")

# append data to the table in the database
x <- sample(100, 10)
y <- letters[5:14]
trial3 <- tibble::tibble(x, y)
DBI::dbWriteTable(con, "trial", trial3, append = TRUE)

# query sample data from table to see if new data is appended
DBI::dbReadTable(con, "trial")

# insert rows into trial table
# dbExecute returns the number of rows affected after the operation
DBI::dbExecute(con,
  "INSERT into trial (x, y) VALUES (32, 'c'), (45, 'k'), (61, 'h')"
)

# use dbSendStatement
DBI::dbSendStatement(con,
  "INSERT into trial (x, y) VALUES (25, 'm'), (54, 'l'), (16, 'y')"
)

# data types
#================================================
# SQLite data type
DBI::dbDataType(RSQLite::SQLite(), "a")
DBI::dbDataType(RSQLite::SQLite(), 1:5)
DBI::dbDataType(RSQLite::SQLite(), 1.5)


# remove table from database
#================================================
DBI::dbRemoveTable(con, "trial")

# check if table has been removed 
DBI::dbListTables(con)

# close connection to database
#================================================
DBI::dbDisconnect(con)


# sql queries
#================================================
# create table
DBI::sqlCreateTable(con, "new", c(x = "integer", y = "text"))

# append table
DBI::sqlAppendTable(con, "ecom", head(ecom))
