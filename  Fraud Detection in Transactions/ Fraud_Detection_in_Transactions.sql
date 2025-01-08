--  Fraud Detection in Transactions

-- I got the dataset in kaggle
-- This dataset provides a detailed look into transactional behavior and financial activity patterns, ideal for exploring fraud detection and anomaly identification. 
-- It contains 2,512 samples of transaction data, covering various transaction attributes, customer demographics, and usage patterns.
--  Each entry offers comprehensive insights into transaction behavior, enabling analysis for financial security and fraud detection applications.

-- Key Features:

		-- 	TransactionID: Unique alphanumeric identifier for each transaction.
		-- 	AccountID: Unique identifier for each account, with multiple transactions per account.
		-- 	TransactionAmount: Monetary value of each transaction, ranging from small everyday expenses to larger purchases.
		-- 	TransactionDate: Timestamp of each transaction, capturing date and time.
		-- 	TransactionType: Categorical field indicating 'Credit' or 'Debit' transactions.
		-- 	Location: Geographic location of the transaction, represented by U.S. city names.
		-- 	DeviceID: Alphanumeric identifier for devices used to perform the transaction.
		-- 	IP Address: IPv4 address associated with the transaction, with occasional changes for some accounts.
		-- 	MerchantID: Unique identifier for merchants, showing preferred and outlier merchants for each account.
		-- 	AccountBalance: Balance in the account post-transaction, with logical correlations based on transaction type and amount.
		-- 	PreviousTransactionDate: Timestamp of the last transaction for the account, aiding in calculating transaction frequency.
		-- 	Channel: Channel through which the transaction was performed (e.g., Online, ATM, Branch).
		-- 	CustomerAge: Age of the account holder, with logical groupings based on occupation.
		-- 	CustomerOccupation: Occupation of the account holder (e.g., Doctor, Engineer, Student, Retired), reflecting income patterns.
		-- 	TransactionDuration: Duration of the transaction in seconds, varying by transaction type.
		-- 	LoginAttempts: Number of login attempts before the transaction, with higher values indicating potential anomalies.

-- Import the bank_transactions dataset csv file

-- I am now going to do queries to retrieve information

-- 1. Query to Flag transactions with unusually high amounts compared to typical transactions.
-- This SQL query identifies transactions with amounts significantly higher than average
-- data points that fall beyond 3 standard deviations from the mean are considered outliers.
SELECT TransactionID, AccountID, TransactionAmount, TransactionDate
FROM bank_transactions_data
WHERE TransactionAmount > ( SELECT AVG( TransactionAmount) + 3 * STDDEV(TransactionAmount) 
        FROM bank_transactions_data)
ORDER BY TransactionAmount DESC;
 

-- 2. Query to Identify High-Frequency Transactions; 
-- Detect accounts with unusually frequent transactions within a short time.
SELECT AccountID, 
    COUNT(*) AS TransactionCount, 
    MIN(TransactionDate) AS StartDate, 
    MAX(TransactionDate) AS EndDate 
FROM bank_transactions_data
GROUP BY AccountID
HAVING TransactionCount > (
        SELECT AVG(TransactionCount) + 3 * STDDEV(TransactionCount) 
        FROM (SELECT AccountID, 
                   COUNT(*) AS TransactionCount 
            FROM bank_transactions_data
            GROUP BY AccountID ) subquery
    );

-- 3.  Create Rules to Flag High-Risk Transactions
-- Use CASE statements to create rules that flag transactions based on various criteria.
SELECT 
    TransactionID, 
    AccountID, 
    TransactionAmount, 
    TransactionDate, 
    Location, 
    CASE 
        WHEN TransactionAmount > 10000 THEN 'High Value'
        WHEN TransactionDuration > 300 THEN 'Unusual Duration'
        WHEN Location NOT IN (
            SELECT DISTINCT Location 
            FROM bank_transactions_data 
            WHERE AccountID = bank_transactions_data.AccountID
        ) THEN 'Unusual Location'
        WHEN LoginAttempts > 3 THEN 'Multiple Login Attempts'
        ELSE 'Normal'
    END AS RiskFlag
FROM 
    bank_transactions_data;

 
-- 4. Combine criteria for anomaly detection into a single query to identify transactions meeting multiple flags.
SELECT 
    TransactionID, 
    AccountID, 
    TransactionAmount, 
    TransactionDate, 
    Location, 
    CASE 
        WHEN TransactionAmount > (
            SELECT AVG(TransactionAmount) + 3 * STDDEV(TransactionAmount) 
            FROM bank_transactions_data
        ) THEN 'High Value'
        WHEN Location NOT IN (
            SELECT DISTINCT Location 
            FROM bank_transactions_data 
            WHERE AccountID = bank_transactions_data.AccountID
        ) THEN 'Unusual Location'
        WHEN TransactionDuration > 300 THEN 'Unusual Duration'
        WHEN LoginAttempts > 3 THEN 'Multiple Login Attempts'
        ELSE 'Normal'
    END AS RiskFlag
FROM 
    bank_transactions_data
WHERE 
    TransactionAmount > (
        SELECT AVG(TransactionAmount) + 3 * STDDEV(TransactionAmount) 
        FROM bank_transactions_data
    )
    OR Location NOT IN (
        SELECT DISTINCT Location 
        FROM bank_transactions_data 
        WHERE AccountID = bank_transactions_data.AccountID
    )
    OR TransactionDuration > 300
    OR LoginAttempts > 3;


-- 5.  Query to Flag transactions performed from multiple DeviceIDs within a short period for the same AccountID.
-- Identify Suspicious Device Usage
SELECT 
    AccountID, 
    COUNT(DISTINCT DeviceID) AS DeviceCount, 
    MIN(TransactionDate) AS StartDate, 
    MAX(TransactionDate) AS EndDate
FROM 
    bank_transactions_data
GROUP BY 
    AccountID
HAVING 
    DeviceCount > 1 -- Adjust this threshold based on your analysis
    AND DATEDIFF(MAX(TransactionDate), MIN(TransactionDate)) <= 7; -- Within a week
 
 -- 6.Analyze Sequential Login Failures
-- Find accounts with multiple failed login attempts before a successful transaction.
SELECT 
    TransactionID, 
    AccountID, 
    LoginAttempts, 
    TransactionDate
FROM 
    bank_transactions_data
WHERE 
    LoginAttempts > 3; -- Adjust threshold

-- 7. 
SELECT 
    TransactionID, 
    AccountID, 
    TransactionAmount, 
    TransactionDate, 
    CASE 
        WHEN TransactionAmount > 10000 THEN 2
        ELSE 0
    END +
    CASE 
        WHEN LoginAttempts > 3 THEN 1
        ELSE 0
    END +
    CASE 
        WHEN Location NOT IN (
            SELECT DISTINCT Location 
            FROM bank_transactions_data 
            WHERE AccountID = bank_transactions_data.AccountID
        ) THEN 1
        ELSE 0
    END AS RiskScore
FROM 
    bank_transactions_data
WHERE 
    TransactionAmount > 10000
    OR LoginAttempts > 3
    OR Location NOT IN (
        SELECT DISTINCT Location 
        FROM bank_transactions_data 
        WHERE AccountID = bank_transactions_data.AccountID
    );

-- You can adjust the queries for any of the queries