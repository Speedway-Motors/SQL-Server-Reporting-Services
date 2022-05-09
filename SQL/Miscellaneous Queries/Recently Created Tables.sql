-- Find recently created tables

-- run on DB you want to check
SELECT
        [name]
       ,create_date
       ,modify_date
FROM        sys.tables
WHERE create_date > '04/01/2013'
   and [name] like 'tbl%'      