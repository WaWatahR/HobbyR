SELECT 
ROW_NUMBER() over (order by latitude) as ID
,[latitude] AS Latitude
,[longitude] AS Longitude
FROM [SDHOperational].[dbo].[geodata]
WHERE [CountryCode]='US'
