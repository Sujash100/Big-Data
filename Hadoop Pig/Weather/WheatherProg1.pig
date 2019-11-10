-- Loading the Weather data from two different files 
LocalWeather = LOAD '/BigData/WeatherData1.csv' using PigStorage(',') as 
(PLACE,TEMPERATURE:double,HUMIDITY,OUTLOOK,WINDY,PLAY);
-- (PLACE:chararray,TEMPERATURE:double,HUMIDITY:double,OUTLOOK:chararray,WINDY:chararray,PLAY:chararray);
LocalWeather1 = LOAD '/BigData/WeatherData2.csv' using PigStorage(',') as 
(PLACE:chararray,TEMPERATURE:double,HUMIDITY:double,OUTLOOK:chararray,WINDY:chararray,PLAY:chararray);
DUMP LocalWeather1;
--(PLACE,TEMPERATURE,HUMIDITY:double,OUTLOOK,WINDY,PLAY);

-- Loading location details of different places 
LocalPlace = LOAD '/BigData/Place.csv' using PigStorage(',') as (PLACE,STATE,LOGITUDE:double,LATIDUDE:double,PINCODE);
DUMP LocalPlace;
--(PLACE:chararray,TEMPERATURE:double,HUMIDITY:double,OUTLOOK:chararray,WINDY:chararray,PLAY:chararray);
DUMP LocalWeather;

-- By filtering you may select a part of the table like WHERE clause in SELECT command
Result1 = FILTER LocalWeather BY WINDY =='TRUE';
DUMP Result1;

-- Splitting the table into a number of tables based on selection criteria
-- Here we are getting two tables one for weather is windy and other is not windy
SPLIT LocalWeather INTO X IF WINDY == 'TRUE', Y IF WINDY == 'FALSE';
DUMP X;
DUMP Y;
--

-- This is the example of projection like SELECT any field in SQL
Result2 = FOREACH LocalWeather generate PLACE, PLAY;
DUMP Result2;
---
-- To get any number of tuples from the output here we are getting first two tuples
Result4 = LIMIT LocalWeather 3;
DUMP Result4;

-- Showing records in a sorted order
-- Here it is in descending order of Humidity
Result5 = ORDER LocalWeather BY HUMIDITY DESC;
DUMP Result5;
-- 

-- This the grouping of data against PLAY column
-- After grouping you may use any aggregate function AVG() etc each such group
Result3 = GROUP LocalWeather BY PLAY;
Result = FOREACH Result3 GENERATE LocalWeather.PLAY, AVG(LocalWeather.TEMPERATURE), MAX(LocalWeather.TEMPERATURE), MIN(LocalWeather.TEMPERATURE), COUNT(LocalWeather.TEMPERATURE);
DUMP Result;
--

-- This is for joining of two tables like natural join 
Result = JOIN LocalWeather BY PLACE, LocalPlace BY PLACE;
DUMP Result;
---- Now you can project any fields or can group on any field, use any aggregate operations like AVG(), MAX, etc

