DROP SCHEMA IF EXISTS bank_management;
CREATE SCHEMA IF NOT EXISTS bank_management;

-- Table 1: CUSTOMER INFORMATION
DROP TABLE IF EXISTS bank_management.customers;
CREATE TABLE IF NOT EXISTS bank_management.customers(
    customer_id VARCHAR(50) PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE,
    email TEXT,
    phone_number TEXT,
    address TEXT,
    sign_up_date DATE,
    status TEXT CHECK (status IN ('Active', 'Inactive', 'Closed'))
);

INSERT INTO bank_management.customers (customer_id, first_name, last_name, date_of_birth, email, phone_number, address, sign_up_date, status)
VALUES
('CUST001', 'Mercy', 'Cheptoo', '2003-05-10', 'mercy.cheptoo@example.com', '0701234567', 'Nairobi, Kenya', '2020-03-01', 'Active'),
('CUST002', 'Koko', 'Koko', '2002-09-15', 'koko.koko@example.com', '0723456789', 'Mombasa, Kenya', '2021-07-20', 'Active'),
('CUST003', 'Dorothy', 'Dorothy', '2000-11-22', 'dorothy.d@example.com', '0712345678', 'Kisumu, Kenya', '2019-05-18', 'Active'),
('CUST004', 'Emma', 'Emma', '2004-03-01', 'emma.emma@example.com', '0734567890', 'Eldoret, Kenya', '2022-01-10', 'Active'),
('CUST005', 'Danmike', 'Danmike', '2005-06-18', 'danmike.d@example.com', '0709876543', 'Nakuru, Kenya', '2023-02-25', 'Active');


-- Table 2: Account Details
DROP TABLE IF EXISTS bank_management.accounts;
CREATE TABLE IF NOT EXISTS bank_management.accounts (
    account_id  VARCHAR(255) PRIMARY KEY,
    customer_id  VARCHAR(50),
    account_type TEXT CHECK (account_type IN ('Savings', 'Checking', 'Credit', 'Loan')),
    balance DECIMAL(15, 2),
    opening_date DATE,
    status TEXT CHECK (status IN ('Active', 'Closed')),
    FOREIGN KEY (customer_id) REFERENCES bank_management.customers(customer_id)
);

INSERT INTO bank_management.accounts (account_id, customer_id, account_type, balance, opening_date, status)
VALUES
('ACC001', 'CUST001', 'Savings', 1000, '2020-03-01', 'Active'),
('ACC002', 'CUST002', 'Checking', 500, '2021-07-20', 'Active'),
('ACC003', 'CUST003', 'Credit', 2000, '2019-05-18', 'Active'),
('ACC004', 'CUST004', 'Loan', 5000, '2022-01-10', 'Active'),
('ACC005', 'CUST005', 'Savings', 2500, '2023-02-25', 'Active');


-- Table 3: Transaction History
DROP TABLE IF EXISTS bank_management.transactions;
CREATE TABLE IF NOT EXISTS bank_management.transactions (
    transaction_id VARCHAR(255) PRIMARY KEY,
    account_id VARCHAR(255),
    transaction_date TIMESTAMP,
    amount DECIMAL(15, 2),
    transaction_type TEXT CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer', 'Payment')),
    description TEXT,
    FOREIGN KEY (account_id) REFERENCES bank_management.accounts(account_id)
);

INSERT INTO bank_management.transactions (transaction_id, account_id, transaction_date, amount, transaction_type, description)
VALUES
('TRANS001', 'ACC001', '2024-03-01 10:00:00', 500, 'Deposit', 'Deposited into savings account'),
('TRANS002', 'ACC002', '2024-03-02 14:30:00', 100, 'Withdrawal', 'Withdrew from checking account'),
('TRANS003', 'ACC003', '2024-03-03 16:45:00', 200, 'Payment', 'Payment made towards credit balance'),
('TRANS004', 'ACC004', '2024-03-04 09:00:00', 1000, 'Deposit', 'Loan repayment'),
('TRANS005', 'ACC005', '2024-03-05 12:15:00', 500, 'Transfer', 'Transferred to another account');

-- Table 4: LOAN DETAILS
DROP TABLE IF EXISTS bank_management.loans;
CREATE TABLE IF NOT EXISTS bank_management.loans (
    loan_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(50),
    account_id VARCHAR(255),
    loan_amount DECIMAL(15, 2),
    interest_rate DECIMAL(5, 2),
    loan_start_date DATE,
    loan_end_date DATE,
    status TEXT CHECK (status IN ('Active', 'Closed', 'Defaulted')),
    FOREIGN KEY (customer_id) REFERENCES bank_management.customers(customer_id),
    FOREIGN KEY (account_id) REFERENCES bank_management.accounts(account_id)
);

INSERT INTO bank_management.loans (loan_id, customer_id, account_id, loan_amount, interest_rate, loan_start_date, loan_end_date, status)
VALUES
('LOAN001', 'CUST001', 'ACC001', 10000.00, 5.5, '2024-01-01', '2029-01-01', 'Active'),
('LOAN002', 'CUST002', 'ACC002', 5000.00, 7.0, '2023-06-15', '2028-06-15', 'Active'),
('LOAN003', 'CUST003', 'ACC003', 15000.00, 4.5, '2024-02-10', '2030-02-10', 'Active'),
('LOAN004', 'CUST004', 'ACC004', 20000.00, 6.0, '2022-05-25', '2027-05-25', 'Closed'),
('LOAN005', 'CUST005', 'ACC005', 8000.00, 8.0, '2023-09-01', '2028-09-01', 'Defaulted');

-- Table 5: CUSTOMER SERVICE
DROP TABLE IF EXISTS bank_management.customer_service;
CREATE TABLE IF NOT EXISTS bank_management.customer_service (
	service_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  VARCHAR(50),
    service_date TIMESTAMP,
    issue_type TEXT,
    resolution TEXT,
    agent_id VARCHAR(255),
    resolved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES bank_management.customers(customer_id)
);

INSERT INTO bank_management.customer_service (customer_id, service_date, issue_type, resolution, agent_id, resolved)
VALUES
('CUST001', '2024-03-15 10:00:00', 'Account issue', 'Customer’s account was locked due to security reasons. Issue resolved after verification.', 'Agent101', TRUE),
('CUST002', '2024-04-01 14:30:00', 'Loan inquiry', 'Loan details shared with the customer. Follow-up scheduled for next week.', 'Agent102', FALSE),
('CUST003', '2024-04-20 09:45:00', 'Card transaction dispute', 'Customer’s disputed transaction refunded after verification with the bank’s fraud department.', 'Agent103', TRUE),
('CUST004', '2024-05-05 11:00:00', 'Payment failure', 'Payment gateway issue resolved, customer payment processed successfully.', 'Agent104', TRUE),
('CUST005', '2024-06-10 16:30:00', 'Account closure request', 'Account closure request initiated, confirmation sent to the customer.', 'Agent105', FALSE);


-- Verify Data Integrity

SELECT * FROM bank_management.customers;
SELECT * FROM bank_management.accounts WHERE customer_id = 'CUST001';

-- LETS WRITE SOME QUERIES TO RETRIEVE INFORMATION

-- Retrieve a list of all customers with their account balances:
SELECT c.first_name, c.last_name, a.account_id, a.balance
FROM bank_management.customers c
JOIN bank_management.accounts a ON c.customer_id = a.customer_id;

-- Retrieve all transactions for a specific account:
SELECT t.transaction_id, t.transaction_date, t.amount, t.transaction_type
FROM bank_management.transactions t
WHERE t.account_id = 'ACC001';

-- Average Transaction Amount per Account
SELECT account_id, AVG(amount) AS average_transaction
FROM bank_management.transactions
GROUP BY account_id;

-- Loan Status Analysis
SELECT status, COUNT(*) AS number_of_loans
FROM bank_management.loans
GROUP BY status;

-- Resolved Customer Service Cases
SELECT customer_id, COUNT(service_id) AS resolved_cases
FROM bank_management.customer_service
WHERE resolved = TRUE
GROUP BY customer_id;

 
 


