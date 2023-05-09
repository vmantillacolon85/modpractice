-----Self Join 

SELECT e.FirstName, e.LastName, e.Title, b.FirstName, b.LastName, b.Title 
from Employee e 
join Employee b
on e.ReportsTo =  b.EmployeeId 

--OR 
SELECT e.FirstName, e.LastName, e.Title, b.LastName as Supervisor 
from Employee e 
join Employee b
on e.ReportsTo =  b.EmployeeId 


---Union 
SELECT LastName, FirstName, "customer" AS Type FROM customer 
UNION
SELECT lastname, firstname, "employee" FROM employee




