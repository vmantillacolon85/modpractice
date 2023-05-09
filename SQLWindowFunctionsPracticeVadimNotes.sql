-- Create table called "window"

-- Mock Data: Sneaker Store. Performance of employees hired in December 2019 for holiday season. 

CREATE TABLE sneaker_sales (
    employee_id bigserial,
	employee_hire_date DATE,
    employee_name varchar(30) NOT NULL,
    department varchar(30) NOT NULL,
    revenue integer NOT NULL,
    units_sold integer NOT NULL
);

INSERT INTO sneaker_sales (employee_hire_date, employee_name, department, revenue, units_sold)
VALUES
    ('2019-12-01', 'Liam', 'kids', 2000, 100),
    ('2019-12-20','Emma', 'women', 2880, 96),
    ('2019-12-04','Noah', 'men', 14480, 362),
    ('2019-12-11','Olivia', 'kids', 3000, 150),
    ('2019-12-08','William', 'women', 3210, 107),
    ('2019-12-11','Ava', 'men', 6760, 169),
    ('2019-12-16','James', 'kids', 2000, 100),
    ('2019-12-09','Oliver', 'women', 1530, 51),
    ('2019-12-14','Sophia', 'men', 9960, 249),
	('2019-12-12','Isabella', 'kids', 1000, 50);
	
SELECT *
FROM sneaker_sales

UPDATE sneaker_sales
SET employee_id = 1
WHERE employee_name = 'Liam'

UPDATE sneaker_sales
SET employee_id = 2
WHERE employee_name = 'Emma'

UPDATE sneaker_sales
SET employee_id = 3
WHERE employee_name = 'Noah'

UPDATE sneaker_sales
SET employee_id = 4
WHERE employee_name = 'Olivia'

UPDATE sneaker_sales
SET employee_id = 5
WHERE employee_name = 'William'

UPDATE sneaker_sales
SET employee_id = 6
WHERE employee_name = 'Ava'

UPDATE sneaker_sales
SET employee_id = 7
WHERE employee_name = 'James'

UPDATE sneaker_sales
SET employee_id = 8
WHERE employee_name = 'Oliver'

UPDATE sneaker_sales
SET employee_id = 9
WHERE employee_name = 'Sophia'

UPDATE sneaker_sales
SET employee_id = 10
WHERE employee_name = 'Isabella'

--------------------- RANK() --------------------

-- For each employee, add a column with the employees' rank based on revenue.

SELECT employee_name, department, revenue,
RANK() OVER(ORDER BY revenue DESC)
FROM sneaker_sales

SELECT employee_name, department, revenue,
RANK() OVER(PARTITION BY department ORDER BY revenue DESC) rank_of_salesperson_in_dept
FROM sneaker_sales
-- ORDER BY 4

SELECT employee_name, department, revenue,
RANK() OVER(PARTITION BY department ORDER BY revenue DESC) AS rank_of_salesperson_in_kids_dept
FROM sneaker_sales
WHERE department = 'kids'

--------------------- DENSE_RANK() WITH PARTITION --------------------

SELECT employee_name, department, revenue,
DENSE_RANK() OVER(PARTITION BY department ORDER BY revenue DESC) AS rank_of_salesperson_in_kids_dept
FROM sneaker_sales
WHERE department = 'kids'


--------------------- ROW_NUMBER --------------------
WITH cte AS 
(
SELECT employee_name, department, revenue,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY revenue DESC) AS staff_number
FROM sneaker_sales
)
SELECT *, department||' '||staff_number AS temp_id
FROM cte

--------------------- CUME_DIST --------------------
-- Rank kind of precentile not really

SELECT employee_name, department, revenue,
CUME_DIST() OVER(PARTITION BY department ORDER BY revenue DESC) AS CUME_DIST_of_salesperson_in_kids_dept
FROM sneaker_sales
WHERE department = 'kids'

---------------- LAG -----------------
-- Comparing side by side
WITH cte AS
(
SELECT employee_name, employee_hire_date, revenue,
LAG(revenue) OVER(ORDER BY employee_hire_date) AS lagged_revenue
FROM sneaker_sales
ORDER BY employee_hire_date
)
SELECT *, revenue - lagged_revenue AS comparison_to_previous_employee
FROM cte

---------------- LEAD -----------------
-- Comparing side by side
WITH cte AS
(
SELECT employee_name, employee_hire_date, revenue,
LEAD(revenue) OVER(ORDER BY employee_hire_date) AS next_revenue
FROM sneaker_sales
ORDER BY employee_hire_date
)
SELECT *, revenue - next_revenue AS comparison_to_next_employee
FROM cte