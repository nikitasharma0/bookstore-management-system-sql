-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books WHERE Genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT * FROM Books WHERE Published_Year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers WHERE Country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders WHERE Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT sum(Stock) FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books order by Price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders WHERE Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders WHERE Total_Amount>20;

-- 9) List all genres available in the Books table:
SELECT distinct Genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books order by Stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT sum(Total_Amount) FROM Orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT sum(o.Quantity) toatl_books_sold,b.Genre 
FROM Books b JOIN Orders o
ON b.Book_ID=o.Book_ID
group by Genre;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT avg(Price) avg_price, Genre FROM Books
group by Genre
Having Genre='Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT Customer_ID, count(Order_ID) od FROM Orders
GROUP BY Customer_ID
HAVING od>=2;

-- 4) Find the most frequently ordered book: select * from Orders;
SELECT Book_ID, count(Order_ID) id FROM Orders
GROUP BY Book_ID
ORDER BY id desc
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT Book_ID, Price, Genre FROM Books
where Genre='Fantasy'
order by price desc limit 3;


-- 6) Retrieve the total quantity of books sold by each author: 
SELECT b.Author, sum(o.Quantity) 
FROM Books b join Orders o on b.Book_ID = o.Book_ID
group by b.Author;

-- 7) List the cities where customers who spent over $30 are located: SELECT * FROM Books; SELECT * FROM Orders;
SELECT distinct c.City, o.Total_Amount  FROM 
Customers c join Orders o on c.Customer_ID=o.Customer_ID
where o.Total_Amount>30;

-- 8) Find the customer who spent the most on orders: SELECT * FROM Customers;
SELECT C.Name, sum(o.Total_Amount) max_order FROM 
Customers c join Orders o on c.Customer_ID=o.Customer_ID
group by c.Name
order by max_order desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
		b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;