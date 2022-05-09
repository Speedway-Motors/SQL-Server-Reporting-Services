-- tblLocalTaxCode Checks
-- Table CREATED 10-1-2014

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblLocalTaxCode%'
/*  
ixErrorCode	sDescription	                    ixErrorType
1220	    Failure to update tblLocalTaxCode	SQLDB
*/

-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1220'
  and dtDate >=  DATEADD(month, -3, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
    SMI Reporting	10/01/2014	2           <-- intentional for testing
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblLocalTaxCode
/*
DB          	TABLE           Rows   	Date
SMI Reporting	tblLocalTaxCode	3,997	10-01-14
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblLocalTaxCode'

/*
DB          	Records	DaysOld	DateChecked
SMI Reporting	24,762	   <=1	05-30-2014
SMI Reporting	6,273	   2-7	05-30-2014
SMI Reporting	69,368	  8-30	05-30-2014
SMI Reporting	90,816	 31-180	05-30-2014
*/
 


select dTaxRate, count(*) Qty
from tblLocalTaxCode
group by dTaxRate
order by count(*) desc
/*
dTaxRate	Qty
7.000	2184
5.000	1370
5.500	336
6.500	99
7.500	6
6.000	2
*/

select count(*) Qty, sLocalTaxCode
from tblLocalTaxCode
group by sLocalTaxCode
order by count(*) desc
    /* AS OF 10-2-2014
    Qty     sLocalTaxCode
    1997	IN
    1702	NE
    48	NE 1-365
    29	NE 2-285
    4	38-269
    3	007-441
    3	34-210
    3	NE 3-046
    2	NE 4-355
    2	NE 10-372
    2	134-922
    2	33-230
    2	NE-SUB
    2	NE 28-382
    2	53-057
    2	NE 62-191
    2	60-110
    ...190 more Tax codes with 1 zip each
    */

 
/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 537 total errors          
    from tblErrorLogMaster
    where dtDate >=  '02/28/2014' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1220   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
              else replace(substring(sError,5,200),' failed to update','')
              end
              )'ixSKU'
    from tblErrorLogMaster
    where dtDate >=  '02/28/2014' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1220    
    order by 'ixSKU' 
    
    -- HOW MANY EXIST IN tblLocalTaxCode ?
    select * from tblLocalTaxCode SKU -- 37
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    
    106332.6GS*47 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]Could not find stored procedure 'spUpdateSKU'.
    -- BEFORE Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblLocalTaxCode',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblLocalTaxCode SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblLocalTaxCode',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	In_tblLocalTaxCode	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    634-1334	NO	NULL	NULL	NULL
    634-1721	NO	NULL	NULL	NULL
    634-41733	NO	NULL	NULL	NULL
    634-41773	NO	NULL	NULL	NULL
    634-41783	NO	NULL	NULL	NULL
    634-63506	NO	NULL	NULL	NULL
    ... etc. 
 
    */

    
-- 3) REFEED these SKUs from SOP
    select distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblLocalTaxCode',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
            left join tblLocalTaxCode SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblLocalTaxCode',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    21347-7-00-10-STD
    21357-7-00-10-STD
    */
/*******   DONE   **********************/



-- general checks
  
/*
Table	RowCount	Non-DeletedSkuCount	ActiveCount	RunDate	NonDelMinUpdate	MaxUpdate	NULLUpdate
tblLocalTaxCode	157343	149723	112725	2013-05-06 10:39:21.237	2013-03-05 00:00:00.000	2013-05-06 00:00:00.000	0

Table	RowCnt	Non-DelSkuCnt	ActiveCount	RunDate	    NonDelMinUPD	MaxUpdate	NULLUpdate
tblLocalTaxCode	157343	149723	        12725	    05/06/2013	03/05/2013	    05/06/2013	0
 */

-- Active, Non GS, Non Del SKUs that 
-- haven't been updated in the last 30 days
select ixSKU,flgActive, dtCreateDate, dtDateLastSOPUpdate
from tblLocalTaxCode
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
from tblLocalTaxCode                         -- 19,170 @12-21-2013
where flgDeletedFromSOP = 0         -- 23,196 @1-28-2014
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0    
    and (sSEMACategory is NULL
         or sSEMASubCategory is NULL
         or sSEMAPart is NULL)
GO         
select count(*) as 'w SEMAValues' -- 72,207
from tblLocalTaxCode
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
from tblLocalTaxCode SKU
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
insert tblLocalTaxCode (
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
select ixSKU from tblLocalTaxCode where flgDeletedFromSOP = 1 -- 7,766
    and dtDateLastSOPUpdate < '12/02/2013'
    
    

select count(*) from tblLocalTaxCode where dtDateLastSOPUpdate = '02/20/2014' and ixTimeLastSOPUpdate > 32400




