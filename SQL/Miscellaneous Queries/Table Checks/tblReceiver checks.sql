-- tblReceiver

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblReceiver%'
--  ixErrorCode	sDescription                ixErrorType
--  1162	Failure to update tblReceiver.	SQLDB


-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1162'
  --and dtDate >=  DATEADD(dd, -195, getdate())  -- past X days
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
    SMI Reporting	08/20/2018	4
    SMI Reporting	07/02/2018	3
    SMI Reporting	06/28/2018	1
    SMI Reporting	06/22/2018	2
    SMI Reporting	11/14/2017	2
    SMI Reporting	07/27/2015	1
    SMI Reporting	07/09/2015	1
    SMI Reporting	11/17/2014	1
    SMI Reporting	03/17/2014	1
    SMI Reporting	11/15/2013	1
    
    NONE for Afco as of 5-3-2016
    */

SELECT *
FROM tblErrorLogMaster
WHERE ixErrorCode = '1162'


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblReceiver
/*
DB          	TABLE       Rows   	Date
SMI Reporting	tblReceiver	189,140	12-01-18

SMI Reporting	tblReceiver	168,876	01-01-18
SMI Reporting	tblReceiver	148,918	01-01-17
SMI Reporting	tblReceiver	130,380	01-01-16
SMI Reporting	tblReceiver	113,537	01-01-15
SMI Reporting	tblReceiver	 98,142	01-01-14
SMI Reporting	tblReceiver	 81,202	01-01-13
SMI Reporting	tblReceiver	 65,677	03-01-12



AFCOReporting	tblReceiver	52,847	12-01-18

AFCOReporting	tblReceiver	44,784	01-01-18
AFCOReporting	tblReceiver	38,488	01-01-17
AFCOReporting	tblReceiver	32,941	01-01-16
AFCOReporting	tblReceiver	28,353	01-01-15
AFCOReporting	tblReceiver	24,650	01-01-14
AFCOReporting	tblReceiver	23,663	10-01-13
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
    ,DaysOld 
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
FROM vwDataFreshness 
WHERE sTableName = 'tblReceiver'
order by DaysOld

/*
DB          	DateChecked	DaysOld	Records
=============   =========== ======= =======
SMI Reporting	12-12-2018	   <=1	29,786
SMI Reporting	12-12-2018	181 +	86,445


AFCOReporting	12-12-2018	   <=1	11,944
AFCOReporting	12-12-2018	181 +	24,640
*/
 
 
/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 174 total errors          
    from tblErrorLogMaster
    where --dtDate >=  '08/27/2015' --DATEADD(month, -1, getdate()) -- past X months
        -- and 
        ixErrorCode = 1162   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
   -- INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
              else replace(substring(sError,5,30),' failed to update','')
              end
              )'ixSKU'
    from tblErrorLogMaster
    where dtDate >= '08/28/2015' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163    
    order by 'ixSKU' 
    
select DB_NAME() AS 'DB          ',* 
from tblLocation
/*
DB          	ixLocation	sDescription	            ixState
AFCOReporting	30	        Eagle	                    NE
AFCOReporting	31	        Trackside Support Services	NE
AFCOReporting	68	        Lincoln	                    NE
AFCOReporting	99	        Boonville	                IN

SMI Reporting	47	        Boonville	                IN
SMI Reporting	97	        Trackside Support Services	NE
SMI Reporting	98	        Eagle	                    NE
SMI Reporting	99	        Lincoln	                    NE
*/
    
    -- HOW MANY EXIST IN tblReceiver ?
    select * from tblReceiver SKU -- 37
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    

    -- BEFORE Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblReceiver',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblReceiver SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblReceiver',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	In_tblReceiver	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    67401203-WHT-36	Y	12/12/2014	    26226	            0                   <-- oldest
    .
    .
    .
    6741244S-RED-40	Y	12/15/2014	    58480	            0                   <-- most recent
 
    */

    
-- 3) REFEED these SKUs from SOP
    select distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblReceiver',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
            left join tblReceiver SKU on RF.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    ORDER BY 'In_tblReceiver',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    67401157
    */
/*******   DONE   **********************/

'67401157'

-- general checks
  
/*
Table	RowCount	Non-DeletedSkuCount	ActiveCount	RunDate	NonDelMinUpdate	MaxUpdate	NULLUpdate
tblReceiver	157343	149723	112725	2013-05-06 10:39:21.237	2013-03-05	2013-05-06	0

Table	RowCnt	Non-DelSkuCnt	ActiveCount	RunDate	    NonDelMinUPD	MaxUpdate	NULLUpdate
tblReceiver	157343	149723	        12725	    05/06/2013	03/05/2013	    05/06/2013	0
 */

-- Active, Non GS, Non Del SKUs that 
-- haven't been updated in the last 30 days
select ixSKU,flgActive, dtCreateDate, dtDateLastSOPUpdate
from tblReceiver
where flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate < DATEADD(day, -30, GetDate())
    and flgActive = 1
    and ixSKU NOT like 'UP%'
order by 
    ixSKU, dtCreateDate,dtDateLastSOPUpdate    
-- 91 @4/8/2013

    
/****** SEMA checks **********************************/
-- Active, Non GS, Non Del, Tangible SKUs 
select count(*) as 'w/o SEMAValues' -- 19,320 @5-6-2013
from tblReceiver                         -- 19,170 @12-21-2013
where flgDeletedFromSOP = 0         -- 23,196 @1-28-2014
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0    
    and (sSEMACategory is NULL
         or sSEMASubCategory is NULL
         or sSEMAPart is NULL)
GO         
select count(*) as 'w SEMAValues' -- 72,207
from tblReceiver
where flgDeletedFromSOP = 0
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0
    and (sSEMACategory is NOT NULL
         AND sSEMASubCategory is NOT NULL
         AND sSEMAPart is NOT NULL) 
/*   
w/o         with        As          %
SEMAValues  SEMAValues  of          Categorized
18,831      72,179      04/08/13    79.3%
     
*/         

-- active SKUs shipped in last 90 days with no SEMAValues         
-- excludes:
-- SKUs starting with UP
select 
    SKU.ixSKU, SKU.sDescription,
    SKU.ixPGC,
    SKU.dtCreateDate, SKU.ixCreator,
    SKU.ixBrand,  
    VS.ixVendor         as 'Current PV#',
    V.sName             as 'PV Name',
    sum(OL.iQuantity)   as'QtyShipped'
from tblReceiver SKU
    join tblOrderLine OL on OL.ixSKU = SKU.ixSKU
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
    join tblVendor V on V.ixVendor = VS.ixVendor
where SKU.flgDeletedFromSOP = 0
    and SKU.flgActive = 1
    and SKU.ixSKU NOT like 'UP%'
    and (SKU.sSEMACategory is NULL
         or SKU.sSEMASubCategory is NULL
         or SKU.sSEMAPart is NULL)
    and O.dtShippedDate >= '01/08/2013'    
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and VS.iOrdinality = 1
group by     SKU.ixSKU, 
    SKU.sDescription,
    SKU.ixPGC,
    SKU.dtCreateDate,
    SKU.ixCreator,
    SKU.ixBrand,
    VS.ixVendor,
    V.sName
order by VS.ixVendor
/*******   DONE   **********************/                  
  
/*******    INSERTING DELETED SKUs to satisty FK restraints     *******/
insert tblReceiver (
    ixSKU, mPriceLevel1, mPriceLevel2, mPriceLevel3, mPriceLevel4, mPriceLevel5, mLatestCost, mAverageCost, ixPGC, sDescription, flgUnitOfMeasure, flgTaxable, 
    /*iQAV and iQOS do not use!*/ ixCreateDate, dtCreateDate, ixRoyaltyVendor, ixDiscontinuedDate, dtDiscontinuedDate, flgActive, sBaseIndex, dWeight, 
    sOriginalSource, flgAdditionalHandling, ixBrand, ixOriginalPart, ixHarmonizedTariffCode, flgIsKit, iLength, iWidth, iHeight, iMaxQOS, iRestockPoint, flgShipAloneStatus, flgIntangible, ixCreator, iLeadTime, flgMadeToOrder,ixForecastingSKU,
    flgDeletedFromSOP,iMinOrderQuantity, sCountryOfOrigin, sAlternateItem1, sAlternateItem2, sAlternateItem3, flgBackorderAccepted,
    dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
    ixReasonCode, sHandlingCode, ixProductLine, sWebUrl, sWebDescription, mMSRP, iDropshipLeadTime, ixCAHTC )
values
    ('9193382-4',/*ixSKU*/    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    'DELETED FROM SOP',/*sDescription*/ NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    0,/*flgActive*/ NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    1,/*flgDeletedFromSOP*/   NULL,NULL,NULL,NULL,NULL,NULL, 
    DATEADD(dd,0,DATEDIFF(dd,0,getdate())),/*dtDateLastSOPUpdate*/ 
    dbo.GetCurrentixTime (),/*ixTimeLastSOPUpdate*/
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)








-- refeed all SKUs currently flagged as Deleted From SOP 
select ixSKU from tblReceiver where flgDeletedFromSOP = 1 -- 7,766
    and dtDateLastSOPUpdate < '12/02/2013'
    
    

select count(*) from tblReceiver where dtDateLastSOPUpdate = '02/20/2014' and ixTimeLastSOPUpdate > 32400





select ixSKU, dtCreateDate, ixCreator, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblReceiver
where ixSKU in ('282159','410740','410740','410740','410740','445251','447304','540115','550052','550150','550179','550200','550916','91028A','917600','917601','930C7H','960530','960532','960533','960540','NCSHIP','PLONLY')
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate

select * from tblTime where ixTime = 48646




/**************************************************** 
 ****** TESTING when adding new fields **************
 ****************************************************/
 
    /********   SMI     ********/
    SELECT sCycleCode, count(*) Qty
    from [SMI Reporting].dbo.tblReceiver
    group by sCycleCode
    order by sCycleCode
    /*
    sCycleCode	Qty
    NULL	281619
    .98	    1
    0	    257
    0.00	1
    0000	1
    192.83	3
    39.95	11
    A	    479
    B	    697
    C	    1514
    D	    860
    K	    47
    N	    40
    NN	    1 
    */
    set rowcount 30000 -- set rowcount = 0
    UPDATE tblReceiver
    set sCycleCode = 0
    where sCycleCode is NUll
    
        -- test records
        SELECT ixSKU, sCycleCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [SMI Reporting].dbo.tblReceiver
        WHERE ixSKU in ('91315484','91315444','91315459')
        /*                  dtDateLast  ixTime
        ixSKU	    sCycleCode	SOPUpdate	LastSOPUpdate
        4988800	    1	    2015-09-02	49139
        91034558-9	0	    2015-09-02	49140
        UP6792	    0	    2015-09-02	49141
        */


    /********   AFCO     ********/
    SELECT sCycleCode, count(*) Qty
    from [AFCOReporting].dbo.tblReceiver
    group by sCycleCode
    order by sCycleCode
    /*
    sCycleCode	Qty
    NULL	48836
    3PLAB	1
    COMP	1567
    cycle c	1
    DISC	135
    DLML	187
    DMOD	954
    DPLM	55
    DRAG	102
    EXPENSE	2
    MODI	113
    N	    2
    OWHE	535
    PLAB	132
    PLML	100
    PMOD	100
    QMID	86
    SCMO	1
    SMI	    2
    SROD	26
    SSDM	43
    SSMO	19
    SSTO	12
    STRUT	3 
    */

        -- test records
        SELECT ixSKU, sCycleCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [AFCOReporting].dbo.tblReceiver
        WHERE ixSKU in ('90002292','169201SA','3865SP')
        /*                      dtDateLast  ixTime
        ixSKU	    sCycleCode	    SOPUpdate	LastSOPUpdate
        89099-L	    0	        2015-09-02	49444
        89099-M	    1	        2015-09-02	49297
        */


-- DROPSHIP only SKUs
select sPickingBin, COUNT(ixSKU)
from tblReceiverLocation -- 74,939
where ixLocation = 99
and sPickingBin LIKE '%999%'
--and iQAV > 0
group by sPickingBin
order by COUNT(ixSKU)
/*
sPickingBin	QTY
9999	    43,435 @01/06/16
*/

SELECT COUNT(*) AS open_cursors
FROM master..syscursortables ct
INNER JOIN master..syscursors c ON ct.cursor_handle = c.cursor_handle
WHERE dbname='AFCOReporting'


select * FROM master.dbo.syscursortables