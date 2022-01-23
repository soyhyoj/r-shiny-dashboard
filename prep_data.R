#####################################################################################################
## Connect to a MySQL database and get query results
#####################################################################################################

###################################################
# 0 - Install & Load libraries
###################################################
# Libraries to connect to mysql
library(DBI)
library(RMySQL)
library(ggplot2)

###################################################
# 1 - Data & Source
###################################################
# A sample MySQL database was downloaded from: https://www.mysqltutorial.org/mysql-sample-database.aspx

# Connect to mysql server inside a docker container within local machine
conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "db_shinyapp",
  host = "127.0.0.1",
  port=3305,
  username = "root",
  password = "pwd")


###################################################
# 2 - Sample query to get data
###################################################
# Get employees table
employees <- "SELECT * FROM employees;"
rs <- dbSendQuery(conn, employees)
result_employees <- dbFetch(rs) # Fetch queried data
df_employees <- data.frame(result_employees) # Print the result as a dataframe

# How many employees?
n_employees <- length(unique(df_employees$employeeNumber))

# How many job titles?
n_titles <- length(unique(df_employees$jobTitle))


# Disconnect database connection
dbDisconnect(conn)