-- Food Delivery System Analysis --

CREATE DATABASE FoodDelivery;
USE FoodDelivery;

-- Customers Table --
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);
INSERT INTO Customers VALUES
(1, 'Devansh Shah', 'Devansh@gmail.com', 'Pune', '2024-01-10'),
(2, 'Arya Mehta', 'Arya@gmail.com', 'Mumbai', '2024-02-15'),
(3, 'Vihaan Joshi', 'Vihaan@gmail.com', 'Pune', '2024-03-05'),
(4, 'Kavya Patil', 'Kavya@gmail.com', 'Nagpur', '2024-01-25');
SELECT * FROM Customers;

-- Restaurants Table --
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    city VARCHAR(50)
);
INSERT INTO Restaurants VALUES
(101, 'Spice Hub', 'Pune'),
(102, 'Food Palace', 'Mumbai'),
(103, 'Tandoori Treats', 'Pune'),
(104, 'Urban Bites', 'Nagpur');
SELECT * FROM Restaurants;

-- Menu Table --
CREATE TABLE Menu (
    menu_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);
INSERT INTO Menu VALUES
(201, 101, 'Paneer Biryani', 250),
(202, 101, 'Veg Kolhapuri', 220),
(203, 102, 'Cheese Pizza', 350),
(204, 103, 'Chicken Tikka', 300),
(205, 104, 'Veg Burger', 150);
SELECT * FROM Menu;

-- Delivery Partners Table --
CREATE TABLE DeliveryPartners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);
INSERT INTO DeliveryPartners VALUES
(301, 'Aditya', '9876543210', 'Pune'),
(302, 'Rohan', '9123456789', 'Mumbai'),
(303, 'Aarav ', '9988776655', 'Nagpur');
SELECT * FROM DeliveryPartners;

-- Orders Table --
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    partner_id INT,
    order_date DATETIME,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    delivery_location VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
    FOREIGN KEY (partner_id) REFERENCES DeliveryPartners(partner_id)
);
INSERT INTO Orders VALUES
(401, 1, 101, 301, '2024-10-01 12:30:00', 'Completed', 500, 'Kothrud'),
(402, 2, 102, 302, '2024-10-02 19:00:00', 'Completed', 350, 'Andheri'),
(403, 3, 103, 301, '2024-10-03 14:15:00', 'Cancelled', 300, 'Baner'),
(404, 4, 104, 303, '2024-10-04 20:00:00', 'Completed', 150, 'Civil Lines'),
(405, 1, 101, 301, '2024-10-05 13:00:00', 'Completed', 470, 'Kothrud');
SELECT * FROM Orders;

-- Order Details Table --
CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    menu_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
);
INSERT INTO Order_Details VALUES
(501, 401, 201, 2),
(502, 401, 202, 1),
(503, 402, 203, 1),
(504, 404, 205, 1),
(505, 405, 201, 1),
(506, 405, 202, 1);
SELECT * FROM Order_Details;

-- Payments Table --
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_mode VARCHAR(50),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Payments VALUES
(601, 401, 'UPI', 'Success'),
(602, 402, 'Card', 'Success'),
(603, 403, 'Cash', 'Failed'),
(604, 404, 'UPI', 'Success'),
(605, 405, 'Cash', 'Success');
SELECT * FROM Payments;

-- Feedback Table --
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    order_id INT,
    rating FLOAT,
    comments VARCHAR(255),
    feedback_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Feedback VALUES
(701, 401, 4.5, 'Tasty food', '2024-10-01'),
(702, 402, 4.0, 'Fast delivery', '2024-10-02'),
(703, 404, 5.0, 'Excellent service', '2024-10-04'),
(704, 405, 3.5, 'Good but delayed', '2024-10-05');
SELECT * FROM Feedback;

-- 1)Which customers are from Pune city? --
SELECT customer_name, email, city
FROM Customers
WHERE city = 'Pune';

-- 2)How many total orders has each restaurant received? --
SELECT r.restaurant_name, COUNT(o.order_id) AS total_orders
FROM Restaurants r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- 3)What is the total revenue from completed orders? --
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status = 'Completed';

-- 4)Which customer has spent the highest total amount? --
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 5)What items and quantities are included in each order? --
SELECT o.order_id, m.item_name, od.quantity
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Menu m ON od.menu_id = m.menu_id;

-- 6)Find total orders placed by each customer --
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 7)List all completed orders with customer and restaurant names --
SELECT o.order_id, c.customer_name, r.restaurant_name, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Completed';

-- 8)Find average order value --
SELECT AVG(total_amount) AS avg_order_value
FROM Orders
WHERE status = 'Completed';

-- 9)Get the highest priced item in the menu --
SELECT item_name, price
FROM Menu
ORDER BY price DESC
LIMIT 1;

-- 10)Find total revenue generated by each restaurant --
SELECT r.restaurant_name, 
SUM(CASE WHEN o.status = 'Completed' THEN o.total_amount ELSE 0 END) AS revenue
FROM Restaurants r
LEFT JOIN Orders o 
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- 11)List customers who have placed more than 1 order --
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 12)Find orders with failed payments --
SELECT o.order_id, p.payment_status
FROM Orders o
RIGHT JOIN Payments p 
ON o.order_id = p.order_id
WHERE p.payment_status = 'Failed';

-- 13)Get delivery partners and number of orders delivered --
SELECT DISTINCT d.partner_name,
COUNT(o.order_id) OVER (PARTITION BY d.partner_id) AS total_deliveries
FROM DeliveryPartners d
JOIN Orders o 
ON d.partner_id = o.partner_id
WHERE o.status = 'Completed';

-- 14)Find average rating for each restaurant --
SELECT r.restaurant_name,
(SELECT AVG(f.rating)
FROM Orders o
JOIN Feedback f ON o.order_id = f.order_id
WHERE o.restaurant_id = r.restaurant_id) AS avg_rating
FROM Restaurants r;

-- 15)Find most ordered item --
SELECT m.item_name, SUM(od.quantity) AS total_quantity
FROM Order_Details od
JOIN Menu m ON od.menu_id = m.menu_id
GROUP BY m.item_name
ORDER BY total_quantity DESC
LIMIT 1;