SELECT e. firstName,e.lastName,e.employeeId from employee e 
Left  Join  sales s
on
e.employeeId =s.employeeId
where e.title="Sales Person" AND
s.employeeId is NULL;


select  DISTINCT title from employee;