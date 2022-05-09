-- Find all fields with a specific data type
select * from 
INFORMATION_SCHEMA.COLUMNS 
where DATA_TYPE = 'smallmoney'
order by TABLE_NAME

                    