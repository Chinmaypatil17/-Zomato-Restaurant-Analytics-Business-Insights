use zomato_db;
select * from [dbo].[Zomato_Dataset_Cleaned];

select COLUMN_NAME ,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ZOmato_Dataset_cleaned';

-- 1. What are the top 10 highest rated restaurants?
SELECT TOP 10 RestaurantName, City, Cuisines, Average_Cost_for_two, Rating
FROM [dbo].[Zomato_Dataset_Cleaned]
ORDER BY Rating DESC;

-- 2. Which cities have the most restaurants listed on Zomato?
SELECT City, COUNT(*) AS RestaurantCount
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY City
ORDER BY RestaurantCount DESC;


-- 3. What is the average cost for two people by cuisine type?
SELECT Cuisines, AVG(Average_Cost_for_two) AS AvgCostForTwo
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY Cuisines
ORDER BY AvgCostForTwo ;

-- 4. How does table booking availability correlate with ratings?
SELECT Has_Table_booking, AVG(Rating) AS AvgRating, COUNT(*) AS RestaurantCount
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY Has_Table_booking;

-- 5. Which price range offers the best value (rating vs cost)?
SELECT Price_range, AVG(Rating) AS AvgRating, AVG(Average_Cost_for_two) AS AvgCost
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY Price_range
ORDER BY Price_range;

-- 6. What percentage of restaurants offer online delivery?
SELECT 
    Has_Online_delivery,AVG(Rating) AS AvgRating ,
    COUNT(*) AS Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[Zomato_Dataset_Cleaned]) AS DECIMAL(5,2)) AS Percentage
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY Has_Online_delivery;

-- 7. Which localities have the highest concentration of expensive restaurants?
SELECT Locality, City, COUNT(*) AS HighEndRestaurants
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Price_range >= 4
GROUP BY Locality, City
ORDER BY HighEndRestaurants DESC;

-- 1.1 Restaurants with best value (high rating + reasonable price)
SELECT TOP 10 
    RestaurantName, 
    City, 
    Cuisines,
    Average_Cost_for_two,
    Rating,
    (Rating / NULLIF(Average_Cost_for_two/1000, 0)) AS ValueScore
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Votes > 100
  AND Average_Cost_for_two > 0  -- Exclude free restaurants
ORDER BY ValueScore DESC;

-- 1.2 Rating distribution across price ranges
SELECT 
    Price_range,
    MIN(Rating) AS MinRating,
    MAX(Rating) AS MaxRating,
    AVG(Rating) AS AvgRating,
    COUNT(*) AS RestaurantCount
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY Price_range
ORDER BY Price_range;

-- Most Popular Cuisine (for resume)
SELECT TOP 1
    c.value AS TopCuisine,
    COUNT(*) AS RestaurantCount,
    AVG(r.Rating) AS AvgRating,
    AVG(r.Average_Cost_for_two) AS AvgPrice
FROM [dbo].[Zomato_Dataset_Cleaned] r
CROSS APPLY STRING_SPLIT(r.Cuisines, '|') c
GROUP BY c.value
HAVING COUNT(*) > 10
ORDER BY RestaurantCount DESC;

--For High-Value Restaurants--
SELECT TOP 1
    RestaurantName,
    City,
    (Rating / NULLIF(Average_Cost_for_two/1000, 0)) AS ValueScore
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Votes > 100
ORDER BY ValueScore DESC;

--Market Dominator Cuisine
SELECT TOP 1
    c.value AS DominantCuisine,
    COUNT(*) AS MarketShare
FROM [dbo].[Zomato_Dataset_Cleaned] r
CROSS APPLY STRING_SPLIT(r.Cuisines, '|') c
GROUP BY c.value
ORDER BY MarketShare DESC;

--Highest Value Restaurant
SELECT TOP 1
    RestaurantName,
    (Rating / NULLIF(Average_Cost_for_two/1000, 0)) AS ValueIndex
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Votes > 100
ORDER BY ValueIndex DESC;

--Premium Pricing Benchmark
SELECT 
    AVG(Average_Cost_for_two) AS PremiumAvgPrice
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Price_range = 4;

--Top Rated City
SELECT TOP 1
    City,
    AVG(Rating) AS CityAvgRating
FROM [dbo].[Zomato_Dataset_Cleaned]
GROUP BY City
HAVING COUNT(*) > 30
ORDER BY CityAvgRating DESC;

-- Best Value Cuisine (Corrected)
SELECT TOP 1
    c.value AS Cuisine,
    (AVG(r.Rating)/NULLIF(AVG(r.Average_Cost_for_two)/1000,0)) AS ValueRatio
FROM [dbo].[Zomato_Dataset_Cleaned] r
CROSS APPLY STRING_SPLIT(r.Cuisines, '|') c
GROUP BY c.value
HAVING COUNT(*) > 10
ORDER BY ValueRatio DESC;

--Table Booking Impact
SELECT 
    (SELECT AVG(Rating) FROM [dbo].[Zomato_Dataset_Cleaned] WHERE Has_Table_booking = 'Yes') -
    (SELECT AVG(Rating) FROM [dbo].[Zomato_Dataset_Cleaned] WHERE Has_Table_booking = 'No') 
    AS RatingBoostFromBooking;



--Competitive Benchmark Leader
SELECT TOP 1
    RestaurantName,
    Rating AS BenchmarkRating
FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Cuisines LIKE '%Seafood%'  -- Replace with target cuisine
ORDER BY Rating DESC;

