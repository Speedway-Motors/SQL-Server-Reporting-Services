-- Tables created based on date - all DBs
SELECT [name] 'TableName'
       ,create_date
       ,modify_date
FROM sys.tables
WHERE create_date > '01/25/2019'
    -- modify_date > '01/25/2019'