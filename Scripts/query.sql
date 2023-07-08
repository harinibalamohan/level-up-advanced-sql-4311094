SELECT e. firstName,e.lastName,e.employeeId from employee e 
Left  Join  sales s
on
e.employeeId =s.employeeId
where e.title="Sales Person" AND
s.employeeId is NULL;


select  DISTINCT title from employee;


select c.customerId,c.firstName,c.lastName
,s.salesAmount,s.soldDate from customer
 c Full OUTER join  sales s
 on s.customerId=c.customerId
 where s.salesId is NULL OR
 s.customerId is NULL
;

select c.customerId,c.firstName,c.lastName
,s.salesAmount,s.soldDate from customer c
INNER join  sales s
 on s.customerId=c.customerId
 UNION
 select c.customerId,c.firstName,c.lastName
,s.salesAmount,s.soldDate from customer c
LEFT join  sales s
 on s.customerId=c.customerId
 where s.salesId IS NULL
 UNION
 select c.customerId,c.firstName,c.lastName
,s.salesAmount,s.soldDate from sales s
LEFT join  customer c
 on s.customerId=c.customerId
 where c.customerId IS NULL;


select e.employeeId,e.firstName,
e.lastName,count(*) as CarsSold 
from employee e
inner join sales s
on e.employeeId =s.employeeId
group by  e.employeeId,e.firstName,e.lastName
HAVING count(*)>=1
order by count(*) desc
;


 select e.employeeId,e.firstName,
e.lastName,max(s.salesAmount),MIN(s.salesAmount)
from employee e
inner join sales s
on e.employeeId =s.employeeId
where
-- s.soldDate BETWEEN "2023-01-01" and "2023-12-31"
 s.soldDate>= date('now', 'start of year')
group by  e.employeeId,e.firstName,e.lastName
;



select  strftime('%Y',s.soldDate) as saleyear,
round(sum(s.salesAmount),2) as TotalSale
 from sales s
group by saleyear
ORDER by saleyear;

SELECT strftime('%Y %m %d','now');
-- Similar to creating a view in Oracle
WITH cte as (
select  strftime('%Y',s.soldDate) as saleyear,s.salesAmount
from sales s
)
select saleyear,
format("$%.3f",sum(salesAmount)) As AnnualSales
from cte
group by saleyear
ORDER by saleyear;



--strftime('%m',s.soldDate) as mon,
with cte as(
 select e.employeeId,e.firstName,
e.lastName,strftime('%m',s.soldDate) as mon,s.salesAmount
--,sum(salesAmount) TotalSales
from employee e
inner join sales s
on e.employeeId =s.employeeId
where strftime('%Y',s.soldDate)='2021' and e.employeeId=3
order by mon
--group by  e.employeeId,e.firstName,e.lastName,mon
)
select employeeId,firstName,
lastName,
case when mon='01' then (salesAmount)  END AS "JanSales",
case when mon='02' then (salesAmount)  END AS "FebSales",
case when mon='03' then (salesAmount)  end AS "MarSales" ,
case when mon='04' then (salesAmount)  end AS "AprSales" ,
case when mon='05' then (salesAmount)  end AS "MaySales" ,
case when mon='06' then (salesAmount)  end AS "JunSales" ,
case when mon='07' then (salesAmount)  end AS "JulSales" ,
case when mon='08' then (salesAmount)  end AS "AugSales" ,
case when mon='09' then (salesAmount)  end AS "SepSales" ,
case when mon='10' then (salesAmount)  end AS "OctSales" ,
case when mon='11' then (salesAmount)  end AS "NovSales" ,
case when mon='12' then (salesAmount)  end AS "DecSales" 
from cte
group by  employeeId,firstName,lastName


select * from sales where employeeId=3 and strftime('%Y',soldDate)='2021'


 
------------------------------------

select e.firstName,
e.lastName,
case when strftime('%m',s.soldDate)='01' then s.salesAmount  end AS JanSales,
case when strftime('%m',s.soldDate)='02' then s.salesAmount  end AS FebSales,
case when strftime('%m',s.soldDate)='03' then s.salesAmount  end AS MarSales,
case when strftime('%m',s.soldDate)='04' then s.salesAmount  end AS AprSales ,
case when strftime('%m',s.soldDate)='05' then s.salesAmount  end AS MaySales ,
case when strftime('%m',s.soldDate)='06' then s.salesAmount  end AS JunSales ,
case when strftime('%m',s.soldDate)='07' then s.salesAmount  end AS JulSales ,
case when strftime('%m',s.soldDate)='08' then s.salesAmount  end AS AugSales ,
case when strftime('%m',s.soldDate)='09' then s.salesAmount  end AS SepSales ,
case when strftime('%m',s.soldDate)='10' then s.salesAmount  end AS OctSales ,
case when strftime('%m',s.soldDate)='11' then s.salesAmount  end AS NovSales ,
case when strftime('%m',s.soldDate)='12' then s.salesAmount  end AS DecSales 
from sales s
inner join  employee e
on e.employeeId =s.employeeId
where 
--strftime('%Y',s.soldDate)='2021' and e.employeeId=3
s.soldDate >='2021-01-01' and s.soldDate <'2022-01-01'  and e.firstName='Abel'
group by  e.firstName,e.lastName--,strftime('%m',s.soldDate)
order by e.firstName,e.lastName

-------------------------------------------

select * from model where EngineType="Electric";

select * from sales;

select * from sales where inventoryId
 in(select inventoryId from inventory where modelId in (
select modelId from model where EngineType="Electric"));

select 
e.firstName,
e.lastName,m.model,
count(M.model) as CarsSold,
  Rank() OVER(PARTITION BY s.employeeId
       ORDER BY count(m.model) DESC) AS Rank
 from sales s
 inner join  employee e
 on e.employeeId = s.employeeId
inner join inventory i
on
i.inventoryId = s.inventoryId
inner join model m on
i.modelId= m.modelId

 GROUP by e.firstName,e.lastName,m.model
;

SELECT emp.firstName, emp.lastName, mdl.model,
  count(model) AS NumberSold
FROM sales sls
INNER JOIN employee emp
  ON sls.employeeId = emp.employeeId
INNER JOIN inventory inv
  ON inv.inventoryId = sls.inventoryId
INNER JOIN model mdl
  ON mdl.modelId = inv.modelId
GROUP BY emp.firstName, emp.lastName, mdl.model

-- add in the windowing function
SELECT emp.firstName, emp.lastName, mdl.model,
  count(model) AS NumberSold,
  rank() OVER (PARTITION BY sls.employeeId 
              ORDER BY count(model) desc) AS Rank
FROM sales sls
INNER JOIN employee emp
  ON sls.employeeId = emp.employeeId
INNER JOIN inventory inv
  ON inv.inventoryId = sls.inventoryId
INNER JOIN model mdl
  ON mdl.modelId = inv.modelId
GROUP BY emp.firstName, emp.lastName, mdl.model


---------------------------08 JUl-----------
with cte as(
select sum(salesAmount) as MonthWiseSales,
strftime('%m',soldDate) as Month,
strftime('%Y',soldDate) as Year from sales 
group by strftime('%Y',soldDate),strftime('%m',soldDate)
)
select year, Month, monthwisesales,
sum(MonthWiseSales) over( PARTITION by year 
ORDER by year,month desc) as Annual_Running_Sales
from cte
order by year,month

------------------------------------

select count(*) as CarsSold,
strftime('%Y-%m',soldDate) as Month
 from sales 
group by strftime('%Y-%m',soldDate);


select count(*) as CarsSold,
strftime('%Y-%m',soldDate) as Month,
LAG (count(*), 1,0) over calmonth as lastmonthcarsold
 from sales 
group by strftime('%Y-%m',soldDate)
WINDOW calmonth as (order by strftime('%Y-%m',soldDate))
ORDER by strftime('%Y-%m',soldDate)



