# Use RODBC to load SQL View data into R
# Script courtesy of: http://nexxtjump.com/2013/07/30/data-science-labs-cluster-analysis-with-microsoft-bi-and-r/

install.packages("RODBC")
library(RODBC)

# Build connection string
DRIVER <- "SQL Server Native Client 11.0"
SERVER <- "localhost"
DATABASE <- "AdventureWorksDW2016CTP3"
cs <- sprintf("Driver={%s};server=%s;database=%s;trusted_connection=yes;", DRIVER, SERVER, DATABASE)

# Open channel
cn <- odbcDriverConnect(cs)

# Fetch data
custSalesInc <- sqlFetch(cn, 'vCustomerSalesIncome')

# Inspect data
dim(custSalesInc)
head(custSalesInc)

# Generate density plots for Sales Amount and Yearly Income
# Create a side-by-side plot
par(mfrow = c(1,2))
plot(density(custSalesInc$SalesAmount), main = "Density Sales Amount")
plot(density(custSalesInc$YearlyIncome), main="Density Yearly Income")

# Define clusters based on income split
IncHigh.cluster <- ifelse(custSalesInc$YearlyIncome > 60000, 3, 0)
IncMid.cluster <- ifelse(custSalesInc$YearlyIncome <= 60000 & custSalesInc$YearlyIncome > 30000, 2, 0)
IncLow.cluster <- ifelse(custSalesInc$YearlyIncome <= 30000, 1, 0)

# Create a single data frame with labels
incomeCategoryKey <- IncLow.cluster + IncMid.cluster + IncHigh.cluster
incomeCategoryLabel = factor(incomeCategoryKey, labels = c("Low", "Mid", "High"))
custSalesInc <- cbind(custSalesInc, incomeCategoryKey, incomeCategoryLabel)

# View the data
head(custSalesInc)
View(custSalesInc)
par(mfrow = c(1, 1))
boxplot(custSalesInc$YearlyIncome~custSalesInc$incomeCategoryLabel, main = "Boxplot Income", xlab = "Income in USD", ylab = "Income Cluster", horizontal = TRUE)

# Write back to data warehouse
sqlSave(cn, custSalesInc, rownames = FALSE,
        tablename = "InternetSalesCluster",
        colname = FALSE, append = FALSE)
odbcClose(cn)