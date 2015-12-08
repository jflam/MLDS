# Install the R ODBC driver
install.packages("RODBC")

# Use the R ODBC driver
library(RODBC)

# Build connection string
DRIVER <- "SQL Server Native Client 11.0"
SERVER <- "localhost"
DATABASE <- "AdventureWorks2016CTP3"
cs <- sprintf("Driver={%s};server=%s;database=%s;trusted_connection=yes;", DRIVER, SERVER, DATABASE)
cn <- odbcDriverConnect(connection = cs)

# Retrieve all rows from Person table
people <- sqlQuery(cn, "select * from Person.Person")

# Show the data
head(people)
View(people)