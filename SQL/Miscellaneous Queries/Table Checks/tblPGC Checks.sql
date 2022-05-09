-- tblPGC Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblPGC%'
--  ixErrorCode	sDescription
--  1176	    Failure to update tblPGC.	


-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1176'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
    SMI Reporting	11/26/2013	1
    SMI Reporting	11/19/2013	1
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblPGC
/*
DB          	TABLE   Rows   	Date
SMI Reporting	tblPGC	326	09-01-14
SMI Reporting	tblPGC	325	01-01-14
SMI Reporting	tblPGC	315	01-01-13
SMI Reporting	tblPGC	313	04-01-12

AFCOReporting	tblPGC	471	09-01-14
AFCOReporting	tblPGC	471	02-01-14
AFCOReporting	tblPGC	466	10-01-13
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblPGC'

/*
DB          	Records	DaysOld	DateChecked
SMI Reporting	24,762	   <=1	05-30-2014
SMI Reporting	6,273	   2-7	05-30-2014
SMI Reporting	69,368	  8-30	05-30-2014
SMI Reporting	90,816	 31-180	05-30-2014
*/
 

    select * 
    from tblErrorLogMaster
    where ixErrorCode = 1176    
 /*
ixErrorID	ixDate	dtDate	    ixTime	IPAddress	sUser	sPort	ixErrorCode	sError	                                dtDateLastSOPUpdate	ixTimeLastSOPUpdate
1827147	    16760	2013-11-19 	45815	NULL	    NULL	NULL	1176	    Product Group Code Ri failed to update	2013-11-23 	        12949
1838410	    16767	2013-11-26 	64561	NULL	    NULL	NULL	1176	    Product Group Code Ri failed to update	2013-11-30 	        12853
*/

/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 537 total errors          
    from tblErrorLogMaster
    where dtDate >=  '02/28/2014' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1176   

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
        and ixErrorCode = 1176    
    order by 'ixSKU' 
    
    -- HOW MANY EXIST IN tblPGC ?
    select * from tblPGC SKU -- 37
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    
    106332.6GS*47 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]Could not find stored procedure 'spUpdateSKU'.
    -- BEFORE Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblPGC',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblPGC SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblPGC',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	In_tblPGC	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
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
         end) as 'In_tblPGC',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
            left join tblPGC SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblPGC',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    21347-7-00-10-STD
    21357-7-00-10-STD
    */
/*******   DONE   **********************/



-- general checks
  
/*
Table	RowCount	Non-DeletedSkuCount	ActiveCount	RunDate	NonDelMinUpdate	MaxUpdate	NULLUpdate
tblPGC	157343	149723	112725	2013-05-06 10:39:21.237	2013-03-05 	2013-05-06 	0

Table	RowCnt	Non-DelSkuCnt	ActiveCount	RunDate	    NonDelMinUPD	MaxUpdate	NULLUpdate
tblPGC	157343	149723	        12725	    05/06/2013	03/05/2013	    05/06/2013	0
 */

-- Active, Non GS, Non Del SKUs that 
-- haven't been updated in the last 30 days
select ixSKU,flgActive, dtCreateDate, dtDateLastSOPUpdate
from tblPGC
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
from tblPGC                         -- 19,170 @12-21-2013
where flgDeletedFromSOP = 0         -- 23,196 @1-28-2014
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0    
    and (sSEMACategory is NULL
         or sSEMASubCategory is NULL
         or sSEMAPart is NULL)
GO         
select count(*) as 'w SEMAValues' -- 72,207
from tblPGC
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
from tblPGC SKU
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
insert tblPGC (
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
select ixSKU from tblPGC where flgDeletedFromSOP = 1 -- 7,766
    and dtDateLastSOPUpdate < '12/02/2013'
    
    

select count(*) from tblPGC where dtDateLastSOPUpdate = '02/20/2014' and ixTimeLastSOPUpdate > 32400




