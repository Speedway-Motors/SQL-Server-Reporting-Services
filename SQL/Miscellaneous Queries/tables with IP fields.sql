-- tables with IP fields
SELECT sysobjects.name  as TableName,
    syscolumns.name     as ColumnName,
    systypes.name       as DataType,
    syscolumns.[Length] as [Length]
FROM sysobjects 
    INNER JOIN syscolumns ON sysobjects.[Id] = syscolumns.[Id]
    INNER JOIN systypes   ON systypes.[xtype] = syscolumns.[xtype]
WHERE sysobjects.[type] = 'U' 
    AND systypes.name <> 'sysname'
    AND sysobjects.name LIKE 'tbl%'
    AND (syscolumns.name) like '%IP%' 



