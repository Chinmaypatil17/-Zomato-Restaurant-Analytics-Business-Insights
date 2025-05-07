
select * from [dbo].[Zomato_Dataset_Cleaned]
use zomato_db;

select COLUMN_NAME ,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ZOmato_Dataset_cleaned';


UPDATE [dbo].[Zomato_Dataset_Cleaned] 
SET Rating =ROUND(Rating,1);


UPDATE [dbo].[Zomato_Dataset_Cleaned]
SET
    RestaurantName = REPLACE(RestaurantName, '?', ''),
    City = REPLACE(City, '?', ''),
    Locality = REPLACE(Locality, '?', ''),
    LocalityVerbose = REPLACE(LocalityVerbose, '?', ''),
    Cuisines = REPLACE(Cuisines, '?', ''),
    Address = REPLACE(Address, '?', ''),
    CountryCode = REPLACE(CountryCode, '?', '');

UPDATE [dbo].[Zomato_Dataset_Cleaned]
	SET RestaurantName = REPLACE( REPLACE( REPLACE(RestaurantName, '-', ' '), '+', ' ' ), '  ', ' ' ),
	City = REplace(City,'/',' '),
	Cuisines = REPLACE(Cuisines,'|',' ')


UPDATE [dbo].[Zomato_Dataset_Cleaned]
	set
		RestaurantName = LTRIM(RTRIM(RestaurantName)),
    City = LTRIM(RTRIM(City)),
    Locality = LTRIM(RTRIM(Locality)),
    LocalityVerbose = LTRIM(RTRIM(LocalityVerbose)),
    Cuisines = LTRIM(RTRIM(Cuisines)),
    Address = LTRIM(RTRIM(Address));

select distinct Currency from [dbo].[Zomato_Dataset_Cleaned]

UPDATE [dbo].[Zomato_Dataset_Cleaned]
SET Currency = CASE
    WHEN Currency LIKE '%Indonesian Rupiah%' THEN 'IDR'
    WHEN Currency LIKE '%NewZealand($)%' THEN 'NZD'
    WHEN Currency LIKE '%Dollar($)%' THEN 'USD'
    WHEN Currency LIKE '%Pounds(?)%' THEN 'GBP'
    WHEN Currency LIKE '%Brazilian Real(R$)%' THEN 'BRL'
    WHEN Currency LIKE '%Qatari Rial(QR)%' THEN 'QAR'
    WHEN Currency LIKE '%Botswana Pula(P)%' THEN 'BWP'
    WHEN Currency LIKE '%Turkish Lira(TL)%' THEN 'TRY'
    WHEN Currency LIKE '%Rand(R)%' THEN 'ZAR'
    WHEN Currency LIKE '%Indian Rupees(Rs.)%' THEN 'INR'
    WHEN Currency LIKE '%Sri Lankan Rupee(LKR)%' THEN 'LKR'
    WHEN Currency LIKE '%Emirati Diram(AED)%' THEN 'AED'
    ELSE Currency
END;


select * 
from [dbo].[Zomato_Dataset_Cleaned]
WHERE
RestaurantID IS NULL or
RestaurantName IS NULL or
CountryCode IS NULL or
City IS NULL or
Address IS NULL or
Locality IS NULL or
LocalityVerbose IS NULL or
Cuisines IS NULL or
Currency IS NULL or
Has_Table_booking IS NULL or
Has_Online_delivery IS NULL or
Is_delivering_now IS NULL or
Switch_to_order_menu IS NULL or
Price_range IS NULL or
Votes IS NULL or
Average_Cost_for_two IS NULL or
Rating IS NULL ;

DELETE FROM [dbo].[Zomato_Dataset_Cleaned]
WHERE Cuisines IS NULL;

WITH DUPLICATES AS(
	select *,
		ROW_NUMBER() OVER
		(PARTITION BY RestaurantName, Address, city Order by RestaurantID) 
		As ROWNUM
		FROM [dbo].[Zomato_Dataset_Cleaned]
)
select * 
from DUPLICATES
where ROWNUM >1 ;

WITH DUPLICATES AS(
	select *,
ROW_NUMBER() OVER (
  PARTITION BY 
    RestaurantName, CountryCode, City, Address, Locality, 
    LocalityVerbose, Cuisines, Currency, Has_Table_booking, 
    Has_Online_delivery, Is_delivering_now, Switch_to_order_menu, 
    Price_range, Votes, Average_Cost_for_two, Rating
  ORDER BY RestaurantID
) AS RowNum
FROM [dbo].[Zomato_Dataset_Cleaned]
)
select * 
from DUPLICATES
where ROWNUM >1 ;

SELECT TOP 1 * FROM [dbo].[Zomato_Dataset_Cleaned];

INSERT INTO [dbo].[Zomato_Dataset_Cleaned] (
    RestaurantID, RestaurantName, CountryCode, City, Address,
    Locality, LocalityVerbose, Cuisines, Currency,
    Has_Table_booking, Has_Online_delivery, Is_delivering_now,
    Switch_to_order_menu, Price_range, Votes,
    Average_Cost_for_two, Rating
)
VALUES (
    6317637, 'Le Petit Souffle', 162, 'Makati City',
    'Third Floor| Century City Mall| Kalayaan Avenue| Poblacion| Makati City',
    'Century City Mall| Poblacion| Makati City',
    'Century City Mall| Poblacion| Makati City| Makati City',
    'French| Japanese| Desserts', 'BWP',
    'Yes', 'No', 'No', 'No',
    3, 314, 1100, 4.8
);

WITH Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY RestaurantName, CountryCode, City, Address, Locality, LocalityVerbose,
                            Cuisines, Currency, Has_Table_booking, Has_Online_delivery, Is_delivering_now,
                            Switch_to_order_menu, Price_range, Votes, Average_Cost_for_two, Rating
               ORDER BY RestaurantID
           ) AS RowNum
    FROM [dbo].[Zomato_Dataset_Cleaned]
)
DELETE FROM Duplicates
WHERE RowNum > 1;

WITH DUPLICATES AS(
	select *,
		ROW_NUMBER() OVER
		(PARTITION BY RestaurantID) 
		As ROWNUM
		FROM [dbo].[Zomato_Dataset_Cleaned]
)
select * 
from DUPLICATES
where ROWNUM >1 ;

ALTER TABLE [dbo].[Zomato_Dataset_Cleaned]
ALTER COLUMN RestaurantID INT NOT NULL;

ALTER TABLE [dbo].[Zomato_Dataset_Cleaned]
ADD CONSTRAINT CK_AVERAGE_COST_FOR_TWO CHECK ([Average_Cost_for_two] >=0);

SELECT *
FROM dbo.Zomato_Dataset_Cleaned
WHERE Rating IS NULL OR Rating < 0 OR Rating > 5;
