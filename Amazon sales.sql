create database Amazon;

use Amazon; 

select * from amazon;

update amazon
set ManufacturingCost = round(ManufacturingCost,2);

-- ALL SALES AND PROFITS ARE IN (NET SALES AND PROFITS).

-- SALES and REVENUE insights --

-- Total Sales per year.
select year(orderdate) as Year , sum((UnitPrice * Quantity * (1 - Discount))) as TotalSales from amazon
group by year(orderdate);

-- Total Sales by each Country.
select country , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales from amazon
group by country 
order by TotalSales desc;

-- Total Sales per year in each country.
select country , year(orderdate) , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales from amazon
group by year(orderdate),country
order by country,year(orderdate);

-- Top / Total Sales by Category.
select category , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales from amazon
group by category 
order by TotalSales desc;

-- Top Brands / Total Sales by Brand.
select Brand , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales from amazon
group by Brand 
order by TotalSales desc;

-- Top Brands and their category by their total sales in each country.
select * from (select country , brand , category , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales ,
dense_rank() over(partition by country order by sum((UnitPrice * Quantity * (1 - Discount))) desc) as rnk
from amazon
group by country , brand , category) sub 
where rnk = 1
order by TotalSales desc;


-- PRODUCT and CATEGORY performance Analysis --

-- Top Brands and their products in each category.
select category , brand , productname ,round(sum(quantity),2) as TotalQuantity_Sold ,
dense_rank() over( partition by category order by sum(Quantity) desc) as rnk 
from amazon
group by category,brand,productname;

-- TOP 3 Total Products Qunatity sold per year by each country.
select * from 
(select country,productname , year(orderdate) as year, sum(quantity), 
dense_rank() over (partition by country , year(OrderDate) order by sum(Quantity) desc) as rnk
from amazon
group by year(orderdate),country,productname)t
 where rnk<=3 ;

-- Top Products Sold.
select ProductName , round(sum(quantity),2) as TotalQuantity_Sold from amazon
group by ProductName 
order by TotalSales_Sold desc;

-- Total Quantity sold in each category.
select Category , sum(quantity) as TotalCount from amazon
group by Category
order by TotalCount desc;

-- Top 3 Brands and their products sold in each category .
with TopBrands as
(select category , brand , productname , round(sum(Quantity),2) as TotalQuantity_Sold ,
dense_rank() over( partition by category order by sum(Quantity) desc) as rnk 
from amazon
group by category,brand,productname)

select * from topbrands
where rnk <=3;

select * from amazon;

-- TOP 3 Least Sold Products 
select productname , sum(quantity) as TotalQuantity_Sold from amazon
group by ProductName
order by TotalQuantity_Sold asc limit 3;

-- Least sold product in each country.
select * from (select country , ProductName , sum(quantity) as TotalQuantity_Sold , 
dense_rank() over (partition by country order by sum(quantity) asc) as Rnk 
from amazon
group by country , ProductName) sub
where rnk = 1;

-- Total Quantity sold by each product.
select productname , count(*) as TotalCount from amazon
group by productname
order by TotalCount desc;

-- Geographic and Customer insights --

-- TOP 10 Customers by Total Spendings.
select CustomerID , CustomerName , sum(Totalamount) as TotalAmount from amazon
group by CustomerID , CustomerName
order by TotalAmount DESC limit 10;

--  Total Sales contribution Percentage by each country
select country , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales ,
round((( sum((UnitPrice * Quantity * (1 - Discount))) /
(select sum((UnitPrice * Quantity * (1 - Discount))) from amazon))*100),2) as TotalSales_Percentage
from amazon
group by Country
order by TotalSales_Percentage desc;

-- Top 3 Cities in each country by Total Sales.
select * from(select country , city , round(sum((UnitPrice * Quantity * (1 - Discount))),2) as TotalSales ,
dense_rank() over( partition by country order by sum((UnitPrice * Quantity * (1 - Discount))) desc) as Rnk 
from amazon
group by country,City) sub
where rnk <=3;

-- OPERATIONS and LOGISTICS Insights.

select * from amazon;

-- Most used Payment method.
select PaymentMethod , count(*) as TotalCount from amazon
group by PaymentMethod
order by TotalCount desc;
 
-- OrderStatus by Percentage;
select orderstatus , count(orderstatus) as TotalCount,
round((count(OrderStatus)/ (select count(*) from amazon)*100),2) as Orderstatus_Percentage from amazon
group by OrderStatus
order by Orderstatus_Percentage desc;


-- PROFITS Analysis --

-- Total Profit
select round(SUM((UnitPrice * Quantity * (1 - Discount)) - (ManufacturingCost * Quantity)),2)
 as TotalProfit from amazon;

-- Total Profit by each Country.
select country , round(SUM((UnitPrice * Quantity * (1 - Discount)) - (ManufacturingCost * Quantity)),2) 
as TotalProfit from amazon
group by country 
order by TotalProfit desc;

-- Total Profit by each Category.
select Category ,  round(SUM((UnitPrice * Quantity * (1 - Discount)) - (ManufacturingCost * Quantity)),2) as TotalProfit 
from amazon
group by Category 
order by TotalProfit desc;

-- Total Profit per Year
select year(orderdate) as Year ,round(SUM((UnitPrice * Quantity * (1 - Discount)) - (ManufacturingCost * Quantity)),2)
as TotalProfit from amazon
group by year(orderdate)
order by year;

-- TOP 5 Most Profitable Products.
select  ProductName , 
round(SUM((UnitPrice * Quantity * (1 - Discount)) - (ManufacturingCost * Quantity)),2) as TotalProfit
from amazon
group by ProductName 
order by TotalProfit desc
limit 5 ;

-- Profit Margin
Select (sum(UnitPrice * Quantity * (1 - Discount)) - sum(ManufacturingCost*quantity)) /
sum(UnitPrice * Quantity * (1 - Discount))*100 as TotalProfit_Margin_Percentage
from amazon;