#####################################################################################################
## Connect to a MySQL database and get query results
#####################################################################################################

###################################################
# 0 - Install & Load libraries
###################################################
# Libraries to connect to mysql
library(DBI)
library(RMySQL)
library(dplyr)
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
  password = "tms")


###################################################
# 2 - Sample query to get & explore data
###################################################
# Get orderdetails table
orders <- "SELECT * FROM orderdetails AS od
           JOIN orders AS o ON od.orderNumber = o.orderNumber;"
query1 <- dbSendQuery(conn, orders)
result_orders <- dbFetch(query1) # Fetch queried data
df_orders <<- data.frame(result_orders) # Print the result as a dataframe

# How many orders?
n_orders <- length(unique(df_orders$orderNumber))

# How many orders by status?
order_by_status <- df_orders %>% count(status)

# total quantity ordered by date
ts_quantity <- aggregate(df_orders$quantityOrdered, by=list(orderdate=df_orders$orderDate), FUN=sum)

# total price of orders by date
ts_price <- aggregate(df_orders$priceEach, by=list(orderdate=df_orders$orderDate), FUN=sum)
ts_price
# Disconnect database connection
dbDisconnect(conn)
