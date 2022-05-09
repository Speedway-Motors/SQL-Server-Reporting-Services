-- SMIHD-5984 - CST Customers not in 10-31-2016 LB extracts

select COUNT(*) from PJC_SMIHD5984_LB_AWOL_Customers                    -- 4,358
select count (distinct ixCustomer) from PJC_SMIHD5984_LB_AWOL_Customers -- 4,358

-- STEP 1)  CHECK to see if the AWOL customers would be included in the etract if it were built today

-- ALTERED vwLBSampleTransactions TO INCLUDE ORDERS THROUGH 11/23/26
SELECT DISTINCT ixCustomer
from PJC_SMIHD5984_LB_AWOL_Customers MC
join [SMI Reporting].dbo.vwLBSampleTransactions LB on MC.ixCustomer = LB.custid 
-- 3,518 (80%) of the missing customers would now be in the LB extract if pulled today


-- Remaining customers that still wouldn't qualify for LB extract
SELECT DISTINCT ixCustomer
into PJC_SMIHD5984_LB_AWOL_StillNotQualifying -- 840
from PJC_SMIHD5984_LB_AWOL_Customers MC
left join [SMI Reporting].dbo.vwLBSampleTransactions LB on MC.ixCustomer = LB.custid 
where LB.custid IS NULL


    -- 741 are in CST
    SELECT MC.ixCustomer
    from PJC_SMIHD5984_LB_AWOL_StillNotQualifying MC
    join [SMI Reporting].dbo.vwCSTStartingPool CST on MC.ixCustomer = CST.ixCustomer


-- none are in vwLBSampleTransactions
SELECT DISTINCT MC.ixCustomer
from PJC_SMIHD5984_LB_AWOL_StillNotQualifying MC
    left join [SMI Reporting].dbo.vwLBSampleTransactions LB on MC.ixCustomer = LB.custid
WHERE LB.custid is NULL



-- LOGIC for vwLBSampleTransactions
SELECT DISTINCT MC.ixCustomer, 
    O.ixOrder, O.sShipToCountry
FROM [SMI Reporting].dbo.vwCSTStartingPool CST
    join PJC_SMIHD5984_LB_AWOL_StillNotQualifying MC on MC.ixCustomer = CST.ixCustomer
    join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = CST.ixCustomer -- must be in tblOrder AND CST Starting Pool
	left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixOrder = O.ixOrder
	left join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
	left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = OL.ixSKU
	left join [SMI Reporting].dbo.tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99
where
/* try and exclude as many 'fake' SKUs (intangible, etc.) from result set. LB only care about real items */
	C.sCustomerType = 'Retail'
 	and O.dtOrderDate between '01/01/2009' and '11/23/2016' -- FLOOR is always 1/1/09 per LB's request. End date will be last day of previous month (in MOST cases)
	and SKU.sDescription not like '%CATALOG%' 
	and OL.mExtendedPrice > 0 	
    and O.sOrderStatus = 'Shipped'
	and O.ixOrder not like '%-%'	
    and OL.flgKitComponent = 0
	and SKU.flgIntangible=0	
	and OL.ixSKU not like 'HELP%'   -- NO EXCLUSIONS AT THIS POINT OR HIGHER
	and O.sOrderType='Retail'	-- ELIMINATES 75	
	and O.sShipToCountry='US'-- ELIMINATES 24
    and SL.sPickingBin not like '%!%'-- ELIMINATES 123
    and OL.flgLineStatus IN ('Shipped','Dropshipped') -- ELIMINATES 597    
	)


SELECT MC.ixCustomer,O.ixOrder, O.sOrderType,O.sShipToCountry, SL.sPickingBin,OL.flgLineStatus
FROM [SMI Reporting].dbo.vwCSTStartingPool CST
    join PJC_SMIHD5984_LB_AWOL_StillNotQualifying MC on MC.ixCustomer = CST.ixCustomer
    join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = CST.ixCustomer -- must be in tblOrder AND CST Starting Pool
	left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixOrder = O.ixOrder
	left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = OL.ixSKU
	left join [SMI Reporting].dbo.tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99	
WHERE O.dtOrderDate between '01/01/2009' and '11/23/2016'
        and O.sOrderStatus = 'Shipped'
order by ixOrder


SELECT flgLineStatus, count(*)
from [SMI Reporting].dbo.tblOrderLine
where ixOrder like 'Q%'
  and ixOrderDate > 17831
group by flgLineStatus
order by flgLineStatus

SELECT distinct top 36000  ixOrder, dtDateLastSOPUpdate  -- 9013
from [SMI Reporting].dbo.tblOrderLine
where ixOrder like 'Q%'
  and flgLineStatus in ('Backordered','Backordered FS','Dropshipped','Lost')
  --and ixOrder in ('Q1826557','Q1826582','Q1825147','Q1825016','Q1826328','Q1826350','Q1826287','Q1826442')
order by dtDateLastSOPUpdate
-- 2015-02-24  to 2015-12-23 


/*
ixOrder	    SKU                 flgLineStatus
Q1826557	92615331	        Backordered
Q1826582	7153221-FORD-CHR	Backordered
Q1825147	91645495	        Backordered FS
Q1825016	91015629	        Backordered FS
Q1826328	92620681	        Dropshipped
Q1826350	8351206806BK	    Dropshipped
Q1826287	91123333	        Lost
Q1826442	5002571601	        Lost
*/

SELECT sOrderStatus, COUNT(*)
from [SMI Reporting].dbo.tblOrder
where ixOrder like 'Q%'
group by sOrderStatus
Quote	        412
Cancelled Quote	84776





    SELECT -- 454     records @34 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM [SMI Reporting].dbo.tblCustomer C 
        join PJC_SMIHD5984_LB_AWOL_Customers_wOrders MC on C.ixCustomer = MC.ixCustomer
    WHERE C.ixCustomer in (select distinct custid 
                           from [SMI Reporting].dbo.vwLBSampleTransactions)



select SM.ixCustomer, SUM(O.mMerchandise) Sales
from [SMI Reporting].dbo.tblOrder O
join PJC_SMIHD5984_LB_AWOL_Customers_Still_Unknown SM on O.ixCustomer = SM.ixCustomer
where    O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/01/2015' --between '01/01/2012' and '12/31/2012'
GROUP by SM.ixCustomer
order by SUM(O.mMerchandise) desc





-- approx 75% of the missing customers did not place orders between'01/01/2009' and '10/31/2016'
SELECT DISTINCT O.ixCustomer -- O.ixOrder, dtOrderDate
into PJC_SMIHD5984_LB_AWOL_Customers_wOrders
from [SMI Reporting].dbo.tblOrder O
join PJC_SMIHD5984_LB_AWOL_Customers MC on O.ixCustomer = MC.ixCustomer
where O.sOrderStatus = 'Shipped'
    and O.dtOrderDate between '01/01/2009' and '10/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail'
ORDER BY O.ixCustomer--, O.dtOrderDate
-- 4,283 placed orders '01/01/2009' or later
-- ONLY 1,216 placed orders between '01/01/2009' and '10/31/2016'

    