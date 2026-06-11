-- ================================================
-- STOCK MARKET ANALYSIS (2020-2026)
-- Author: Ishika Verma
-- Tool: PostgreSQL (pgAdmin 4)
-- Dataset: 120 Companies | 9 Sectors | 6 Years
-- ================================================


-- ================================================
-- SECTION 1: TABLE CREATION
-- ================================================

CREATE TABLE stock_prices (
    date            DATE,
    ticker          VARCHAR(10),
    company_name    VARCHAR(100),
    sector          VARCHAR(50),
    industry        VARCHAR(100),
    open            NUMERIC(10,2),
    high            NUMERIC(10,2),
    low             NUMERIC(10,2),
    close           NUMERIC(10,2),
    adj_close       NUMERIC(10,2),
    volume          BIGINT
);

-- ================================================
-- SECTION 2: DATA CLEANING
-- ================================================

SELECT COUNT(*) FROM stock_prices;

SELECT * FROM stock_prices LIMIT 5;

1.' Dublicates check'

SELECT ticker,date,COUNT(*) AS cnt
FROM stock_prices
group by ticker,date
HAVING COUNT(*) > 1;

2.'Date Format check'

SELECT date,pg_typeof(date)
FROM stock_prices
LIMIT 5;

3.'Negetive Values check'

SELECT * FROM stock_prices
WHERE open < 0
   OR high < 0
   OR low  < 0
   OR close < 0
   OR volume < 0;

4.'High Low Logic Check'

SELECT * FROM stock_prices
WHERE high < low;

'Data Cleaning Summary:
- Duplicates: None found ✅
- Date format: Correct (DATE type) ✅
- Negative values: None found ✅
- High < Low anomalies: None found ✅
- Null values: Zero (already verified) ✅'


-- ================================================
-- EXPLORATORY ANALYSIS
-- ================================================

-- Query 1: Total companies per sector

SELECT sector, COUNT(DISTINCT ticker) AS total_companies
FROM stock_prices
GROUP BY sector
ORDER BY total_companies DESC;

-- Query 2: Dataset date range verification

SELECT 
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM stock_prices;

-- Query 3: Average closing price per sector

SELECT sector,
       ROUND(AVG(close), 2) AS avg_close_price
FROM stock_prices
GROUP BY sector
ORDER BY avg_close_price DESC;


-- Query 4: Top 10 most traded stocks by volume
SELECT ticker,
       company_name,
       SUM(volume) AS total_volume
FROM stock_prices
GROUP BY ticker, company_name
ORDER BY total_volume DESC
LIMIT 10;

-- ================================================
-- SECTION 4: SECTOR ANALYSIS
-- ================================================

-- Query 1: Sector-wise yearly average closing price

SELECT sector,
       EXTRACT(YEAR FROM date) AS year,
       ROUND(AVG(close), 2) AS avg_close
FROM stock_prices
GROUP BY sector, year
ORDER BY sector, year;


-- Query 2: Best performing sector each year (highest avg close)

SELECT year, sector, avg_close
FROM (
    SELECT 
        EXTRACT(YEAR FROM date) AS year,
        sector,
        ROUND(AVG(close), 2) AS avg_close,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM date) ORDER BY AVG(close) DESC) AS rnk
    FROM stock_prices
    GROUP BY year, sector
) ranked
WHERE rnk = 1
ORDER BY year;

-- ================================================
-- SECTION 5: TIME SERIES ANALYSIS
-- ================================================

-- Query 1: Monthly average close price (all sectors combined)
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(close), 2) AS avg_close
FROM stock_prices
GROUP BY year, month
ORDER BY year, month;


-- Query 2: Year-over-Year growth per sector

SELECT 
    sector,
    EXTRACT(YEAR FROM date) AS year,
    ROUND(AVG(close), 2) AS avg_close,
    ROUND(AVG(close) - LAG(AVG(close)) 
        OVER (PARTITION BY sector ORDER BY EXTRACT(YEAR FROM date)), 2) AS yoy_change
FROM stock_prices
GROUP BY sector, year
ORDER BY sector, year;


-- ================================================
-- SECTION 6: WINDOW FUNCTIONS
-- ================================================

-- Query 1: 30-day moving average per stock

SELECT date,ticker,close,
    ROUND(AVG(close) OVER (
        PARTITION BY ticker 
        ORDER BY date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_30
FROM stock_prices
ORDER BY ticker, date;


-- Query 2: Rank stocks by avg close price within each sector

SELECT ticker,company_name,sector,

    ROUND(AVG(close), 2) AS avg_close,
    RANK() OVER (
        PARTITION BY sector 
        ORDER BY AVG(close) DESC
    ) AS rank_in_sector
FROM stock_prices
GROUP BY ticker, company_name, sector
ORDER BY sector, rank_in_sector;


-- Query 3: Daily price change per stock

SELECT date, ticker,close,

    ROUND(close - LAG(close) OVER (
        PARTITION BY ticker 
        ORDER BY date
    ), 2) AS daily_change
FROM stock_prices
ORDER BY ticker, date;

-- ================================================
-- SECTION 7: VISUALIZATION
-- ================================================



-- Chart 1:  Total Companies per Sector
-----------------------------------------

SELECT sector, 
       COUNT(DISTINCT ticker) AS total_companies
FROM stock_prices
GROUP BY sector
ORDER BY total_companies DESC;


-- Chart 2: Overall Monthly Market Trend
-----------------------------------------

SELECT 
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(close), 2) AS avg_close
FROM stock_prices
GROUP BY year, month
ORDER BY year, month;


-- Chart 3: Sector-wise Average Closing Price
----------------------------------------------
SELECT sector,
       ROUND(AVG(close), 2) AS avg_close_price
FROM stock_prices
GROUP BY sector
ORDER BY avg_close_price DESC;


-- Chart 4: Sector Share in Dataset
------------------------------------
SELECT sector,
       COUNT(*) AS total_records
FROM stock_prices
GROUP BY sector
ORDER BY total_records DESC;


-- Chart 5: Top 10 Stocks by Volume
------------------------------------
SELECT ticker,
       company_name,
       SUM(volume) AS total_volume
FROM stock_prices
GROUP BY ticker, company_name
ORDER BY total_volume DESC
LIMIT 10;

-- ================================================
-- SECTION 7: CONCLUSIONS & RECOMMENDATIONS
-- ================================================

-- KEY FINDINGS FROM EXPLORATORY ANALYSIS
-- -----------------------------------------------

-- 1. Dataset contains 120 companies across 9 sectors (2020-2026)

--    Financial Services, Healthcare and Industrials are the most
--    represented sectors with 20 companies each.
--    Communication Services has the least representation with 7 companies.

-- 2. Healthcare sector has the highest average closing price at $247.28,

--    while Energy sector has the lowest at $77.97 across the full period.

-- 3. NVIDIA (NVDA) recorded the highest total trading volume at 621 billion,

--    followed by Tesla (TSLA) at 183 billion and Apple (AAPL) at 128 billion.
--    This reflects massive investor interest in AI and EV sectors post-2020.

-- -----------------------------------------------
-- KEY FINDINGS FROM SECTOR ANALYSIS
-- -----------------------------------------------

-- 4. Healthcare was the best performing sector for 5 consecutive years
--    (2020-2024), driven by post-COVID pharmaceutical and medical demand.

-- 5. Financial Services overtook Healthcare in 2025-2026,
--    recording the strongest growth with avg close reaching $318.98 in 2026.
--    This reflects banking sector boom and rising interest rate benefits.

-- 6. Communication Services suffered the worst single-year decline in 2022
--    with a YoY drop of -36.38, followed by Technology at -21.94.
--    This was driven by rising interest rates and post-pandemic correction.

-- 7. Consumer Defensive sector showed remarkable stability —
--    only sector with minimal negative movement across all years,
--    confirming its defensive nature during market downturns.

-- -----------------------------------------------
-- KEY FINDINGS FROM TIME SERIES ANALYSIS
-- -----------------------------------------------

-- 8. COVID-19 impact is clearly visible in March 2020 —
--    overall market average dropped to its lowest at $100.75,
--    recovering strongly from April 2020 onwards.

-- 9. 2022 was the worst year for most sectors due to aggressive
--    Federal Reserve interest rate hikes to combat inflation.
--    Nearly all sectors showed negative YoY growth in 2022.

-- 10. Energy sector was the only counter-cyclical performer in 2022
--     with a YoY growth of +30.80, driven by Russia-Ukraine war
--     and resulting surge in global oil and gas prices.

-- 11. Strong bull market observed from 2023 onwards —
--     Technology sector recorded its best YoY growth in 2024 at +58.33,
--     Financial Services recorded +56.10 in 2025.

-- 12. Overall market shows consistent upward trend from 2020 to 2026,
--     with avg close price growing from $122.33 (Jan 2020)
--     to $258.70 (Feb 2026) — more than doubling in 6 years.

-- -----------------------------------------------
-- KEY FINDINGS FROM WINDOW FUNCTIONS
-- -----------------------------------------------

-- 13. 30-day moving average analysis confirms that short-term volatility
--     was highest during 2020 (COVID) and 2022 (rate hikes),
--     while 2024-2026 shows smoother upward momentum.

-- 14. Stock rankings within sectors show that within Technology,
--     NVDA and AAPL consistently rank at the top by average close price,
--     while within Healthcare, high-value biotech stocks dominate.

-- 15. Daily price change analysis reveals that high volume stocks
--     like NVDA and TSLA also show the highest daily price swings,
--     confirming the high risk-high reward nature of these stocks.

-- -----------------------------------------------
-- RECOMMENDATIONS
-- -----------------------------------------------

-- 1. Financial Services sector shows strongest momentum in 2025-2026
--    and is worth monitoring for continued growth opportunities.

-- 2. Technology and Communication Services show strong post-2022 recovery
--    with Technology achieving its best YoY growth in 2024 (+58.33).
--    These sectors present strong long-term growth potential.

-- 3. Energy sector proved to be an effective hedge during the 2022
--    market downturn. Portfolio diversification with Energy stocks
--    can reduce overall portfolio risk during inflationary periods.

-- 4. Consumer Defensive sector is recommended for risk-averse investors
--    due to its consistent stability across all market conditions.

-- 5. High volume stocks like NVDA and TSLA offer high return potential
--    but come with significant daily price volatility —
--    suitable only for high risk tolerance investors.

-- 6. Overall market trend from 2020-2026 confirms long-term
--    wealth creation through equity investments despite short-term
--    corrections in 2020 and 2022.



