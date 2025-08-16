
--------------------------------------- Orders Analysis ---------------------------------------

--1 Retrieve the total number of orders in the dataset: 

SELECT COUNT(*) [# Orders]
FROM Orders

--2 List the Order Sources ordered by number of orders:

SELECT Source, COUNT(*) [# Orders] 
FROM Orders
GROUP BY Source
ORDER BY [# Orders] DESC

--3 Calculate the overall fulfilment rate (Delivered Orders / Total Orders):

WITH Deliverd_CTE AS
(
	SELECT COUNT(*) AS DeliverdOrders
	FROM Orders
	WHERE OrderStateTypeId = 4			--> ID 4 means that Orders are deliverd
)

SELECT Round( (CONVERT(FLOAT, DeliverdOrders) / (SELECT COUNT(*) FROM Orders))*1.0, 2) [Fulfilment Rate]
FROM Deliverd_CTE;

--4 Find the average order value month over month:

WITH OrderValues_CTE AS
(
	SELECT 
		FORMAT(CreatedOn, 'yyyy-MMM') AS ORDER_MONTH,
		SUM(Quantity * Price) AS ORDER_VALUE
	FROM Orders o INNER JOIN OrderItems oi
	ON o.OrderId = oi.OrderId
	GROUP BY FORMAT(CreatedOn, 'yyyy-MMM')
)
SELECT ORDER_MONTH, ROUND( AVG(ORDER_VALUE), 2) [AVG Order Value]
FROM OrderValues_CTE
GROUP BY ORDER_MONTH;

--5 Retrieve the number of scheduled orders and their fulfilment rate:

WITH Scheduled_CTE AS
(
	SELECT COUNT(*) AS ScheduledOrders
	FROM OrderStates
	WHERE OrderStateTypeId = 16			  --> ID 16 means that Orders are scheduled
)

SELECT 
	ScheduledOrders,
	Round( (CONVERT(FLOAT, ScheduledOrders) / (SELECT COUNT(*) FROM Orders))*1.0, 2) [Fulfilment Rate]
FROM Scheduled_CTE

--6 Find the top 3 reasons for not fulfilled orders with their percentages from total orders:

SELECT 
	TOP 3 StateName [Reasons For Failure], 
	COUNT(o.OrderId) [Total Orders],
	LEFT ( ROUND( COUNT(*)*1.0 / (SELECT COUNT(*) FROM Orders), 2), 4) [Percentage of Total]
FROM OrderStateTypes ost INNER JOIN Orders o
ON ost.OrderStateTypeId = o.OrderStateTypeId
WHERE o.OrderStateTypeId != 4
GROUP BY stateName
ORDER BY [Total Orders] DESC

--------------------------------------- Products Analysis ---------------------------------------

--7 Identify the top 5 Products with the highest number of orders:

SELECT TOP 5 ProductKey, COUNT(*) [Total Orders]
FROM OrderItems
GROUP BY ProductKey
ORDER BY [Total Orders] DESC

--8 Identify the top 5 Products with the highest amount of Sales Value:

SELECT TOP 5 ProductKey, SUM(Quantity * Price) [Total Sales]
FROM OrderItems
GROUP BY ProductKey
ORDER BY [Total Sales] DESC

--------------------------------------- Pharmacies Analysis ---------------------------------------

--9 Identify the top 5 Pharmacies based on the number of orders:

SELECT TOP 5 p.PharmacyKey, COUNT(OrderID) [# Orders]
FROM Pharmacies p INNER JOIN Orders o
ON p.PharmacyKey = o.PharmacyKey
GROUP BY p.PharmacyKey
ORDER BY [# Orders] DESC

--10 Identify the top 5 Pharmacies based on fulfilment rate:

SELECT 
	TOP 5 p.PharmacyKey, 
	ROUND( SUM( CASE WHEN OrderStateTypeId = 4 THEN 1 ELSE 0 END)*1.0 / COUNT(*), 2) [Fulfilment Rate]
FROM Pharmacies p INNER JOIN Orders o
ON p.PharmacyKey = o.PharmacyKey
GROUP BY p.PharmacyKey
ORDER BY [Fulfilment Rate] DESC

--11 For each pharmacy, calculate the total value of sales:

SELECT p.PharmacyKey, ROUND( SUM(Quantity * Price), 2) [Total Sales]
FROM Orders o INNER JOIN Pharmacies p
ON p.PharmacyKey = o.PharmacyKey
INNER JOIN OrderItems oi
ON o.OrderId = oi.OrderId
GROUP BY p.PharmacyKey
ORDER BY [Total Sales] DESC

--12 List all the pharmacies with their customer time (Time between order creation and the last order state):

SELECT 
	p.PharmacyKey,
	DATEDIFF(MINUTE, o.CreatedOn, last_state.last_state_time) AS Customer_Time
FROM Orders o INNER JOIN Pharmacies p
ON p.PharmacyKey = o.PharmacyKey
INNER JOIN 
(
	SELECT orderID, MAX(timestamp) as last_state_time    --> to get last state time for each order
	FROM OrderStates
	GROUP BY OrderId
) last_state
ON o.OrderId = last_state.OrderId

--14 List the top 5 order states before rejecting the orders (Only for rejected orders) with their total number of orders:

WITH states_with_prev AS (
    SELECT 
        os.OrderId,
        ost.StateName,
        LAG(ost.StateName) OVER (PARTITION BY os.OrderId ORDER BY os.TimeStamp) AS prev_state
    FROM OrderStates os
    INNER JOIN OrderStateTypes ost
    ON os.OrderStateTypeId = ost.OrderStateTypeId
)
SELECT TOP 5
    prev_state AS state_before_rejected,
    COUNT(*) AS total_orders
FROM states_with_prev
WHERE StateName like 'Rejected%'
AND prev_state IS NOT NULL
GROUP BY prev_state
ORDER BY total_orders DESC;

--13 List all the pharmacies with their delivery time (Time between accepting the order and order delivery)
/*
SELECT p.PharmacyKey,
       DATEDIFF(MINUTE, os_delivered.TimeStamp, os_accept.TimeStamp) AS delivery_time_minutes
FROM orders o
JOIN pharmacies p ON o.PharmacyKey = p.PharmacyKey
JOIN orderstates os_accept 
     ON o.orderid = os_accept.orderid 
     AND os_accept.OrderStateTypeId = 7
JOIN orderstates os_delivered 
     ON o.orderid = os_delivered.orderid 
     AND os_delivered.OrderStateTypeId = 4
ORDER BY delivery_time_minutes ASC; */