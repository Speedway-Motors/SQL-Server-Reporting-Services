-- Find all tables with specified column name
SELECT c.name  AS 'ColumnName'
    ,t.name AS 'TableName'
FROM sys.columns c
JOIN sys.tables  t   ON c.object_id = t.object_id
WHERE UPPER(c.name) = 'IXORDER'
   -- AND c.name NOT IN ('sVendorSKU','mVendorFee','ixVendorConfirmDate','ixVendorConfirmEmployee','sVendorOnReport','PrimaryVendor','SecondaryVendor')   
ORDER BY TableName,ColumnName



