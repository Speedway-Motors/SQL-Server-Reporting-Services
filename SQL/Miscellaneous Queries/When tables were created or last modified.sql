-- When tables were created or last modified
SELECT
     name, object_id, create_date, modify_date
FROM
     sys.tables
order by create_date desc
