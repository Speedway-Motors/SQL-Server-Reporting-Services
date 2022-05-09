-- Find columns with sepcific data types

SELECT 
    c.name 'Column Name',
    t.name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL(i.is_primary_key, 0) 'Primary Key'
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
--WHERE
  --  c.object_id = OBJECT_ID('YourTableName'
ORDER BY    t.name 

SELECT 
    -- need DB name
    tbl.name 'Table', 
    c.name 'FieldName',
    t.name 'DataType'
FROM sys.columns c
    JOIN sys.types t ON c.user_type_id = t.user_type_id
    JOIN sys.tables tbl ON tbl.object_id = c.object_id
WHERE t.name = 'smallmoney'
   