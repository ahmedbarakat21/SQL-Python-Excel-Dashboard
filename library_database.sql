-- Library Management System Project
-- =================================
-- Database Tables:
-- books, branch, employees, issued_status, members, return_status

-- Preview Tables
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

-- =================================
-- Task 1: Create a New Book Record
-- =================================
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- =================================
-- Task 2: Update an Existing Member's Address
-- =================================
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

-- =================================
-- Task 3: Delete a Record from Issued Status
-- =================================
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- =================================
-- Task 4: Retrieve All Books Issued by a Specific Employee (E101)
-- =================================
SELECT b.isbn, b.book_title, e.emp_name, i.issued_date
FROM books b
JOIN issued_status i ON b.isbn = i.issued_book_isbn
JOIN employees e ON e.emp_id = i.issued_emp_id
WHERE e.emp_id = 'E101';

-- =================================
-- Task 5: List Members Who Have Issued More Than One Book
-- =================================
SELECT issued_member_id, COUNT(*) AS number_of_books
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1
ORDER BY number_of_books DESC;

-- Create a summary table for issued books count
SELECT 
    b.isbn, 
    b.book_title, 
    COUNT(i.issued_id) AS total_issued
INTO Tbook_issued_cnt
FROM issued_status i
JOIN books b ON i.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM Tbook_issued_cnt;

-- =================================
-- Task 7: Find Total Rental Income by Category
-- =================================
SELECT category, SUM(rental_price) AS total_rental_income
FROM books
GROUP BY category;

-- =================================
-- Task 8: List Members Who Registered in the Last 500 Days
-- =================================
SELECT *
FROM members
WHERE reg_date >= DATEADD(DAY, -500, CAST(GETDATE() AS DATE));

-- =================================
-- Task 9: List Employees with Their Branch Manager's Name and Branch Details
-- =================================
SELECT 
    e.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address,
    b.contact_no
FROM branch b
JOIN employees e ON b.branch_id = e.branch_id;

-- =================================
-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
-- =================================
-- Check average price
SELECT AVG(rental_price) AS avg_rental_price FROM books;

-- Create table for expensive books
SELECT *
INTO expensive_books
FROM books
WHERE rental_price > 6.3;

SELECT * FROM expensive_books;

-- =================================
-- Task 12: Identify Members with Overdue Books
-- =================================
-- Assume return period is 30 days
SELECT 
    ist.issued_member_id AS member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) - 30 AS days_overdue
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS bk
    ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30
ORDER BY ist.issued_member_id;
