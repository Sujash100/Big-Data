--Load the Customers data from it's location
Customers = LOAD '/BigData/Customers' using PigStorage(',') as (CUSTOMERID,COMPANYNAME,CONTACTNAME,CONTACTTIT,ADDRESS,CITY,REGION,POSTALCODE,COUNTRY,PHONE,FAX);
--Load the Orders dataset from its location
Orders = LOAD '/BigData/Orders' USING PigStorage(',') as (ORDERID,CUSTOMERID,EMPLOYEEID,ORDERDATE,REQUIREDDA,SHIPPEDDAT,SHIPVIA,FREIGHT,SHIPNAME,SHIPADDRES,SHIPCITY,SHIPREGION,SHIPPOSTAL,SHIPCOUNTR);
--Load the Products data from it's location
Products = LOAD '/BigData/Products' using PigStorage(',') as (PRODUCTID,PRODUCTNAME,SUPPLIERID,CATEGORYID:int,QUANTITYPE,UNITPRICE:double,UNITSINSTO,UNITSONORD,REORDERLEV,DISCONTINU);
--Join the above datasets by common column CUSTOMERID
Join_data = JOIN Customers by CUSTOMERID,Orders by CUSTOMERID;
--Generate the needed column from the joined dataset
Final_data = FOREACH Join_data generate $0,$1,$2,$11,$13,$14,$15,$16;
--View the Result
dump Final_data;

group_data = GROUP Products by CATEGORYID;
High_unit_price = FOREACH group_data generate group,MAX(Products.UNITPRICE);
DUMP High_unit_price;
--Filtered the data by the city
--Data_filter = FILTER Products by (CITY matches 'berlin');
--DUMP Data_filter;
group_data = GROUP Products by CATEGORYID;
Average_unit_price = FOREACH group_data generate group,AVG(Products.UNITPRICE);
DUMP Average_unit_price;

--Projecting some attributes
NeededColumns = FOREACH Products GENERATE PRODUCTID,PRODUCTNAME,SUPPLIERID,CATEGORYID,QUANTITYPE;
DUMP NeededColumns


-- To store the data into the location, use the below statement
-- STORE LocalWeather into '/BigData/weatherOut.csv' using PigStorage(',');
-- Ensure that the specified folder 'Output' not exists under /Data
-- View the contents of the loaded file.
-- Dump LocalWeather;
