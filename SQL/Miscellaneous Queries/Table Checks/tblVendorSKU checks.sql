-- tblVendorSKU checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblVendorSKU%'
--  ixErrorCode	sDescription
--  1166	    Failure to update tblVendorSKU.

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1166'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	01/13/2014	54
SMI Reporting	01/09/2014	36
SMI Reporting	01/08/2014	39911
SMI Reporting	01/07/2014	31
SMI Reporting	01/06/2014	4
SMI Reporting	01/01/2014	10
SMI Reporting	12/31/2013	492
SMI Reporting	12/30/2013	46
SMI Reporting	12/28/2013	234
SMI Reporting	12/26/2013	538
SMI Reporting	12/25/2013	36
SMI Reporting	12/23/2013	1
SMI Reporting	12/20/2013	1
SMI Reporting	12/18/2013	2

DB          	Date    	ErrorQty
AFCOReporting	11/03/2014	398         -- REFED SKUs without issue
AFCOReporting	10/20/2014	262         -- REFED SKUs without issue
AFCOReporting	10/13/2014	325         -- REFED SKUs without issue
AFCOReporting	10/07/2014	423         -- REFED SKUs without issue
*/
/************************************************************************/

select count(*) from tblVendorSKU -- 206,023 @7-18-2013
                                  -- 217,794 @1-14-2014
                                  
-- TABLE GROWTH
exec spGetTableGrowth tblVendorSKU
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblVendorSKU	217283	01-01-14
SMI Reporting	tblVendorSKU	215820	12-01-13
SMI Reporting	tblVendorSKU	212725	11-01-13
SMI Reporting	tblVendorSKU	210847	10-01-13
SMI Reporting	tblVendorSKU	209267	09-01-13
SMI Reporting	tblVendorSKU	207226	08-01-13
SMI Reporting	tblVendorSKU	196687	06-01-13
SMI Reporting	tblVendorSKU	192525	05-01-13
SMI Reporting	tblVendorSKU	189942	04-01-13
SMI Reporting	tblVendorSKU	183820	03-01-13
SMI Reporting	tblVendorSKU	164509	01-01-13
SMI Reporting	tblVendorSKU	170850	12-01-12
SMI Reporting	tblVendorSKU	169499	11-01-12
SMI Reporting	tblVendorSKU	137156	10-01-12
SMI Reporting	tblVendorSKU	135293	09-01-12
SMI Reporting	tblVendorSKU	133543	08-01-12
SMI Reporting	tblVendorSKU	128225	06-01-12
SMI Reporting	tblVendorSKU	126410	05-01-12
SMI Reporting	tblVendorSKU	124707	04-01-12
SMI Reporting	tblVendorSKU	122741	03-01-12

AFCOReporting	tblVendorSKU	82910	11-01-14
AFCOReporting	tblVendorSKU	82406	10-01-14
AFCOReporting	tblVendorSKU	81948	07-01-14
AFCOReporting	tblVendorSKU	81034	04-01-14
AFCOReporting	tblVendorSKU	80121	01-01-14
AFCOReporting	tblVendorSKU	78672	10-01-13


*/
                                  
-- SKUs with missing ordinality
select VS.ixSKU                      -- 156 @7-18-2013
                                     -- 889 @1-14-2014
    ,max(VS.iOrdinality) 'MaxOrdinality'
    ,count(VS.ixSKU) 'CntRows'
    ,ABS(max(iOrdinality) - count(VS.ixSKU)) 'Delta'
from tblVendorSKU VS
    left join tblSKU SKU on VS.ixSKU = SKU.ixSKU
where SKU.flgDeletedFromSOP = 0    
group by VS.ixSKU
having max(VS.iOrdinality) <> count(VS.ixSKU) 
order by ABS(max(VS.iOrdinality) - count(VS.ixSKU)) desc

-- details from above query
select VS.*
    ,V.sName 'Vendor' 
from tblVendorSKU VS
    left join tblVendor V on VS.ixVendor = V.ixVendor
where VS.ixSKU in (select ixSKU
                    from tblVendorSKU
                    group by ixSKU
                    having max(iOrdinality) <> count(*) 
                    )
order by 
     ixVendor
    ,ixSKU
    ,iOrdinality


-- samples SKUs that have messed up ordinality
select * from tblVendorSKU where ixSKU = '91919567'

-- iLeadTime comparison tblVendorSKU vs tblSKU -- 14,371 @7-19-2013
select SKU.ixSKU                               --      0 @1-14-2014
    , SKU.iLeadTime 'SKUiLeadTime'
    , VS.iLeadTime 'VSiLeadTime'
    , ABS(isnull(SKU.iLeadTime,0) - isnull(VS.iLeadTime,0)) 'DELTA'
from tblSKU SKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU 
where SKU.flgDeletedFromSOP = 0
 and VS.iOrdinality = 1  
 and ABS(isnull(SKU.iLeadTime,0) - isnull(VS.iLeadTime,0)) > 0
 and SKU.dtDateLastSOPUpdate = '07/19/2013'
order by DELTA desc  
    

-- AFCO
SELECT COUNT(VS.ixSKU) AfcoCnt 
FROM [AFCOReporting].dbo.tblVendorSKU VS
    left join [AFCOReporting].dbo.tblSKU SKU on VS.ixSKU = SKU.ixSKU
where VS.dtDateLastSOPUpdate is NULL 
and SKU.flgDeletedFromSOP = 0 -- 0 @1-14-2014


-- SMI
SELECT COUNT(VS.ixSKU) AfcoCnt 
FROM [SMI Reporting].dbo.tblVendorSKU VS
    left join [SMI Reporting].dbo.tblSKU SKU on VS.ixSKU = SKU.ixSKU
where VS.dtDateLastSOPUpdate is NULL 
and SKU.flgDeletedFromSOP = 0 -- 0 @1-14-2014



-- failed to update tblVendorSKU
select 
distinct replace(substring(sError,19,200),'Vendor SKU record ','') as 'ixSKU'
     , sError
from tblErrorLogMaster
where ixErrorCode = '1166'
and dtDate >= '10/07/2014'

select SKU.ixSKU, SKU.ixPGC
from tblSKU SKU
where ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  in (select 
                distinct replace(substring(sError,19,200),' failed to update','') as 'ixSKU'
                    --, sError
                from tblErrorLogMaster
                where ixErrorCode = '1166'
                and dtDate >= '10/07/2014'
                )

