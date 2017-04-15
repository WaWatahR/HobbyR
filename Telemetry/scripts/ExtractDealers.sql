SELECT [CustomerID]
,[Name]
,[Address1]
,[City]
,[Latitude]
,[Longitude]
FROM [SDHOperational].[Master].[Customer] c
INNER JOIN [SDHOperational].[Master].[CustomerType] ct 
ON c.CustomerTypeId = ct.CustomerTypeId AND ct.CustomerTypeCode='DI'
WHERE Latitude IS NOT NULL AND Latitude<>0 AND [CustomerStatusId]=1
