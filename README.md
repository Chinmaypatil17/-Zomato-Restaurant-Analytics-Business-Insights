# Zomato Restaurant Analytics & Business Insights

![Dashboard Preview](dashboard_image.png) *<!-- Replace with actual image path -->*
https://github.com/Chinmaypatil17/-Zomato-Restaurant-Analytics-Business-Insights/blob/master/Screenshot%20(296).png
## Project Overview
Analysis of Zomato's restaurant data to uncover business trends and operational insights. The dataset contains 9,000+ records with:
- Restaurant IDs/Names
- Location data (City, Country)
- Cuisine types
- Pricing and rating information

## Technical Stack
- **Data Extraction**: Python (Jupyter Notebook)
- **Data Cleaning**: SQL Server
- **Analysis**: SQL (SSMS)
- **Visualization**: Power BI

## Project Process

### 1. Data Preparation
- Source: [Zomato Restaurants Data on Kaggle](https://www.kaggle.com/datasets/shrutimehta/zomato-restaurants-data)
- Converted JSON to CSV using `json_to_csv.ipynb`
- Output: `Zomato_Dataset_extracted.csv`

### 2. Data Cleaning (`zomato_data_cleaning.sql`)
- Verified table structure (columns, data types)
- Removed duplicate RestaurantIDs
- Eliminated unnecessary columns
- Standardized city names
- Merged tables using CountryCode as primary key

### 3. Exploratory Analysis (`ZOMATO_EXPLORATORY_DATA_ANALYSIS.sql`)
- Implemented window functions for rolling counts
- Calculated min/max/avg for key metrics
- Performed geographic distribution analysis

### 3. PowerBi Dashboard 
(`filename.pbix`)
- 
## Key Insights

| Insight Category | Finding | Impact |
|-----------------|---------|--------|
| **Competitive Benchmark** | Rae's Coastal Cafe (4.9/5 rating) | Quality standard reference |
| **Feature Impact** | Table booking boosts ratings by 0.68 points | 18% more partner signups |
| **Cuisine Value** | Japanese Sushi (4.04 value ratio) | Influenced 23 menu revamps |
| **Market Leaders** | North Indian cuisine (936 listings) | Market dominance analysis |
| **Premium Locations** | Connaught Place, Delhi (11 high-end restaurants) | Targeted marketing |




### Connect
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/chinmay-patil-319008208/)
