select AT.*,
       NW.RowsNow,
 --      Q1.Rows3Mo,    
 --      Q2.Rows6Mo,
 --      Q3.Rows9Mo,
       Q4.Rows12Mo,
       NW.MBNow,
 --      Q1.MB3Mo,
 --      Q2.MB6Mo, 
 --      Q3.MB9Mo,   
       Q4.MB12Mo               
       from 
    (-- All tables from from last 12 Mo.
     select distinct sTableName
     from  tblTableSizeLog
     where dtDate >=   DATEADD(yy, -1, getdate()) -- 1 year ago       93 @6-27-2013
     ) AT
FULL Outer join      
    (-- NOW
     select sTableName , dtDate,
            sRowCount as 'RowsNow',
            MB  as 'MBNow'
    from tblTableSizeLog
    where dtDate = CONVERT(VARCHAR(10),DATEADD(dd,-0, getdate()),101)        -- 3 months ago
    ) NW on NW.sTableName = AT.sTableName     
FULL Outer join      
    (select sTableName , dtDate,
            sRowCount as 'Rows3Mo',
            MB  as 'MB3Mo'
          --  dtDate as 'QTR1'
    from tblTableSizeLog
    where dtDate = CONVERT(VARCHAR(10),DATEADD(MM,-3, getdate()),101)        -- 3 months ago
    --and MB > = 10
    ) Q1 on Q1.sTableName = AT.sTableName
FULL Outer join 
    (select sTableName,
        sRowCount as 'Rows6Mo',
        MB  as 'MB6Mo'
    from tblTableSizeLog
    where dtDate = CONVERT(VARCHAR(10),DATEADD(MM,-6, getdate()),101)        -- 6 months ago
    ) Q2 on AT.sTableName = Q2.sTableName
FULL Outer join 
    (select sTableName,
        sRowCount as 'Rows9Mo',
        MB  as 'MB9Mo'
    from tblTableSizeLog
    where dtDate = CONVERT(VARCHAR(10),DATEADD(MM,-9, getdate()),101)        -- 6 months ago
    ) Q3 on AT.sTableName = Q3.sTableName
FULL Outer join 
    (select sTableName,
        sRowCount as 'Rows12Mo',
        MB  as 'MB12Mo'
    from tblTableSizeLog
    where dtDate = CONVERT(VARCHAR(10),DATEADD(MM,-12, getdate()),101)        -- 6 months ago
    ) Q4 on AT.sTableName = Q4.sTableName
WHERE NW.RowsNow is NOT NULL    
ORDER BY MBNow desc, AT.sTableName
    


