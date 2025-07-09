-- select * from zomata_project;

-- 1Q Calender Table 
SELECT 
  DISTINCT replace(datekey_opening,"_","-") as Dates,
  YEAR(Datekey_Opening) AS Year,
  MONTH(Datekey_Opening) AS Monthno,
  DATE_FORMAT(Datekey_Opening, '%M') AS Monthfullname,
  CONCAT(YEAR(Datekey_Opening), '-', DATE_FORMAT(Datekey_Opening, '%b')) AS YearMonth,
  concat("Q",quarter(Datekey_Opening)) AS Quarter,
  DAYOFWEEK(Datekey_Opening) AS Weekdayno,
  DATE_FORMAT(Datekey_Opening, '%W') AS Weekdayname,
  concat("FM",
  CASE 
    WHEN MONTH(Datekey_Opening) >= 4 THEN MONTH(Datekey_Opening) - 3
    ELSE MONTH(Datekey_Opening) + 9
  END )AS FinancialMonth,
  CASE 
    WHEN MONTH(Datekey_Opening) BETWEEN 4 AND 6 THEN 'FQ1'
    WHEN MONTH(Datekey_Opening) BETWEEN 7 AND 9 THEN 'FQ2'
    WHEN MONTH(Datekey_Opening) BETWEEN 10 AND 12 THEN 'FQ3'
    ELSE 'FQ4'
  END AS FinancialQuarter
FROM zomata_project
order by dates asc;

-- 2Q Country wise restaurants
SELECT Country, City, COUNT(*) AS Num_Restaurants
FROM zomata_project
GROUP BY Country, City
ORDER BY Num_Restaurants DESC;

-- 3Q (A) Number of restaurants opened based on Years
select 
year(datekey_opening) as _Year,
count(*) as No_Of_Rest_Opened
from zomata_project
group by _Year 
order by _year asc;

-- 3Q (B) Number of restaurants opened based on Months
select 
year(datekey_opening) as _Year,
monthname(datekey_opening) as _Month,
count(*) as No_Of_Rest_Opened
from zomata_project
group by _year,_month
order by _year,No_Of_Rest_Opened desc;

-- 3Q (C) Number of restaurants opened based on Quarters
select
year(datekey_opening) as _Year,
concat('Q',quarter(datekey_opening)) as _Quater,
count(*) as No_Of_Rest_Opened
from zomata_project
group by _year,_Quater
order by _year,No_Of_Rest_Opened desc;

-- 4Q Percentage of Has Table Booking 
select 
has_table_booking,
concat(round(count(*)*100 / (select count(*) from zomata_project),2)," %") as Percentage
from zomata_project
group by has_table_booking
order by percentage desc;

-- 5Q Percentage of Has Online Delivery
select
has_online_delivery,
concat(round(count(*)*100 / (select count(*) from zomata_project),2)," %") as Percentage
from zomata_project
group by has_online_delivery
order by percentage desc; 

select distinct currency from zomata_project;

-- 6Q Buckets Based on Average Price
with Currency_table as
(select 
case 
when currency like 'Indian%' then Average_Cost_for_two*0.0116
when currency like 'Dollar%' then Average_Cost_for_two*1
when currency like 'Pounds%' then Average_Cost_for_two*1.28
when currency like 'NewZea%' then Average_Cost_for_two*0.6016
when currency like "Emirati%" then Average_Cost_for_two*0.2725
end as Average_Cost_for_Two_In_USD
from zomata_project)
select case
when Average_Cost_for_Two_In_USD between 0 and 3 then "$0 - $3"
when Average_Cost_for_Two_In_USD between 4 and 6 then "$4 - $6"
when Average_Cost_for_Two_In_USD between 7 and 9 then "$7 - $9"
else "More than $9"
end as Price_Range,
count(*) as Price_Range_Count
from Currency_table
group by price_range
order by count(*) desc;
