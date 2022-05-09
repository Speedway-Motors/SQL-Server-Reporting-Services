-- Find dependencies on missing objects

/* ONLY WORKS on SQL Sever 2008
   Will show some false positives because if an SMI Reporting object references an
   AfcoReporting object it shows up in the query below 
   because the object name doesn't exist in SMI Reporting.
*/   

SELECT 
TOP (100) PERCENT -- no clue why this line causes more rows to return
    QuoteName(OBJECT_SCHEMA_NAME(referencing_id)) + '.' + QuoteName(OBJECT_NAME(referencing_id)) AS [this sproc or VIEW...],
    ISNULL(QuoteName(referenced_server_name) + '.', '')
    + ISNULL(QuoteName(referenced_database_name) + '.', '')
    + ISNULL(QuoteName(referenced_schema_name) + '.', '')
    + QuoteName(referenced_entity_name) AS [... depends ON this missing entity name]
FROM sys.sql_expression_dependencies
WHERE (is_ambiguous = 0)
    AND (OBJECT_ID(ISNULL(QuoteName(referenced_server_name) + '.', '')
    + ISNULL(QuoteName(referenced_database_name) + '.', '')
    + ISNULL(QuoteName(referenced_schema_name) + '.', '')
    + QuoteName(referenced_entity_name)) IS NULL)
ORDER BY [this sproc or VIEW...],
    [... depends ON this missing entity name]