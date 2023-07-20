#Schema
CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);
--------------------
INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);
--------------------
CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);
--------------------
INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');
--------------------
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);
--------------------
INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');

#Query SQL
SELECT * FROM cars;
SELECT * FROM salespersons;
SELECT * FROM sales;

#1. What are the details of all cars purchased in the year 2022?
SELECT cars.car_id,cars.make,cars.type,cars.style,cars.cost_$,Year(sales.purchase_date) AS Purchase_Year 
FROM cars
INNER JOIN sales
ON cars.car_id = sales.car_id
WHERE YEAR(purchase_date) = '2022';

#2. What is the total number of cars sold by each salesperson?
SELECT salespersons.name AS Salesman, COUNT(sales.salesman_id) AS Total_Cars_Sold
FROM salespersons
INNER JOIN sales ON salespersons.salesman_id = sales.salesman_id
GROUP BY salespersons.name 
ORDER BY total_cars_sold DESC;

#3. What is the total revenue generated by each salesperson?
SELECT salespersons.name AS Salesman, SUM(cars.cost_$) AS Revenue
FROM salespersons
INNER JOIN sales ON salespersons.salesman_id = sales.salesman_id
INNER JOIN cars ON sales.car_id = cars.car_id
GROUP BY salespersons.name
ORDER BY Revenue;

#4. What are the details of the cars sold by each salesperson?
SELECT salespersons.name AS Salesman,cars.car_id,cars.make,cars.type,cars.style
FROM cars
INNER JOIN sales ON cars.car_id = sales.car_id
INNER JOIN salespersons ON sales.salesman_id = salespersons.salesman_id
GROUP BY cars.car_id;

#5. What is the total revenue generated by each car type?
SELECT cars.type, SUM(cars.cost_$) AS Revenue
FROM cars
GROUP BY cars.type
ORDER BY Revenue;

#6. What are the details of the cars sold in the year 2021 by salesperson?
SELECT salespersons.name,cars.car_id,cars.make,cars.type,cars.style,cars.cost_$,YEAR(purchase_date) AS Purcahse_Year
FROM cars
INNER JOIN sales ON cars.car_id = sales.car_id
INNER JOIN salespersons ON sales.salesman_id = salespersons.salesman_id
WHERE YEAR(purchase_date) = '2021' AND salespersons.name = 'Emily Wong';

#7. What is the total revenue generated by the sales of hatchback cars?
SELECT cars.style, SUM(cars.cost_$) AS Revenue
FROM cars
INNER JOIN sales ON cars.car_id = sales.car_id
WHERE cars.style = 'Hatchback';

#8. What is the total revenue generated by the sales of SUV cars in the years 2022
SELECT cars.style, SUM(cars.cost_$) AS Revenue,YEAR(sales.purchase_date) AS Purchase_Year
FROM cars
INNER JOIN sales ON cars.car_id = sales.car_id
WHERE cars.style = 'SUV' AND YEAR(sales.purchase_date) = '2022';

#9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
select salespersons.name, salespersons.city, year(sales.purchase_date) as Purchase_Year, count(cars.car_id) as Number_Cars
from salespersons
inner join sales on salespersons.salesman_id = sales.salesman_id
inner join cars on sales.car_id = cars.car_id
where year(sales.purchase_date) = '2023'
group by salespersons.name, salespersons.city, Purchase_Year
order by Number_Cars desc
limit 1;

#10. What is the name and age of the salesperson who generated the highest revenue in the year 2022
SELECT salespersons.name,salespersons.age,YEAR(sales.purchase_date) AS Purchase_Year, SUM(cars.cost_$) AS Revenue
FROM salespersons
INNER JOIN sales ON salespersons.salesman_id = sales.salesman_id
INNER JOIN cars ON sales.car_id = cars.car_id
WHERE YEAR(sales.purchase_date) = '2022'
GROUP BY salespersons.name,salespersons.age
ORDER BY Revenue DESC
LIMIT 1;
