-- Dupe Indexes with comma delimeted list of fields used
WITH CTE_INDEX_DATA AS (
       SELECT
              SCHEMA_DATA.name AS schema_name,
              TABLE_DATA.name AS table_name,
              INDEX_DATA.name AS index_name,
              STUFF((SELECT  ', ' + CDKC.name
                      FROM    sys.tables AS T
                        INNER JOIN sys.indexes IDKC ON T.object_id = IDKC.object_id -- (INDEX_DATA_KEY_COLS)
                        INNER JOIN sys.index_columns ICDKC ON IDKC.object_id = ICDKC.object_id --(INDEX_COLUMN_DATA_KEY_COLS)
                                                              AND IDKC.index_id = ICDKC.index_id
                        INNER JOIN sys.columns CDKC ON T.object_id = CDKC.object_id -- (COLUMN_DATA_KEY_COLS)
                                                      AND ICDKC.column_id = CDKC.column_id
                      WHERE   INDEX_DATA.object_id = IDKC.object_id
                          AND INDEX_DATA.index_id = IDKC.index_id
                          AND ICDKC.is_included_column = 0
                      ORDER BY ICDKC.key_ordinal
                      FOR XML PATH('')), 1, 2, '') AS key_column_list ,
          STUFF(( SELECT  ', ' + COLUMN_DATA_INC_COLS.name
                   FROM    sys.tables AS T
                   INNER JOIN sys.indexes IDIC ON T.object_id = IDIC.object_id --(INDEX_DATA_INC_COLS)
                   INNER JOIN sys.index_columns CDIC ON IDIC.object_id = CDIC.object_id
                                                        AND IDIC.index_id = CDIC.index_id
                   INNER JOIN sys.columns COLUMN_DATA_INC_COLS ON T.object_id = CDIC.object_id --(COLUMN_DATA_INC_COLS)
                                                                  AND CDIC.column_id = COLUMN_DATA_INC_COLS.column_id
                   WHERE   INDEX_DATA.object_id = IDIC.object_id
                       AND INDEX_DATA.index_id = IDIC.index_id
                       AND CDIC.is_included_column = 1
                   ORDER BY CDIC.key_ordinal
                   FOR XML PATH('')), 1, 2, '') AS include_column_list
       FROM sys.indexes INDEX_DATA
        INNER JOIN sys.tables TABLE_DATA ON TABLE_DATA.object_id = INDEX_DATA.object_id
        INNER JOIN sys.schemas SCHEMA_DATA ON SCHEMA_DATA.schema_id = TABLE_DATA.schema_id
       WHERE TABLE_DATA.is_ms_shipped = 0
        AND INDEX_DATA.type_desc IN ('NONCLUSTERED', 'CLUSTERED')
)
SELECT *
FROM CTE_INDEX_DATA DUPE1
WHERE EXISTS
            (SELECT * FROM CTE_INDEX_DATA DUPE2
             WHERE DUPE1.schema_name = DUPE2.schema_name
                 AND DUPE1.table_name = DUPE2.table_name
                 AND DUPE1.key_column_list = DUPE2.key_column_list
                 AND ISNULL(DUPE1.include_column_list, '') = ISNULL(DUPE2.include_column_list, '')
                 AND DUPE1.index_name <> DUPE2.index_name
             )        
ORDER BY table_name
 

 
 
 
 
 
 
 
 

/**** THESE ARE INDEXES WITH OVERLAPPING FIELDS, 
        NOT NECESSARILY DUPES!!!!! 
        
       May be useful into condensing some overlap if the querries are running low,
       e.g. tblEmployee has an index by Department and another index by Department and Hire Date
            there is a good chance that the first index could be removed, whatever query using it
            would still be ALMOST as fast because it would still bennefit from the 2nd index.
****/                    
 WITH  CTE_INDEX_DATA
        AS ( SELECT SCHEMA_DATA.name AS schema_name
                  , TABLE_DATA.name AS table_name
                  , INDEX_DATA.name AS index_name
                  , STUFF(( SELECT  ', ' + CDKC.name
                            FROM    sys.tables AS T
                                    INNER JOIN sys.indexes IDKC ON T.object_id = IDKC.object_id
                                    INNER JOIN sys.index_columns ICDKC ON IDKC.object_id = ICDKC.object_id
                                                              AND IDKC.index_id = ICDKC.index_id
                                    INNER JOIN sys.columns CDKC ON T.object_id = CDKC.object_id
                                                              AND ICDKC.column_id = CDKC.column_id
                            WHERE   INDEX_DATA.object_id = IDKC.object_id
                                    AND INDEX_DATA.index_id = IDKC.index_id
                                    AND ICDKC.is_included_column = 0
                            ORDER BY ICDKC.key_ordinal
                          FOR
                            XML PATH('')
                          ), 1, 2, '') AS key_column_list
                  , STUFF(( SELECT  ', ' + COLUMN_DATA_INC_COLS.name
                            FROM    sys.tables AS T
                                    INNER JOIN sys.indexes IDIC ON T.object_id = IDIC.object_id
                                    INNER JOIN sys.index_columns CDIC ON IDIC.object_id = CDIC.object_id
                                                              AND IDIC.index_id = CDIC.index_id
                                    INNER JOIN sys.columns COLUMN_DATA_INC_COLS ON T.object_id = COLUMN_DATA_INC_COLS.object_id
                                                              AND CDIC.column_id = COLUMN_DATA_INC_COLS.column_id
                            WHERE   INDEX_DATA.object_id = IDIC.object_id
                                    AND INDEX_DATA.index_id = IDIC.index_id
                                    AND CDIC.is_included_column = 1
                            ORDER BY CDIC.key_ordinal
                          FOR
                            XML PATH('')
                          ), 1, 2, '') AS include_column_list
             FROM   sys.indexes INDEX_DATA
                    INNER JOIN sys.tables TABLE_DATA ON TABLE_DATA.object_id = INDEX_DATA.object_id
                    INNER JOIN sys.schemas SCHEMA_DATA ON SCHEMA_DATA.schema_id = TABLE_DATA.schema_id
             WHERE  TABLE_DATA.is_ms_shipped = 0
                    AND INDEX_DATA.type_desc IN ( 'NONCLUSTERED', 'CLUSTERED' )
           )
  SELECT  *
  FROM    CTE_INDEX_DATA DUPE1
  WHERE   EXISTS ( SELECT *
                   FROM   CTE_INDEX_DATA DUPE2
                   WHERE  DUPE1.schema_name = DUPE2.schema_name
                          AND DUPE1.table_name = DUPE2.table_name
                          AND ( DUPE1.key_column_list LIKE LEFT(DUPE2.key_column_list,
                                                              LEN(DUPE1.key_column_list))
                                OR DUPE2.key_column_list LIKE LEFT(DUPE1.key_column_list,
                                                              LEN(DUPE2.key_column_list))
                              )
                          AND DUPE1.index_name <> DUPE2.index_name )