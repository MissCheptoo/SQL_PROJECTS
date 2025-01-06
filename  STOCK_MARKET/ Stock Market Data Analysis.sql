--  Stock Market Data Analysis

-- I got the dataset from kaggle
-- The dataset contains historical prices for META stock on Yahoo Finance from Jan 03, 2018 to Jan 03, 2024. 
-- The data includes the opening price, highest price, lowest price, closing price, adjusted closing price, and volume of the stock for each day.
-- it has 1,509 rows and 7 columns. Each row represents a trading day and each column represents a different price or volume indicator.

-- The dataset contains the following columns:

		-- 1.  Date: The date of the stock trading.
		-- 2. Open: The opening price.
		-- 3. High: The highest price of the stock during the day.
		-- 4. Low: The lowest price of the stock during the day.
		-- 5. Close: The closing price of the stock.
		-- 6. Adj Close: The adjusted closing price (taking into account stock splits, dividends, etc.).
		-- 7. Volume: The total volume of stocks traded.

-- Objective: Analyze historical stock prices and trading volumes to understand trends.

-- Tasks:
    -- 1. Query to find the highest-performing day and the lowest based on closing price trends
    -- 2.  Analyze trading volume spikes and their correlation with price changes.
    -- 3.  Calculate moving averages (e.g., 50-day and 200-day) using SQL window functions.
    -- 4. Query to Calculate Daily Price Change (Difference Between Close and Open)
    -- 5.  Query to Find Days with the Highest Trading Volume: 
    -- 6. Query to Calculate the yearly Average Closing Price:
    -- 7. Query to calculate the monthly Average closing price for 2018

-- First I'll Covert date to datetime datatype
SELECT 
    CAST(Date AS DATETIME) AS DateTime_Converted
FROM meta;

-- 1. Query to find the highest-performing day and the lowest performing day based on closing price trends.

SELECT Date, ROUND(Close, 2) AS Close
FROM meta
ORDER BY Close DESC
-- ORDER BY Close ASC
LIMIT 10;

-- The closing Price was high in 2021-09-07 by 328.18 and lowest in 2022-11-03 by 88.91

--  2. Analyze trading volume spikes and their correlation with price changes.
    -- a. Identify significant trading volume spikes: Use the Volume column to find days with volumes greater than 3 times the average.

SELECT Date, Volume
FROM meta
WHERE Volume > (SELECT AVG(Volume) * 3 FROM meta)
ORDER BY Volume DESC
LIMIT 10;

-- 2022-10-27 had the greatest number of stocks traded compared to the average

    -- b. Analyze correlation between volume spikes and price changes:Use the Close price to calculate price changes after volume spikes.
    
-- First I'll create a CTE(VolumeSpikes) which
		-- 1. Finds all the days where trading volume was more than 3 times the average volume.
		-- 2. For each of those days, it also calculates the previous day's closing price using LAG().
        
-- Then I'll Extracts the date, the current day's closing price, the previous day's closing price, 
-- and calculates the price change (i.e., how much the closing price changed from the previous day) for each day that had a significant volume spike.

WITH VolumeSpikes AS (
    SELECT 
        Date,
        Close,
        LAG(Close) OVER (ORDER BY Date) AS Prev_Close,
        Volume
    FROM meta
    WHERE 
        Volume > (SELECT AVG(Volume) * 3 FROM meta)
)
SELECT 
    Date,
    ROUND(Close,2) AS Close,
    ROUND(Prev_Close,2) AS Prev_Close,
    ROUND((Close - Prev_Close), 2)AS Price_Change
FROM 
    VolumeSpikes
-- ORDER BY Price_Change DESC;
ORDER BY Price_Change ASC;

       -- CONCLUSION 
-- Positive spikes tend to have larger magnitudes than the negative ones, with the highest price change being +76.9 (2023-02-02) versus -45.01 (2022-07-28).
-- Positive spikes (+76.9, +52.36, +49.39) indicate moments of strong bullish sentiment, possibly driven by unexpected positive results or announcements.
-- Negative spikes suggest market corrections or reactions to negative news.


-- 3.  Calculate moving averages (e.g., 50-day) using SQL window functions.

SELECT 
    Date,
    ROUND(Close,2) AS Close, 
    ROUND(AVG(Close) OVER (ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS Moving_Avg_50
FROM meta
ORDER BY Date;

-- If the Moving_Avg_50 is steadily increasing, it indicates an upward trend in the stock price.
-- If the Moving_Avg_50 is decreasing, it indicates a downward trend.
-- Helps traders and analysts understand the long-term price trend of the stock.
-- Filters out noise caused by daily price volatility.


-- 4. Query to Calculate Daily Price Change (Difference Between Close and Open)

SELECT Date, ROUND(Close - Open, 2) AS Daily_Price_Change
FROM meta
-- ORDER BY Daily_Price_Change DESC;
ORDER BY Daily_Price_Change ASC;

-- The ascending order displays the worst-performing days    
-- In descending order, the best-performing days will appear at the top.
-- Helps traders or analysts assess how frequently the stock has large intraday movements, aiding in risk assessment and strategy formulation.


-- 5.  Query to Find Days with the Highest Trading Volume: 
SELECT Date, Volume
FROM meta
-- ORDER BY Volume DESC
ORDER BY Volume ASC
LIMIT 10;

-- 6. Query to Calculate the yearly Average Closing Price:
SELECT 
    YEAR(Date) AS Year,
    ROUND(AVG(Close), 2) AS  Yearly_Avg_Close
FROM meta
GROUP BY YEAR(Date)
ORDER BY Year ASC;

-- 7. Query to calculate the monthly Average closing price for 2018
SELECT MONTH(Date) AS Month,
ROUND(AVG(Close), 2) AS Monthly_Avg_Price
FROM meta
WHERE Date LIKE '2018%'
GROUP BY MONTH(Date)
ORDER BY Month ASC;






