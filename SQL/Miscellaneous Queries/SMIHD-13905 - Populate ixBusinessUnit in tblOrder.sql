=-- SMIHD-13905 - Populate ixBusinessUnit in tblOrder

-- LOGIC FROM CCC
/* logic from CCC for Business Units provided 4-3-19
if [ixCustomer (tblOrder)]=1770000 or [ixCustomer (tblOrder)]=2672493 then "ICS"
elseif [S Order Channel]="INTERNAL" then "INT"
elseif CONTAINS([S Source Code Given],"EMP") then "EMP"
elseif  contains([S Source Code Given],"PRS") then "PRS"
elseif contains([S Source Code Given],"MRR") then
    elseif [S Source Code Given]=="MRR" or [S Source Code Given]=="MRRWEB" then "MRR"
elseif  CONTAINS([S Source Code Given],"CTR") or [I Ship Method]=1 then "RETLNK"
elseif  CONTAINS([S Source Code Given],"2190") or CONTAINS([S Source Code Given],"2191") then "WEB"
elseif contains([S Source Code Given],"EBAYGS") then "GS"
elseif  contains([S Source Code Given],"AMAZON") or contains([S Source Code Given],"WALMART") or contains([S Source Code Given],"EBAY") then -- ???
-- are there lines missing here?
    elseif  [S Source Code Given]=="AMAZON" or contains([S Source Code Given],"WALMART") or contains([S Source Code Given],"EBAY") then  "MKT"
ELSE "PHONE"
END
*/

select sSourceCodeGiven, dtDateLastSOPUpdate
from tblOrder where ixOrder = '7724647'

-- CODE TO RUN ACTUAL UPDATES IN PROCUCTION
-- FINAL code as of 5-16-19
BEGIN TRAN

    UPDATE tblOrder  -- [SMITemp].dbo.PJC_SMIHD13905_2019P1_tblOrder_data -- tblOrder 
    SET ixBusinessUnit = (CASE   WHEN ixCustomer IN (1770000, 2672493) then 101 --'ICS'    49,801 records
                WHEN sSourceCodeGiven like 'INTERNAL%' then 102 -- 'INTERNAL'
                WHEN sSourceCodeGiven like '%EMP%' then 103 -- 'EMP'
                WHEN sSourceCodeGiven like '%PRS%' then 104 -- 'PRS'
                WHEN sSourceCodeGiven like 'MRR%' then 105 -- 'MRR'
                WHEN (sSourceCodeGiven like '%CTR%' 
                      or iShipMethod = 1)  
                      then 106 -- 'RETLINK'
                WHEN sSourceCodeGiven in ('2190','2191', 'GGL', 'INET','NET','WEB') then 107 --'WEB'
                WHEN sSourceCodeGiven like '%EBAYGS%' then 108 --'GS' -- these are the only orders that qualify as GS orders.
                WHEN (sSourceCodeGiven like '%AMAZON%' -- includes AMAZONPRIME
                      or sSourceCodeGiven like '%WALMART%'
                      or sSourceCodeGiven like 'EBAY%')
                      then 109 -- 'MKT' 
         ELSE 110 -- 'PHONE'
         END) --'BusinessUnit'
    WHERE dtInvoiceDate between '01/01/2007' and '05/16/2019' -- P3-4      load backwards <180k at a time
       -- and ixBusinessUnit is NULL
ROLLBACK TRAN
/* 2206 to 2008 -- 5-7 months
   2009 to 2011 -- 5 months
   2012 to 2014 -- 4 months
   2015 to 2019 -- 3 months per run

09/01/2013 - 12/31/2013	9-12
05/01/2013 - 08/31/2013  5-8
01/01/2013 - 04/30/2013  1-4

   -- QUARTERS
   10/01    12/31
   07/01    09/30
   04/01    06/30
   01/01    03/31

   NEED BU LOGIG UPDATED FOR 5/10/19 TO PRESENT !!!
        */

select FORMAT(count(*),'###,###'), FORMAT(getdate(),'hh:mm') 'AsOf'
from tblOrder
where ixBusinessUnit is NOT NULL -- 5,761,167	10:02







-- MISMATCHED ORDERS
    SELECT ixOrder, ixCustomer,sOrderChannel, sSourceCodeGiven, iShipMethod, dtInvoiceDate, sOrderStatus, dtDateLastSOPUpdate
    from tblOrder where ixOrder in ('8294758-1')-- ('8489239') -- '8381039'
/*
ixOrder ixCustomer	sOrderChannel	sSourceCodeGiven	iShipMethod RULES EVALUATE TO
======= ==========  =============   ===========         =========== ============
8381039 2566389	    INTERNAL	    EC	                8           102 INTERNAL       <-- checking with chris to see if the logic changed
8489239 567268	    COUNTER	        CTR	                1           106 RETLNK
*/


                                 


SELECT BU.ixBusinessUnit,   FORMAT(count(TD.ixOrder),'###,##0') 'OrderCount', SUM(O.mMerchandise) 'Sales',
    BU.sBusinessUnit, BU.sDescription
FROM [SMITemp].dbo.PJC_SMIHD13905_2019P1_tblOrder_data TD
    FULL OUTER JOIN tblBusinessUnit BU on TD.ixBusinessUnit = BU.ixBusinessUnit
    left join tblOrder O on TD.ixOrder = O.ixOrder
GROUP BY BU.ixBusinessUnit, BU.sBusinessUnit, BU.sDescription
/*
ix  Order   s
BU	Count	BU	    sDescription
=== ======= ===     ====================
101	107	    ICS	    Inter-company sale
102	328	    INT	    Intra-company sale
103	100	    EMP	    Employee
104	1,235	PRS	    Pro Racer
105	768	    MRR	    Mr Roadster
106	1,140	RETLINK	Retail, Lincoln
107	21,261	WEB	    Website
108	138	GS	Garage Sale
109	13,368	MKT	    Marketplaces
110	11,356	PHONE	CX Orders
111	0	    RETTOL	Retail, Tolleson
112	0	    UK	    Unknown
*/

SELECT BU.ixBusinessUnit,   FORMAT(count(O.ixOrder),'###,##0') 'OrderCount', SUM(O.mMerchandise) 'Sales',
    BU.sBusinessUnit, BU.sDescription
FROM  tblOrder O
    left JOIN tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE O.dtInvoiceDate between  '01/26/2019' AND   '03/01/2019'      --'03/02/2019' and '03/29/2019'
  GROUP BY BU.ixBusinessUnit, BU.sBusinessUnit, BU.sDescription




select SUM(O.mMerchandise)
from tblOrder O
where O.dtInvoiceDate between '12/29/2018' and '01/25/2019'

        BEGIN TRAN
            UPDATE tblOrder 
            SET ixBusinessUnit = NULL
            WHERE dtInvoiceDate between '12/29/2018' and '01/25/2019'
            and ixBusinessUnit between 101 and 110

ROLLBACK TRAN

select * from tblBusinessUnit
/*
ixBusinessUnit	sBusinessUnit
101	ICS
102	INT
103	EMP
104	PRS
105	MRR
106	RETLINK
107	WEB
108	GS
109	MKT
110	PHONE
111	RETTOL
112	UK
*/

select * from tblBusinessUnit


select ixBusinessUnit, count(*)
from tblOrder
--where dtInvoiceDate between '12/29/2018' and '01/25/2019'
group by ixBusinessUnit

sel


select * from [SMITemp].dbo.PJC_SMIHD13905_2019P1_PSG_BU_data -- 49,802

-- PSG doesn't match my temp table
SELECT PSG.ixOrder, 
    BU.sBusinessUnit 'PSGBU', 
    BU2.sBusinessUnit 'TDBU'-- 49,801
FROM [SMITemp].dbo.PJC_SMIHD13905_2019P1_PSG_BU_data PSG
    left join tblBusinessUnit BU on PSG.sBusinessUnit = BU.sBusinessUnit
    FULL OUTER JOIN [SMITemp].dbo.PJC_SMIHD13905_2019P1_tblOrder_data TD ON PSG.ixOrder = TD.ixOrder
    left join tblBusinessUnit BU2 on TD.ixBusinessUnit = BU2.ixBusinessUnit
--WHERE BU.sBusinessUnit = BU2.sBusinessUnit -- 49,800 match   2 delta
WHERE BU.sBusinessUnit <> BU2.sBusinessUnit -- 1
or BU.sBusinessUnit is NULL
or  BU2.sBusinessUnit is NULL
/*
ixOrder	PSGBU	TDBU
8381039	PHONE	INT
8489239	RETLNK	NULL
*/

SELECT * FROM tblBusinessUnit
SELECT * FROM [SMITemp].dbo.PJC_SMIHD13905_2019P1_PSG_BU_data
SELECT COUNT(*) FROM tblOrder where ixBusinessUnit is NOT NULL

select count(*) from [SMITemp].dbo.PJC_SMIHD13905_2007toPresent_PSG_BU_data





WHERE O.dtInvoiceDate between '12/29/2018' and '01/25/2019'
AND (TD.ixBusinessUnit <> O.ixBusinessUnit
or TD.ixBusinessUnit IS NULL
or O.ixBusinessUnit IS NULL

-- NON MATCHES
ixOrder	PSGBU	TDBU
8381039	PHONE	INT
ixOrder	PSGBU	TDBU
8086933	NULL	RETLINK
8100331	NULL	RETLINK
8112336	NULL	RETLINK
8115738	NULL	RETLINK
8116935	NULL	RETLINK
8119336	NULL	RETLINK
8120939	NULL	RETLINK
8135233	NULL	RETLINK


SELECT * FROM tblBusinessUnit

SELECT TOP 10 * 
FROM [SMITemp].dbo.PJC_SMIHD13905_2019P1_tblOrder_data



select * from [SMITemp].dbo.PJC_SMIHD13905_2019P1_PSG_BU_data 
order by sBusinessUnit


where sBusinessUnit = 'RETLINK'

SELECT * FROM [SMITemp].dbo.PJC_SMIHD13905_2019P1_PSG_BU_data
WHERE ixOrder in ('8086933','8100331','8112336','8115738','8116935','8119336')

select * from tblBusinessUnit 'RETLNK'

SELECT * from tblOrder where ixOrder in ('8381039','8489239')

SELECT COUNT(ixOrder)
from tblOrder
where dtShippedDate between '01/01/2007' and '12/28/2018'  -- 5,472,287



SELECT FORMAT(dtDate,'MM/dd/yyyy') 'Date', iPeriod, iDayOfFiscalPeriod
FROM tblDate
where iPeriodYear = 2015
and iDayOfFiscalPeriod in (1,28,35)
order by dtDate desc
/*
Date	iPeriod	iDayOfFiscalPeriod
10/03/2015 - 01/01/2016	10-12
07/04/2015 - 10/02/2015  7-9
04/04/2015 - 07/03/2015  4-6
01/03/2015 - 01/03/2015  1-3



*/