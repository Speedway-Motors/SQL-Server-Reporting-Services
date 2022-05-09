-- Case 23920 - NE orders to refeed for new shipping address fields

DECLARE @ShippingStartDate datetime,
    @ShippingEndDate datetime,
    @State varchar(2)

SELECT @ShippingStartDate = '09/01/2014',
    @ShippingEndDate = '09/30/2014',
    @State = 'NE'

/***************  REPORT - Detailed Revenue by State   ****************/
-- Orders
SELECT O.ixOrder,                           -- 2050
    --O.dtOrderDate,  O.dtDateLastSOPUpdate, 
    O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToZip,
    C.ixCustomerType,
    -- Price Level  N/A
    C.flgTaxable,
    O.mMerchandise,
    O.mShipping,
    O.mTax,
    O.mMerchandise+O.mShipping+O.mTax as 'Total',
    LTC.sLocalTaxCode,
    LTC.dTaxRate,
    SM.sDescription 'ShipMethod'
FROM tblOrder O---- 24,966 
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
WHERE O.dtOrderDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState = @State -- 'NE'
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE 'PC%'
--ORDER BY O.ixOrder

UNION

-- Credit Memos
SELECT CMM.ixCreditMemo as 'ixOrder', -- O.ixOrder, -- 325
    --O.dtOrderDate,  O.dtDateLastSOPUpdate, 
    CMM.dtCreateDate as 'dtShippedDate',
    --O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToZip,
    C.ixCustomerType,
    -- Price Level  N/A
    C.flgTaxable,
    CMM.mMerchandise,
    CMM.mShipping,
    CMM.mTax,
    CMM.mMerchandise+CMM.mShipping+CMM.mTax as 'Total',
    LTC.sLocalTaxCode,
    LTC.dTaxRate,
    SM.sDescription 'ShipMethod'
FROM tblCreditMemoMaster CMM
         join tblOrder O on CMM.ixOrder = O.ixOrder---- 24,966 
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
    
WHERE CMM.dtCreateDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState = @State -- 'NE'
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE 'PC%'
ORDER BY O.ixOrder

/***********************************************/



/***************  REPORT - Detailed Revenue by State   ****************/
-- Orders
SELECT O.ixOrder,                           -- 2050
    --O.dtOrderDate,  O.dtDateLastSOPUpdate, 
    O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToCity,
    O.sShipToState,
    O.sShipToZip,
    C.ixCustomerType,
    -- Price Level  N/A
    C.flgTaxable,
    SUM(OL.mMerchandise) 'TotGCAmount'
   
FROM tblOrder O---- 24,966 
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
WHERE O.dtOrderDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState = @State -- 'NE'
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE 'PC%'
    AND OL.ixSKU in (
 GROUP BY O.ixOrder,                          
    O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToCity,
    O.sShipToState,
    O.sShipToZip,
    C.ixCustomerType,
    C.flgTaxable
/***********************************************/


select ixSKU, SUM(mExtendedPrice) Sales, SUM(iQuantity) QtySold
from tblOrderLine
where ixSKU like '%GIFT%'
and dtOrderDate >= '01/01/2008'
group by ixSKU
order by SUM(iQuantity) desc





select * from tblOrderLine where ixOrder in 
(select ixOrder from tblOrderLine where ixSKU = 'SRGIFTSURVEY')
order by ixOrder





select ixOrder 
from tblOrder
where sOrderStatus = 'Shipped' -- 218,888
and sShipToCountry = 'US'
and (sShipToZip like '68%'
     or
     sShipToZip like '69%')
     
     
     

-- shipped orders going to NE ...but invalid NE zip
select sShipToState, COUNT(*) Qty
from tblOrder
where sOrderStatus = 'Shipped'
and sShipToCountry = 'US'
and (sShipToZip like '68%'
     or
     sShipToZip like '69%')
group by sShipToState    
/*
sShipToState	Qty
NE	            218,865
NULL	        22
MO	            1

*/

select sShipToState, COUNT(*) Qty
from tblOrder
where sOrderStatus = 'Shipped'
and sShipToCountry = 'US'
and (sShipToZip like '68%'
     or
     sShipToZip like '69%')
group by sShipToState    

    -- details of above
    select ixOrder, ixCustomer, dtShippedDate, iShipMethod, mMerchandise, mShipping, mTax
    from tblOrder
    where sOrderStatus = 'Shipped'
    and sShipToCountry = 'US'
    and (sShipToZip like '68%'
         or
         sShipToZip like '69%')
    and sShipToState is NULL
    order by iShipMethod, dtShippedDate
/*                      dtShipped   iShip
    ixOrder	ixCustomer	Date	    Method	mMerchandise	mShipping	mTax
    4028478	495817	    2012-05-16 	1	            81.96	0.00	0.00
    4906677	185051	    2012-07-23 	1	            134.99	0.00	9.45
    4888393	1658327	    2013-01-04 	1	            1271.81	0.00	89.03
    5054500	1658327	    2013-01-22 	1	            60.98	0.00	4.27
    5358129	1658327	    2013-06-18 	1	            57.80	0.00	4.05
    5176527	1658327	    2013-06-19 	1	            1182.24	0.00	82.76
    5959754	882722	    2014-04-22 	1	            132.94	0.00	9.31
    5170777	416576	    2014-06-20 	1	            134.99	0.00	0.00
    5218379	1468460	    2014-06-26 	1	            148.96	0.00	10.43
    5849071	416576	    2014-08-01 	1	            39.99	0.00	0.00
    5954672	1441779	    2014-08-18 	1	            113.95	0.00	7.98
    2505851	218706	    2006-12-19 	2	            24.95	16.89	2.72
    2767211	465361	    2007-12-17 	2	            0.00	0.00	0.00
    4824928	350561	    2011-07-07 	2	            79.99	0.00	5.60
    4171764	734227	    2012-03-21 	2	            624.99	0.00	43.75
    5984815	1662269	    2013-05-28 	2	            1599.98	0.00	0.00
    5590961	357747	    2014-05-14 	2	            499.99	34.97	37.45
    5663169	357747	    2014-05-15 	2	            499.99	0.00	35.00
    5125185	357747	    2014-08-22 	2	            99.96	18.30	8.28
    3057112	746028	    2008-07-08 	8	            16.00	0.00	0.00
    5006408	1658327	    2013-01-21 	8	            660.96	0.00	46.27
    5588312	1222360	    2013-04-29 	9	            169.97	8.34	0.00
*/
     
group by sShipToState 

-- shipped orders going to NE Ship to...but zip is not a valid NE zip
select *
from tblOrder
where sOrderStatus = 'Shipped'
and sShipToCountry = 'US'
and sShipToState = 'NE'
and (sShipToZip is NULL
     or 
     sShipToZip NOT like '6%'
     )
-- ONLY ONE ORDER   #2587977
     

group by sShipToState   


-- SMI Reporting
/* REFED

YR      REC     STATUS  REC W/O SA1             -- feed speeds appear to be 25K-35K/hour      6.6-10.7 rec/sec
====    ======  ======= ===========
2014    25,005  done    0
2013    28,716  done    0
2012    28,693  done    0
2011            done
'07-'10 78,000          @ 7rec/sec ETA = 8:16PM
*/

select ixOrder from tblOrder ---- 70,375
where dtOrderDate >= '01/01/2007' 
    and sShipToCountry = 'US'
    and sShipToState = 'IN'
    and sOrderStatus = 'Shipped'
    and ixOrder NOT LIKE 'PC%'
    and dtDateLastSOPUpdate < '09/25/2014'
    and sShipToStreetAddress1 is NULL
order by ixOrder

select * from tblOrder
where dtOrderDate >= '01/01/2007'
and sShipToCountry = 'US'
and sShipToState = 'IN'
and sOrderStatus = 'Shipped'
and ixOrder NOT LIKE 'PC%'
and sShipToStreetAddress1 is NULL


select ixOrder, dtShippedDate,dtDateLastSOPUpdate from tblOrder ---- 24,966 
where dtOrderDate >= '01/01/2007' 
    and sShipToCountry = 'US'
    and sShipToState = 'NE'
    and sOrderStatus = 'Shipped'
    and ixOrder NOT LIKE 'PC%'
    and dtDateLastSOPUpdate is NULL -- <= '09/23/2014'
    and sShipToStreetAddress1 is NULL
order by dtDateLastSOPUpdate, ixOrder










select ixOrder from tblOrder ---- 70,375
where dtOrderDate >= '01/01/2007' 
    and sShipToCountry = 'US'
    and sShipToState = 'IN'
    and sOrderStatus = 'Shipped'
    and ixOrder NOT LIKE 'PC%'
  --  and dtDateLastSOPUpdate < '09/23/2014'
    and sShipToStreetAddress1 is NULL
order by ixOrder




select count(*) from tblOrder ---- 70,375 ETA
where dtOrderDate >= '01/01/2007' 
    and sShipToCountry = 'US'
    and sShipToState = 'IN'
    and sOrderStatus = 'Shipped'
    and ixOrder NOT LIKE 'PC%'
    and sShipToStreetAddress1 is NULL
    and dtDateLastSOPUpdate < '09/26/2014'
-- 70,375       ETA 4:53
-- @3:11 34,945     4:53
-- @4:23 21,103     6:10





/* tblLocalTaxCode
ixZipCode   varchar(15)

