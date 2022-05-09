-- FK research for SKU fields

SELECT t.name AS table_name,
--SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
FROM sys.tables AS t
    INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
WHERE upper(c.name) LIKE '%SKU%'
ORDER BY c.name, table_name;
-- results in SQL "DB - Data Dictionary.xlsx"


-- LIST ALL FOREIGN KEYS to specified table
SELECT f.name AS ForeignKey,
    OBJECT_NAME(f.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id,
    fc.parent_column_id) AS ColumnName,
    OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName,
    COL_NAME(fc.referenced_object_id,
    fc.referenced_column_id) AS ReferenceColumnName
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc
ON f.OBJECT_ID = fc.constraint_object_id
WHERE OBJECT_NAME (f.referenced_object_id) = 'tblSKU'


SELECT * 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) LIKE '%CREAT%' )
ORDER BY name

SELECT * FROM syscolumns WHERE upper(name) LIKE '%IXSKU'


/**** SKU FIELDS WITH NO CURRENT FK *********/

    -- 100% in table SKU
    select * from tblBinSku where ixSKU NOT in (select ixSKU from tblSKU)               -- SMI = 0      AFCO = 0
    select * from tblBOMTemplateDetail where ixSKU NOT in (select ixSKU from tblSKU)    -- SMI = 0      AFCO = 4
    select * from tblDropship where ixSKU NOT in (select ixSKU from tblSKU)             -- SMI = 0      AFCO = 1499
    select * from tblInventoryForecast where ixSKU NOT in (select ixSKU from tblSKU)    -- SMI = 0      AFCO = ?    collation conflict
    select * from tblInventoryReceipt where ixSKU NOT in (select ixSKU from tblSKU)     -- SMI = 0      AFCO = 2230
    select * from tblJobClock where ixSKU NOT in (select ixSKU from tblSKU)             -- SMI = 0      AFCO = ?    collation conflict
    select * from tblPromotionalInventory where ixSKU NOT in (select ixSKU from tblSKU) -- SMI = 0      AFCO = 2738
    select * from tblSKUIndex where ixSKU NOT in (select ixSKU from tblSKU)             -- SMI = 0      AFCO = ?    collation conflict
    select * from tblSKULocation where ixSKU NOT in (select ixSKU from tblSKU)          -- SMI = 0      AFCO = ?    collation conflict
    select * from tblSKUPromo where ixSKU NOT in (select ixSKU from tblSKU)             -- SMI = 0      AFCO = N/A
    select * from tblVelocity60 where ixSKU NOT in (select ixSKU from tblSKU)           -- SMI = 0      AFCO = ?
    select * from tblVendorSKU where ixSKU NOT in (select ixSKU from tblSKU)            -- SMI = 0      AFCO = 501
    select * from tblFIFODetail where ixSKU NOT in (select ixSKU from tblSKU)           -- SMI = 0      AFCO = ?    collation conflict


-- SOME SKUs not in tblSKU
    select distinct ixSKU from tblBOMTransferDetail where ixSKU NOT in (select ixSKU from tblSKU) -- 22 missing
    union all
    select distinct ixSKU  from tblCatalogDetail where ixSKU NOT in (select ixSKU from tblSKU) -- 6
    union all
    select distinct ixSKU  from tblCreditMemoDetail where ixSKU NOT in (select ixSKU from tblSKU) -- 1
    union all
    select distinct ixSKU   from tblKit where ixSKU NOT in (select ixSKU from tblSKU) -- 41
    union all
    select distinct ixSKU   from tblOrderLine where ixSKU NOT in (select ixSKU from tblSKU) -- 3240
    union all
    select distinct ixSKU   from tblPODetail where ixSKU NOT in (select ixSKU from tblSKU) -- 2535
    union all
    select distinct ixSKU   from tblSnapAdjustedMonthlySKUSales where ixSKU NOT in (select ixSKU from tblSKU) -- 1232
    union all
    select distinct ixSKU   from tblSnapAdjustedMonthlySKUSalesNEW where ixSKU NOT in (select ixSKU from tblSKU) -- 1232
    union all
    select distinct ixSKU   from tblSKUTransaction where ixSKU NOT in (select ixSKU from tblSKU) -- 812 @1min
    union all
    select distinct ixSKU   from tblSnapshotSKU where ixSKU NOT in (select ixSKU from tblSKU) -- 1


