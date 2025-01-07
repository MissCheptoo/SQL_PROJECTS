--  Personal Finance Management System:

-- functionalities of the system:

	-- 1. Track income, expenses, savings, and investments.
	-- 2. Generate financial reports (monthly, quarterly, yearly).
	-- 3. Analyze spending habits (e.g., top categories of expenses).
	-- 4. Provide budgeting and forecasting features.

DROP SCHEMA IF EXISTS Personal_Finance_Management;
CREATE SCHEMA IF NOT EXISTS Personal_Finance_Management;

-- Table 1: INCOME
DROP TABLE IF EXISTS  Personal_Finance_Management.Income ;
CREATE TABLE IF NOT EXISTS Personal_Finance_Management.Income(
	income_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Insert categories for income
INSERT INTO Categories (name) VALUES 
('Salary'), 
('Bonus'), 
('Investment Income'), 
('Other Income');

-- Insert sample income records
INSERT INTO Income (date, amount, category_id) VALUES 
('2025-01-01', 2000.00, 1), 
('2025-01-15', 500.00, 2);


-- Table 2: EXPENSES
DROP TABLE IF EXISTS  Personal_Finance_Management.expenses ;
CREATE TABLE IF NOT EXISTS Personal_Finance_Management.expenses(
	expense_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
     
-- Insert categories for expenses
INSERT INTO Categories (name) VALUES 
('Rent'), 
('Utilities'), 
('Groceries'), 
('Transportation'), 
('Entertainment'), 
('Healthcare'), 
('Savings'), 
('Other Expenses');
     
-- Insert sample expense records
INSERT INTO Expenses (date, amount, category_id) VALUES 
('2025-01-02', 800.00, 5), 
('2025-01-10', 150.00, 4), 
('2025-01-12', 50.00, 6);

    
    
-- Table 3: SAVINGS
DROP TABLE IF EXISTS  Personal_Finance_Management.savings  ;
CREATE TABLE IF NOT EXISTS Personal_Finance_Management.savings(
	savings_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

-- Insert sample savings records
INSERT INTO Savings (date, amount) VALUES 
('2025-01-05', 200.00), 
('2025-01-20', 300.00);



-- Table 4: INVESTMENTS 
DROP TABLE IF EXISTS  Personal_Finance_Management.investment;
CREATE TABLE IF NOT EXISTS Personal_Finance_Management.investment(
	investment_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    type VARCHAR(255) NOT NULL
);

-- Insert sample investments records
INSERT INTO investment (date, amount, type) VALUES 
('2025-01-03', 1000.00, 'Stocks'), 
('2025-01-18', 500.00, 'Bonds');


-- Table 5: CATEGORIES
DROP TABLE IF EXISTS  Personal_Finance_Management.categories ;
CREATE TABLE IF NOT EXISTS Personal_Finance_Management.categories(
	category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

SELECT * FROM Categories;


--  Verifying data integrity
-- 1. 
SELECT * FROM Income;
SELECT * FROM expenses;
SELECT * FROM savings;
SELECT * FROM investment;
SELECT * FROM Categories;

-- 2.  Insert test records to see how the database handles edge cases.
-- Insert an expense with a non-existent category_id:
-- Expected: Should fail due to foreign key constraint.
INSERT INTO Expenses (date, amount, category_id) VALUES ('2025-01-15', 100.00, 999);

-- 3.  Duplicate Category Name:
-- Expected: Should fail due to the UNIQUE constraint on name.
INSERT INTO Categories (name) VALUES ('Rent');


-- 4.  Insert a record with an unusually large amount:
-- Expected: Should work if within DECIMAL(10,2) limits.
INSERT INTO Income (date, amount, category_id) VALUES ('2025-01-15', 999999999.99, 1);


-- -- LETS WRITE SOME QUERIES TO RETRIEVE INFORMATION

-- 1. Query to get monthly total income

SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month, 
    SUM(amount) AS total_income 
FROM Income 
GROUP BY month;

-- 2.  Query to get total monthly expenses

SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month, 
    SUM(amount) AS total_expenses 
FROM Expenses 
GROUP BY month;

-- 3.  Query to get spending habits by category

SELECT 
    c.name AS category, 
    SUM(e.amount) AS total_spent 
FROM expenses e 
JOIN Categories c ON e.category_id = c.category_id 
GROUP BY c.name 
ORDER BY total_spent DESC;

-- 4.  Query to Calculate net worth based on income, expenses, savings, and investments:

SELECT 
    (SELECT COALESCE(SUM(amount), 0) FROM Income) -
    (SELECT COALESCE(SUM(amount), 0) FROM expenses) +
    (SELECT COALESCE(SUM(amount), 0) FROM savings) +
    (SELECT COALESCE(SUM(amount), 0) FROM investment) AS net_worth;

