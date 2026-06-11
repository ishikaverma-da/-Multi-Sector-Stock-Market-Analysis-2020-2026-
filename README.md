# 📈 Multi-Sector Stock Market Analysis (2020–2026)

## 📌 Project Overview
A comprehensive SQL-based analysis of 120 companies across 9 sectors
spanning 6 years (2020–2026). This project covers data cleaning,
exploratory analysis, sector analysis, time series analysis,
and window functions — entirely using PostgreSQL.

---

## 🛠️ Tools Used
- PostgreSQL (pgAdmin 4)
- SQL (Window Functions, CTEs, Aggregations)

---

## 📂 Dataset
- **Source:** Stock market daily price data
- **Companies:** 120
- **Sectors:** 9
- **Period:** January 2020 – February 2026
- **Records:** 184,138 rows
- **Columns:** Date, Ticker, Company Name, Sector, Industry, Open, High, Low, Close, Adj Close, Volume

---

## 📁 Project Structure

stock-market-analysis-sql/
├── stock_market_analysis.sql
├── README.md
└── screenshots/
    ├── chart1_companies_per_sector.png
    ├── chart2_monthly_market_trend.png
    ├── chart3_sector_avg_close_price.png
    ├── chart4_sector_share_dataset.png
    └── chart5_top10_stocks_volume.png

---

## 🔍 Analysis Sections
1. **Table Creation** — Schema design for stock price data
2. **Data Cleaning** — Duplicate check, null check, data type verification, logic validation
3. **Exploratory Analysis** — Sector distribution, date range, avg prices, volume leaders
4. **Sector Analysis** — Sector-wise yearly trends, best performing sector per year
5. **Time Series Analysis** — Monthly market trends, YoY growth per sector
6. **Window Functions** — 30-day moving average, sector rankings, daily price change
7. **Conclusions & Recommendations**

---

## 💡 Key Insights
- **Healthcare** was the top performing sector for 5 consecutive years (2020–2024)
- **Financial Services** overtook Healthcare in 2025–2026, reaching avg close of $318.98
- **2022 market crash** clearly visible — Communication Services dropped -36.38 YoY
- **COVID-19 impact** visible in March 2020 — market avg hit lowest at $100.75
- **NVIDIA (NVDA)** recorded highest trading volume at 621 billion — AI boom effect
- **Energy** was the only counter-cyclical sector in 2022 (+30.80 YoY) due to Russia-Ukraine war
- Overall market more than **doubled** from $122 (Jan 2020) to $258 (Feb 2026)

---

## 📸 Visualizations

### Chart 1: Companies per Sector
![Chart 1](screenshots/chart1_companies_per_sector.png)

### Chart 2: Monthly Market Trend
![Chart 2](screenshots/chart2_monthly_market_trend.png)

### Chart 3: Sector Avg Close Price
![Chart 3](screenshots/chart3_sector_avg_close_price.png)

### Chart 4: Sector Share in Dataset
![Chart 4](screenshots/chart4_sector_share_dataset.png)

### Chart 5: Top 10 Stocks by Volume
![Chart 5](screenshots/chart5_top10_stocks_volume.png)

---

## 🧠 Recommendations
1. **Financial Services** shows strongest momentum in 2025–2026 — worth monitoring
2. **Technology & Communication Services** show strong post-2022 recovery
3. **Energy** proved to be an effective hedge during inflationary market downturns
4. **Consumer Defensive** is best choice for risk-averse investors
5. **NVDA & TSLA** offer high return potential but come with high daily volatility

---

## 👩‍💻 Author
**Ishika Verma**
Data Analyst | SQL • Power BI • Python • Excel
📧 ishika.verma.da@gmail.com
🔗 [LinkedIn]()
🐙 [GitHub](https://github.com/ishikaverma-da)
