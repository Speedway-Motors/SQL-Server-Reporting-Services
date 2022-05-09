-- SMIHD-8120 add historical Longacre BOM Usage and SKU qty sold data to MPR report

/* I modified two spreadsheets that Bob McDowell provided for the raw data.  
They each have a list of SKUs.  
One contains 12 months of BOM usage.  The other contains 12 months of Qty Sold.
*/


select top 10 * from PJC_SMIHD8120_LAQtySold LA

-- QTY SOLD temp table.  This data will then be flattened out into the permanent table used by the report.
        SELECT COUNT(LA.ixSKU), COUNT(DISTINCT LA.ixSKU)
        from PJC_SMIHD8120_LAQtySold LA-- 1082	1082
        join [AFCOReporting].dbo.tblSKU S on LA.ixSKU = S.ixSKU -- 947	947

        -- remove SKUs that don't exist in tblSKU 
        SELECT *
        -- DELETE
        FROM PJC_SMIHD8120_LAQtySold 
        WHERE ixSKU NOT IN (Select ixSKU from [AFCOReporting].dbo.tblSKU)


        SELECT * FROM PJC_SMIHD8120_LAQtySold
        



-- QTY SOLD PERMANENT table
-- DROP TABLE [AFCOReporting].dbo.LAHistoricalQtySold
SELECT ixSKU, 
    '06/15/2016' dtOrderDate,
    (CASE WHEN JUN2016 < 0 THEN 0
     ELSE JUN2016
     END) as 'QtySold'
INTO [AFCOReporting].dbo.LAHistoricalQtySold
FROM PJC_SMIHD8120_LAQtySold         
        
     
/*************       VALIDATE the data for the first month      ****************
1)Verify table is formated correctly
2) pick a random assortment to check validate numbers 
        (be sure to look up some negative values to make sure they show as 0
3) Write a UNION query to add to recent qty sold from tblOrderLine and verify combined totals match expected
4) after validation checks are complete, write the insert statements for the remaining 11 months.
        HAVE SOMEONE REVIEW THE QUERIES TO MAKE SURE DATE CONDITIONS ARE ACCUARATE BEFORE RUNNING THEM!
*/        
        -- 1)Verify table is formated correctly
        SELECT * FROM [AFCOReporting].dbo.LAHistoricalQtySold   
        WHERE dtOrderDate between '06/15/2016'
        
        -- 2) pick a random assortment to check validate numbers 
        SELECT SUM(iQuantity) 'QTYSold' FROM [AFCOReporting].dbo.tblOrderLine where ixSKU = '52-11000' -- 1301

        SELECT SUM(QtySold) 'QTYSold' FROM [AFCOReporting].dbo.LAHistoricalQtySold  where ixSKU = '52-11000' -- 301

        -- 3) Write a UNION query to add to recent qty sold from tblOrderLine and verify combined totals match expected
        SELECT SUM(QTYSold) FROM -- 1602
                        (
                        SELECT SUM(iQuantity) AS 'QTYSold' FROM [AFCOReporting].dbo.tblOrderLine where ixSKU = '52-11000' 
                        UNION
                        SELECT SUM(QtySold) AS 'QTYSold' FROM [AFCOReporting].dbo.LAHistoricalQtySold  where ixSKU = '52-11000' 
                        ) x


    -- 4) ADD REMAINING MONTHS
        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '07/15/2016' dtOrderDate,
            (CASE WHEN JUL2016 < 0 THEN 0
             ELSE JUL2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '08/15/2016' dtOrderDate,
            (CASE WHEN AUG2016 < 0 THEN 0
             ELSE AUG2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '09/15/2016' dtOrderDate,
            (CASE WHEN SEP2016 < 0 THEN 0
             ELSE SEP2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '10/15/2016' dtOrderDate,
            (CASE WHEN OCT2016 < 0 THEN 0
             ELSE OCT2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '11/15/2016' dtOrderDate,
            (CASE WHEN NOV2016 < 0 THEN 0
             ELSE NOV2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '12/15/2016' dtOrderDate,
            (CASE WHEN DEC2016 < 0 THEN 0
             ELSE DEC2016
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '01/15/2017' dtOrderDate,
            (CASE WHEN JAN2017 < 0 THEN 0
             ELSE JAN2017
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '02/15/2017' dtOrderDate,
            (CASE WHEN FEB2017 < 0 THEN 0
             ELSE FEB2017
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '03/15/2017' dtOrderDate,
            (CASE WHEN MAR2017 < 0 THEN 0
             ELSE MAR2017
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '04/15/2017' dtOrderDate,
            (CASE WHEN APR2017 < 0 THEN 0
             ELSE APR2017
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalQtySold
        SELECT ixSKU, 
            '05/15/2017' dtOrderDate,
            (CASE WHEN MAY2017 < 0 THEN 0
             ELSE MAY2017
             END) as 'QtySold'
        FROM PJC_SMIHD8120_LAQtySold 




-- verify no negative values
SELECT * FROM [AFCOReporting].dbo.LAHistoricalQtySold WHERE QtySold < 0


-- final checks

-- verify final # of rows
SELECT COUNT(*) FROM [AFCOReporting].dbo.LAHistoricalQtySold -- 11364 v (total SKUs * toal months   947*12  )

SELECT ixSKU, COUNT(*) 'RowsPerSKU'
FROM [AFCOReporting].dbo.LAHistoricalQtySold -- each SKU has 12 rows
GROUP BY ixSKU
ORDER BY COUNT(*) 

SELECT dtOrderDate, COUNT(*) 'RowsPerSKU'
FROM [AFCOReporting].dbo.LAHistoricalQtySold -- each SKU has 12 rows
GROUP BY dtOrderDate
ORDER BY dtOrderDate
/*
dtOrderDate	RowsPerSKU
01/15/2017	947
02/15/2017	947
03/15/2017	947
04/15/2017	947
05/15/2017	947
06/15/2016	947
07/15/2016	947
08/15/2016	947
09/15/2016	947
10/15/2016	947
11/15/2016	947
12/15/2016	947
*/

-- Random Test SKUs
SELECT top 3 ixSKU from  [AFCOReporting].dbo.LAHistoricalQtySold order by newID()
52-50556
52-3206023
52-45900

SELECT ixSKU, SUM(QtySold) 'TotQtySold'
from [AFCOReporting].dbo.LAHistoricalQtySold
WHERE ixSKU in ('52-50556','52-3206023','52-45900','52-11821'
)
GROUP BY ixSKU
order by ixSKU
/*          Tot
ixSKU	    QtySold
52-3206023	1       v
52-45900	374     v   -- all totals match the some of their monthly columns in the origianl spreadsheet
52-50556	118     v
52-11821    22221   v

*/



SELECT * FROM [AFCOReporting].dbo.LAHistoricalQtySold
ORDER BY QtySold




/***************************   BOM USAGE    *******************************/
-- DROP TABLE PJC_SMIHD8120_LABOMUsage
select top 10 * from PJC_SMIHD8120_LABOMUsage

-- QTY SOLD temp table.  This data will then be flattened out into the permanent table used by the report.
        SELECT COUNT(BU.ixSKU), COUNT(DISTINCT BU.ixSKU)
        from  PJC_SMIHD8120_LABOMUsage BU-- 2109	2109
        join [AFCOReporting].dbo.tblSKU S on BU.ixSKU = S.ixSKU 

        -- remove SKUs that don't exist in tblSKU 
        SELECT *
        -- DELETE
        FROM PJC_SMIHD8120_LABOMUsage 
        WHERE ixSKU NOT IN (Select ixSKU from [AFCOReporting].dbo.tblSKU)


        SELECT ixSKU, COUNT(*)
        from  PJC_SMIHD8120_LABOMUsage BU-- 2165	2159
        group by ixSKU
        having COUNT(*) > 1
        
        

-- QTY SOLD PERMANENT table
-- DROP TABLE [AFCOReporting].dbo.LAHistoricalBOMUsage
SELECT ixSKU, 
    '06/15/2016' dtOrderDate,
    (CASE WHEN JUN2016 < 0 THEN 0
     ELSE JUN2016
     END) as 'BOMUsage'
INTO [AFCOReporting].dbo.LAHistoricalBOMUsage -- 2109
FROM PJC_SMIHD8120_LABOMUsage  


--ADD REMAINING MONTHS
        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '07/15/2016' dtOrderDate,
            (CASE WHEN JUL2016 < 0 THEN 0
             ELSE JUL2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '08/15/2016' dtOrderDate,
            (CASE WHEN AUG2016 < 0 THEN 0
             ELSE AUG2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '09/15/2016' dtOrderDate,
            (CASE WHEN SEP2016 < 0 THEN 0
             ELSE SEP2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '10/15/2016' dtOrderDate,
            (CASE WHEN OCT2016 < 0 THEN 0
             ELSE OCT2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '11/15/2016' dtOrderDate,
            (CASE WHEN NOV2016 < 0 THEN 0
             ELSE NOV2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '12/15/2016' dtOrderDate,
            (CASE WHEN DEC2016 < 0 THEN 0
             ELSE DEC2016
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '01/15/2017' dtOrderDate,
            (CASE WHEN JAN2017 < 0 THEN 0
             ELSE JAN2017
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '02/15/2017' dtOrderDate,
            (CASE WHEN FEB2017 < 0 THEN 0
             ELSE FEB2017
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '03/15/2017' dtOrderDate,
            (CASE WHEN MAR2017 < 0 THEN 0
             ELSE MAR2017
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '04/15/2017' dtOrderDate,
            (CASE WHEN APR2017 < 0 THEN 0
             ELSE APR2017
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage 

        GO

        INSERT INTO [AFCOReporting].dbo.LAHistoricalBOMUsage
        SELECT ixSKU, 
            '05/15/2017' dtOrderDate,
            (CASE WHEN MAY2017 < 0 THEN 0
             ELSE MAY2017
             END) as 'BOMUsage'
        FROM PJC_SMIHD8120_LABOMUsage        
        
        
-- verify no negative values
SELECT * FROM [AFCOReporting].dbo.LAHistoricalBOMUsage WHERE BOMUsage < 0


-- final checks

-- verify final # of rows
SELECT COUNT(*) FROM [AFCOReporting].dbo.LAHistoricalBOMUsage -- 25308 v (total SKUs * toal months   2109*12  )

SELECT ixSKU, COUNT(*) 'RowsPerSKU'
FROM [AFCOReporting].dbo.LAHistoricalBOMUsage -- each SKU has 12 rows
GROUP BY ixSKU
ORDER BY COUNT(*) 

SELECT dtDate, COUNT(*) 'RowsPerSKU'
FROM [AFCOReporting].dbo.LAHistoricalBOMUsage -- each SKU has 12 rows
GROUP BY dtDate
ORDER BY dtDate
/*
dtOrderDate	RowsPerSKU
01/15/2017	2109
02/15/2017	2109
03/15/2017	2109
04/15/2017	2109
05/15/2017	2109
06/15/2016	2109
07/15/2016	2109
08/15/2016	2109
09/15/2016	2109
10/15/2016	2109
11/15/2016	2109
12/15/2016	2109
*/

-- Random Test SKUs
SELECT top 3 ixSKU from  [AFCOReporting].dbo.LAHistoricalBOMUsage order by newID()
52-902294
52-904742
52-901199

SELECT ixSKU, SUM(BOMUsage) 'TotBOMUsage'
from [AFCOReporting].dbo.LAHistoricalBOMUsage
WHERE ixSKU in ('52-902294','52-904742','52-901199','52-905741')
GROUP BY ixSKU
order by ixSKU
/*          Tot
ixSKU	    BOMUsage
52-901199	934
52-902294	1410        -- verified table totals = sum of spreadsheet columns
52-904742	30
52-905741 	71909
*/

SELECT * FROM [AFCOReporting].dbo.LAHistoricalBOMUsage
ORDER BY BOMUsage


        