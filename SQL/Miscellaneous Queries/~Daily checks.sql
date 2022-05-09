-- Daily checks

/****************** ORPHANED SKUs (SKUs deleted FROM SOP) ******************/
-- 1) RUN
-- 2) REFEED LIST
-- 3) RE-RUN and look for SKUs that did not update
-- 4) Open ~Daily checks.sql to flag SKUs that have been deleted

-- RECENTLY DELETED SKUS
        -- DELETED BY
    SELECT DISTINCT ST.ixSKU
        , FORMAT(D.dtDate,'yyyy.MM.dd') 'DELETED' , T.chTime 'DELETEDTime', SKU.ixCreator, 
         ST.sTransactionType, ST.sUser 'DeletedBy', E.sFirstname, E.sLastname, ST.sLocation, SKU.flgDeletedFromSOP, SKU.dtDateLastSOPUpdate
    FROM tblSKUTransaction ST
        left join tblDate D on ST.ixDate = D.ixDate
        left join tblEmployee E on ST.sUser = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
        left join tblSKU SKU on SKU.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
        left join tblTime T on T.ixTime = ST.ixTime
    WHERE ST.ixDate >=19840 --	04/26/2022 all DELETED SKUs have been checked prior to this date
    -- ST.ixSKU in ('91088024-99','67404604')
        and ST.sTransactionType = 'DELETE'
        and ST.sLocation = 99
        and SKU.flgDeletedFromSOP = 0
    --ORDER BY ixSKU, D.ixDate desc, ST.ixTime desc


-- alternate check 1
        SELECT DISTINCT S.ixSKU, S.flgDeletedFromSOP,
            FORMAT(S.dtCreateDate,'yyyy.MM.dd') 'CREATED', 
            FORMAT(D.dtDate,'yyyy.MM.dd') 'DELETED', 
            FORMAT(S.dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate',
            S.ixTimeLastSOPUpdate
        FROM tblSKU S
            left join tblSKUTransaction ST on S.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblDate D on ST.ixDate = D.ixDate
        WHERE S.flgDeletedFromSOP = 0
            and ST.sTransactionType = 'DELETE'
            and D.dtDate >= S.dtCreateDate -- DELETE > CREATE
            and S.dtDateLastSOPUpdate < FORMAT(getdate(),'MM/dd/yyyy') -- excludes any fed today
        ORDER BY S.ixSKU --'LastSOPUpdate', S.ixTimeLastSOPUpdate


-- alternate check 2
        SELECT ST.ixSKU, D.dtDate, T.chTime 'DELETEDTime', SKU.ixCreator, ST.sTransactionType, ST.sUser, ST.sLocation, E.sFirstname, E.sLastname
        FROM tblSKUTransaction ST
            left join tblDate D on ST.ixDate = D.ixDate
            left join tblEmployee E on ST.sUser = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblSKU SKU on SKU.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblTime T on T.ixTime = ST.ixTime
            left join (-- last in tblSnapshotSKU
                        SELECT ixSKU, MAX(D.dtDate) 'MostRecentUpdate' 
                        FROM tblSnapshotSKU SKU         
                            join tblDate D on SKU.ixDate = D.ixDate
                        GROUP BY ixSKU
                        ) SS on SKU.ixSKU = SS.ixSKU
        WHERE SKU.flgDeletedFromSOP = 0
            and ST.sTransactionType = 'DELETE'
            and ST.sLocation = 99
            and SS.MostRecentUpdate <= D.dtDate -- hasn't updated since DELETE date
        ORDER BY ixSKU, D.ixDate desc, ST.ixTime desc


-- SKUs not in current snapshot and not flagged as deleted FROM SOP
SELECT DISTINCT S.ixSKU, S.dtDateLastSOPUpdate
FROM tblSKU S 
    left JOIN tblSnapshotSKU SN on SN.ixSKU = S.ixSKU 
                                and SN.ixDate = 19168 -- <- Latest Snapshot Date
WHERE SN.ixSKU is NULL
    and S.flgDeletedFromSOP = 0
    and S.dtCreateDate < '01/25/2022' -- CURRENT DAY
    and S.dtDateLastSOPUpdate < '01/25/2022' -- CURRENT DAY    
ORDER BY S.dtDateLastSOPUpdate 

-- AFCO
SELECT DISTINCT S.ixSKU, S.dtDateLastSOPUpdate
FROM tblSKU S 
    left JOIN tblSnapshotSKU SN 
                    on SN.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                       and SN.ixDate = 18677 -- <- Latest Snapshot Date
WHERE SN.ixSKU is NULL
    and S.flgDeletedFromSOP = 0
    and S.dtCreateDate < '02/18/2019' -- CURRENT DAY
    and S.dtDateLastSOPUpdate < '02/18/2019' -- CURRENT DAY     
ORDER BY  S.dtDateLastSOPUpdate 




/******** USING hard-coded list of SKUs ***********/
        -- GLOBALLY REPLACE manual list below for SKUs to check/update
        ('91088024-99','67404604')
		

        -- LATEST updates and current status
        SELECT SS.ixSKU,  
        FORMAT(MAX(D.dtDate),'yyyy.MM.dd') 'Last_SS_UD',
        FORMAT(S.dtDateLastSOPUpdate,'yyyy.MM.dd') 'Last_tblSKU_UD', S.ixTimeLastSOPUpdate 'TimeLast_tblSKU_UD',
        FORMAT(S.dtCreateDate,'yyyy.MM.dd') 'Created', S.ixCreator,
        S.flgDeletedFromSOP, S.flgActive   
        FROM tblSnapshotSKU SS         
            left join tblDate D on SS.ixDate = D.ixDate
            left join tblSKU S on SS.ixSKU = S.ixSKU
        WHERE SS.ixSKU in   ('91088024-99','67404604')
        GROUP BY SS.ixSKU, S.dtCreateDate, S.flgDeletedFromSOP, S.flgActive, S.ixCreator,  S.dtDateLastSOPUpdate, S.ixTimeLastSOPUpdate 
        ORDER BY MAX(D.dtDate) 


        -- ORDERLINE  
        SELECT OL.* FROM tblOrderLine OL 
        WHERE   ixOrder NOT LIKE 'PC%' 
            and ixOrder NOT LIKE 'Q%'
            and ixSKU IN ('91088024-99','67404604')
        Order by dtOrderDate desc
        
         -- SKU DELETED BY
        SELECT ST.ixSKU, FORMAT(D.dtDate,'yyyy.MM.dd') 'DELETED' , T.chTime 'DELETEDTime', SKU.ixCreator, 
            ST.sTransactionType, ST.sUser 'DeletedBy', E.sFirstname, E.sLastname, ST.sLocation, SKU.dtDateLastSOPUpdate, SKU.flgDeletedFromSOP
        FROM tblSKUTransaction ST
            left join tblDate D on ST.ixDate = D.ixDate
            left join tblEmployee E on ST.sUser = E.ixEmployee-- COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblSKU SKU on SKU.ixSKU = ST.ixSKU-- COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblTime T on T.ixTime = ST.ixTime
        WHERE --ST.ixDate >= 19822--	04/8/2022
			ST.ixSKU in ('91088024-99','67404604')
           and ST.sTransactionType = 'DELETE'
           and ST.sLocation = 99
		   and SKU.flgDeletedFromSOP = 0
        ORDER BY ixSKU, D.ixDate desc, ST.ixTime desc

-- select * from tblTime where ixTime = 35313

        
        -- set flag to DELETED
            BEGIN TRAN
                    --UPDATE [LNK-DWSTAGING1].[SMI Reporting].dbo.tblSKU  -- ONLY execute ON DWStaging1
                    UPDATE tblSKU  -- ONLY execute ON DWStaging1
                    set flgDeletedFromSOP = 1, 
                        flgActive = 0 
                    WHERE ixSKU IN 
                     ('91088024-99','67404604')
            ROLLBACK TRAN
    
            -- verify status updated
            SELECT ixSKU, flgDeletedFromSOP
            from tblSKU
            where ixSKU in ('91088024-99','67404604')
            order by ixSKU
   

        -- deleted SKUs still flagged as active 
        SELECT * FROM tblSKU WHERE flgActive = 1  and flgDeletedFromSOP = 1   -- 0 as of 09/29/2021
             
        BEGIN TRAN
                -- update LNK-SQL-LIVE-1 ONLY!
                UPDATE tblSKU
                set flgActive = 0
                WHERE flgActive = 1 -- only the SKUs currently misflagged
                    and flgDeletedFromSOP = 1  
        ROLLBACK TRAN
            



/******** USING list of SKUs loaded into PJC_Deleted_SKUs ***********/

    Select COUNT(*) FROM [SMITemp].dbo.PJC_Deleted_SKUs

-- TRUNCATE TABLE [SMITemp].dbo.PJC_Deleted_SKUs
-- INSERT into [SMITemp].dbo.PJC_Deleted_SKUs
SELECT top 5000 ixSKU           -- refeeding 5,000 took 1,661 sec = 3.70 rec/sec      
FROM tblSKU                     -- refeeding 5,000 took 1,661 sec = 3.54 rec/sec       Start 12:26:36 to 12:50:07 
WHERE flgDeletedFromSOP = 0     -- refeeding 5,000 took 1,661 sec = 3.70 rec/sec       Start 14:00:00 to 14:22:32
and dtDateLastSOPUpdate < '01/01/2016' -- make sure this only returns SKUs that won't refeed manually!
ORDER BY ixSKU
   
    Select DEL.ixSKU, SKU.dtDateLastSOPUpdate
        FROM [SMITemp].dbo.PJC_Deleted_SKUs DEL
            JOIN tblSKU SKU on SKU.ixSKU COLLATE Latin1_General_CS_AS = DEL.ixSKU COLLATE Latin1_General_CS_AS
    ORDER BY SKU.dtDateLastSOPUpdate
    
        -- LATEST date in tblSnapshotSKU
            -- SELECT count(*) FROM [SMITemp].dbo.PJC_Deleted_SKUs -- 367
            -- TRUNCATE TABLE [SMITemp].dbo.PJC_Deleted_SKUs
        Select SKU.ixSKU, MAX(D.dtDate) 'MostRecentUpdate'
        FROM [SMITemp].dbo.PJC_Deleted_SKUs DEL 
            JOIN tblSnapshotSKU SKU on SKU.ixSKU COLLATE Latin1_General_CS_AS = DEL.ixSKU COLLATE Latin1_General_CS_AS
            JOIN tblDate D on SKU.ixDate = D.ixDate
        group by SKU.ixSKU

        Select MAX(ixDate) FROM tblSnapshotSKU SKU

        -- VENDOR info                                           
        SELECT VS.* FROM tblVendorSKU VS
            join  [SMITemp].dbo.PJC_Deleted_SKUs DEL on VS.ixSKU COLLATE Latin1_General_CS_AS = DEL.ixSKU COLLATE Latin1_General_CS_AS

        -- ORDERLINE  
        SELECT OL.* FROM tblOrderLine OL 
            join  [SMITemp].dbo.PJC_Deleted_SKUs DEL on OL.ixSKU COLLATE Latin1_General_CS_AS = DEL.ixSKU COLLATE Latin1_General_CS_AS
        WHERE ixOrder NOT LIKE 'PC%' 
         and ixOrder NOT LIKE 'Q%'
         
        -- CURRENT STATUS
        SELECT SKU.ixSKU, SKU.flgDeletedFromSOP, SKU.flgActive, SKU.dtCreateDate
        FROM tblSKU SKU
           join  [SMITemp].dbo.PJC_Deleted_SKUs DEL on SKU.ixSKU COLLATE Latin1_General_CS_AS = DEL.ixSKU COLLATE Latin1_General_CS_AS

               
        -- set flag to DELETED
        -- ONLY ON DWSTAGING1 or Replication will break!!!!
  --    UPDATE tblSKU
        set flgDeletedFromSOP = 1, 
            flgActive = 0 
        FROM tblSKU 
       -- WHERE ixSKU COLLATE Latin1_General_CS_AS IN (SELECT ixSKU COLLATE Latin1_General_CS_AS FROM [SMITemp].dbo.PJC_Deleted_SKUs)
        WHERE ixSKU in (SELECT ixSKU FROM [SMITemp].dbo.PJC_Deleted_SKUs)
        
        
     -- UPDATE tblSKU
        set flgActive = 0
        WHERE flgActive = 1 and flgDeletedFromSOP = 1 
          





SELECT DB_NAME() AS DataBaseName,
    CONVERT(VARCHAR(10), getdate(), 10) AS 'Date      ',
    FORMAT(count(*),'###,###') 'Qty', flgDeletedFromSOP
FROM tblSKU
group by flgDeletedFromSOP
ORDER BY flgDeletedFromSOP
/*                                  flgDeleted
DataBaseName	Date      	Qty 	FromSOP
=============   ========    ======= ======
SMI Reporting	06-23-20    478,667 11,665
SMI Reporting	08-05-19	449,859 11,116
SMI Reporting	01-11-19	430,834	10,921
SMI Reporting	04-25-17	343,241	10,458
SMI Reporting	01-04-16	285,304	 9,858
SMI Reporting	03-24-14	178,731	 7,914

AFCOReporting	08-05-19	73,759	 1,507
AFCOReporting	01-11-19	71,269	 1,501
AFCOReporting	01-31-18	67,452	 1,418
AFCOReporting	10-09-15	51,962	 1,344
AFCOReporting	11-03-14	48,922	   954	
*/

-- REFEED ALL DELETED SKUs
SELECT * FROM tblSKU WHERE flgDeletedFromSOP = 1
/*          Last Refed  Qty
            ==========  ======
    SMI     2019.01.11  10,965  0 SKUs found
    AFCO    2019.01.11   1,501  0 SKUs found
*/

/*** WHO has been creating the SKUs that are deleted? ****/
        -- ALL SKUs
        SELECT ST.ixSKU, FORMAT(D2.dtDate,'yyyy.MM.dd') 'SKUCreated', 
        FORMAT(D.dtDate,'yyyy.MM.dd') 'SKUDeleted',
        SKU.ixCreator, ST.sTransactionType, ST.sUser, ST.sLocation, E.sFirstname, E.sLastname
        FROM tblSKUTransaction ST
            left join tblDate D on ST.ixDate = D.ixDate
            left join tblEmployee E on ST.sUser = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblSKU SKU on SKU.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblDate D2 on D2.ixDate = SKU.ixCreateDate
            left join tblTime T on T.ixTime = ST.ixTime
        WHERE SKU.flgDeletedFromSOP = 1
           and ST.sTransactionType = 'DELETE'
           and ST.sLocation = 99
           and SKU.dtCreateDate >= '01/01/2020'
        ORDER BY D2.ixDate desc, ST.ixTime desc

        -- GROUPED BY CREATOR
        SELECT SKU.ixCreator, count(distinct ST.ixSKU) 'SKUsCreated'
        FROM tblSKUTransaction ST
            left join tblDate D on ST.ixDate = D.ixDate
            left join tblEmployee E on ST.sUser = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblSKU SKU on SKU.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            left join tblDate D2 on D2.ixDate = SKU.ixCreateDate
            left join tblTime T on T.ixTime = ST.ixTime
        WHERE SKU.flgDeletedFromSOP = 1
           and ST.sTransactionType = 'DELETE'
           and ST.sLocation = 99
           and SKU.dtCreateDate >= '01/01/2020'
        GROUP BY SKU.ixCreator
        ORDER BY  count(distinct ST.ixSKU)  desc
        /*  SKUs
            Created	ixCreator
            ======= =========
            WEBFEEDS    24
            JBM2	    16
            NJS	        11
            CGN	        8
            JMC1	    7
            JOS	        5
            KDL	        1
            BPH	        1
            JMM	        1
            CWS	        1
        */


          
          

/************ LNK-DW1 ****************/

-- TABLES with 0 rows
        CREATE TABLE #temp (table_name sysname,row_count INT,reserved_size VARCHAR(50),
           data_size VARCHAR(50),index_size VARCHAR(50),unused_size VARCHAR(50))
        SET NOCOUNT ON
        INSERT #temp
        EXEC sp_MSforeachtable 'sp_spaceused ''?'''
            SELECT CONVERT(VARCHAR, DateAdd(day, DateDiff(day, 0, GETDATE()), 0), 102)  'As Of     ',
                   a.row_count                                      'RowCnt',
				   a.table_name                                     'TableName',
            Cast(replace(a.data_size,' KB','') as INT)              KB,        
            (Cast(replace(a.data_size,' KB','') as DEC (7,0))/1024) MB -- 1024 KB = 1 MB
            FROM #temp a
               INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
            WHERE   a.table_name like 'tbl%' 
            GROUP BY a.table_name, a.row_count, a.data_size
            HAVING a.row_count  = 0
        DROP TABLE #temp
	/*
	SMI
				Row
	As Of     	Cnt	TableName
	==========	=	=================================
	2018.01.31	0	tblLoanTicketDetail
	2018.01.31	0	tblLoanTicketMaster
	2018.01.31	0	tblLoanTicketScans
	2018.01.31	0	tblOrderTNT
	2018.01.31	0	tblAwsQueue
	2018.01.31	0	tblCatalogMasterWork
	2018.01.31	0	tblDoorEventArchive
	2018.01.31	0	tblDoorEventArchive010114to041414
	2018.01.31	0	tblDoorEventArchive041514to123114
	2018.01.31	0	tblOrderFreeShippingEligible
	2018.01.31	0	tblPromotionalInventory
	2018.01.31	0	tblSKUIndex


	AFCO
				Row
	As Of     	Cnt	TableName
	==========	=	=================================
	2018.01.31	0	tblBinSkuOLD
	2018.01.31	0	tblInventoryForecastNewSKUs
	2018.01.31	0	tblMailingOptIn
	2018.01.31	0	tblOrderPromoCodeXref
	2018.01.31	0	tblProductLine
	2018.01.31	0	tblPromotionalInventory
	2018.01.31	0	tblSKUIndex
	*/




/************ LNK-DWSTAGING1 ****************/

-- Most recent SOP Feed Status Changes
SELECT top 6 FL.dtDate, T.chTime, FL.sFeedStatus
FROM tblSOPFeedLog FL
    join tblTime T on T.ixTime = FL.ixTime
ORDER BY ixDate desc, FL.ixTime desc


/*************** ERROR LOG ************************/
SELECT * FROM tblErrorCode
WHERE sDescription like 'Failure to update%'
ORDER BY sDescription

-- Errors Count PAST X DAYS
SELECT count(*) QTY	,ELM.dtDate, ELM.ixErrorCode, EC.sDescription 
FROM tblErrorLogMaster ELM
	left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE ELM.dtDate >  DATEADD(dd,-3,DATEDIFF(dd,0,getdate()))
	--and ELM.ixErrorCode = 1163
group by ELM.dtDate, ELM.ixErrorCode, EC.sDescription
HAVING count(*) > 0
ORDER BY ELM.dtDate desc, QTY desc




/****************** Vendor Overseas flag ******************/
SELECT DB_NAME() AS DataBaseName,
    CONVERT(VARCHAR(10), getdate(), 10) AS 'as of      ',
    count(*) VendorCnt,  flgOverseas
FROM tblVendor
group by flgOverseas
/*                          Vendor  flg
DataBaseName	as of      	Cnt	    Overseas
=============   ========    ===     ========
SMI Reporting	01-31-18	1,849	0
SMI Reporting	01-31-18	   26	1

SMI Reporting	09-23-16	1,835	0
SMI Reporting	09-23-16	   26   1

SMI Reporting	07-29-15	1,820	0
SMI Reporting	07-29-15	   26   1

SMI Reporting	09-22-14	1,742	0
SMI Reporting	09-22-14	   25   1

AFCOReporting	01-31-18	2,847	0
AFCOReporting	01-31-18	   7	1

AFCOReporting	09-23-16	2,276	0
AFCOReporting	09-23-16	    7   1
*/
BEGIN TRAN
    UPDATE tblVendor
    set flgOverseas = 0
    WHERE flgOverseas is null
ROLLBACK TRAN



SELECT DB_NAME() AS DataBaseName,
    CONVERT(VARCHAR(10), getdate(), 10) AS 'as of      ', count(*) QTY,  flgLegal
FROM tblVendor
group by flgLegal
/*                                  flg
DataBaseName	as of      	QTY	    Legal
SMI Reporting	01-31-18	1873	0
SMI Reporting	01-31-18	   2	1

SMI Reporting	09-23-16	1861	0

AFCOReporting	01-31-18	2854	0
AFCOReporting	09-23-16	2283	0
*/



/****************** Duplicate tblOrderLine Rows ******************/
SELECT ixOrder, iOrdinality, count(*)
FROM tblOrderLine
group by ixOrder, iOrdinality
having count(*) > 1
-- none for SMI as of 1-31-18
-- none for AFCO as of 1-31-18

	-- IF DUPES FOUND ENTER ORDER #'S here to review
	SELECT ixOrder, ixSKU, iOrdinality FROM tblOrderLine
	WHERE ixOrder in (('91004-PBLU','910048-PBLU','94031031','9401856'))
	ORDER BY ixOrder, iOrdinality


/*
-- set rowcount 0
set rowcount 1

delete FROM tblOrderLine
WHERE ixOrder = '4196529'
and iOrdinality = 1
GO
delete FROM tblOrderLine
WHERE ixOrder = '71245'
and iOrdinality = 2 
GO
delete FROM tblOrderLine
WHERE ixOrder = '71245'
and iOrdinality = 3
*/


/*
tblOrder.mMerchandiseCost <> SUM of tblOrderLine.mExtendedCost
*/
SELECT * FROM tblOrder WHERE ixOrder = '4389560'
SELECT * FROM tblOrderLine WHERE ixOrder = '4389560'
        ORDER BY iOrdinality



/***** CLEAN-UP for SKUs that actually need to be deleted FROM tables *****/
SELECT * 
into [SMIArchive].dbo.BU_tblSKU_07292015
FROM tblSKU

SELECT * 
into [SMIArchive].dbo.BU_tblSKULocation_07292015
FROM tblSKULocation

SELECT * 
into [SMIArchive].dbo.BU_tblVendorSKU_07292015
FROM tblVendorSKU

SELECT * 
into [SMIArchive].dbo.BU_tblCatalogDetail_07292015
FROM tblCatalogDetail

SELECT * 
into [SMIArchive].dbo.BU_tbltblDropship_07292015
FROM tblDropship

SELECT * 
into [SMIArchive].dbo.BU_tblInventoryForecast_07292015
FROM tblInventoryForecast

SELECT * 
into [SMIArchive].dbo.BU_tblBinSku_07292015
FROM tblBinSku

delete FROM tblSKULocation
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblVendorSKU
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblCatalogDetail
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblDropship
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblInventoryForecast
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblBinSku
WHERE ixSKU =  '491EC80WTU   '

delete FROM tblSKU
WHERE ixSKU =  '491EC80WTU   '

DELETE FROM tblSnapshotSKU
WHERE ixSKU =  '491EC80WTU   '
               '491EC80WTU   '
SELECT * FROM tblSnapshotSKU
WHERE ixSKU =  '491EC80WTU'

