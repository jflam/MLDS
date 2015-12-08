drop view dbo.vCustomerSalesIncome
drop table dbo.InternetSalesCluster

CREATE VIEW [dbo].[vCustomerSalesIncome]
AS
SELECT
    fact.[CustomerKey]
    ,sum([SalesAmount]) as SalesAmount
    ,dimC.YearlyIncome
  FROM [dbo].[FactInternetSales] fact
  INNER JOIN dbo.DimCustomer dimC 
        on fact.CustomerKey = dimC.CustomerKey
  where CurrencyKey = 100 --USD
  group by fact.[CustomerKey], dimC.YearlyIncome

  select * from vCustomerSalesIncome
  select * from InternetSalesCluster