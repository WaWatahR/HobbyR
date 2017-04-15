SELECT 
ROW_NUMBER() over (order by latitude) as ID
,[latitude] AS Latitude
,[longitude] AS Longitude
,Region
,RegionCode
FROM [SDHOperational].[dbo].[geodata]
WHERE [CountryCode]='US' AND RegionCode NOT IN ('AS', 'FM', 'MH', 'PW', 'GU', 'MP', 'VI', 'PR', 'AK', 'HI')
