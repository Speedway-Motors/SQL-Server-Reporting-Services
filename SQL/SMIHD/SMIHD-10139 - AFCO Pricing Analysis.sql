-- SMIHD-10139 - AFCO Pricing Analysis

/* from CCC
We need to know the following: what would the cost impact to Speedway be in 2017 If we purchased product at the 
same pricing levels as Summit or Motorstate.

i.e. we need the following data from the AFCO DB based on purchases by customer 10511 (Speedway):

                                        Sum of              Sum of GM
                                        Revenue
    Sum of          Sum of      Sum of  using Motorstate    using Summit 
    Qty Purchased   Revenue     COGS    Level 5 pricing     Level 5 pricing
SKU by SMI in '17                       (CAT= MS2017)       (CAT==COP317)
=== ==============  =======     ======  =================   ===============
Abc	100	            $5,000	    $2,500	$4,500	            $4,300
*/

SELECT ixCustomer, sCustomerFirstName FROM tblCustomer where ixCustomer = 10511
/*          sCustomer
ixCustomer	FirstName
10511	    SMI
*/

select * from tblOrder 
where dtOrderDate between '01/01/2017' and '12/31/2017'
and ixCustomer = 10511  -- 413 orders


SELECT sOrderStatus, count(ixOrder)
from tblOrder 
where dtOrderDate between '01/01/2017' and '12/31/2017'
and ixCustomer = 10511
group by sOrderStatus
/*
sOrder
Status	        Qty
Shipped	        382
Backordered	    3
Cancelled Quote	10
Cancelled	    18
*/

-- all AFCO Orders for Act 10511 shipped in 2017
select * 
into [SMITemp].dbo.SMIHD10139_2017_AFCOOrder_Act10511
from tblOrder 
where dtOrderDate between '01/01/2017' and '12/31/2017'
and ixCustomer = 10511  
and sOrderStatus = 'Shipped' -- 382

-- OrderLine data for all AFCO Orders for Act 10511 shipped in 2017
-- DROP TABLE [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511
select OL.* 
into [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511
from tblOrderLine OL
    join [SMITemp].dbo.SMIHD10139_2017_AFCOOrder_Act10511 O on OL.ixOrder = O.ixOrder  -- 3798
where OL.flgLineStatus = 'Shipped'

    select count(*) from tblOrderLine 
    where flgLineStatus = 'Shipped' 
        AND ixOrder in (select ixOrder from [SMITemp].dbo.SMIHD10139_2017_AFCOOrder_Act10511) -- 3798v

select distinct ixSKU
from [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511 -- 1,435

select SUM(mExtendedCost) 'TotCost', SUM(mExtendedPrice) 'TotPrice'
from [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511
/*
TotCost	    TotPrice
859,116	    1,530,149
*/

-- Order totals match SUM of OL
select SUM(mMerchandiseCost) 'TotCost', SUM(mMerchandise) 'TotPrice'
from [SMITemp].dbo.SMIHD10139_2017_AFCOOrder_Act10511
/*
TotCost	    TotPrice
859,116v	1,530,149v
*/


SELECT * FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511
ORDER BY mExtendedCost


SELECT * FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511
ORDER BY flgLineStatus

SELECT * FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511 WHERE flgKitComponent = 1 -- NONE

SELECT TOP 10 * FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511

SELECT AOL.ixSKU
    , SUM(AOL.iQuantity) 'TotQtyPurchased'
    , SUM(mExtendedPrice)'TotRev'
    , SUM(mExtendedCost) 'TotCost'
    , CD.mPriceLevel5 'MotorstateUnitPL5'
    , CD2.mPriceLevel5 'SummitUnitPL5'
from [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511 AOL
    left join [AFCOReporting].dbo.tblCatalogDetail CD on CD.ixCatalog = 'MS2017' and CD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = AOL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    left join [AFCOReporting].dbo.tblCatalogDetail CD2 on CD2.ixCatalog = 'COP317' and CD2.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = AOL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
group by AOL.ixSKU
    , CD.mPriceLevel5
    , CD2.mPriceLevel5



-- FUBAR! convert AFCO SKU to SMI SKU
SELECT distinct V.ixVendor, V.sName 
FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511 AOL
left join [SMI Reporting].dbo.tblVendorSKU VS on VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS = AOL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
left join [SMI Reporting].dbo.tblVendor V on VS.ixVendor = V.ixVendor --and VS.iOrdinality = 1
order by sName

select * from tblCatalogMaster
where ixCatalog in ('MS2017','COP317')
/*
ixCatalog	sDescription	dtStartDate	dtEndDate	sMarket
COP317	    3% AD CO-OP	    2016-11-28 00:00:00.000	2018-01-11 00:00:00.000	M
MS2017	    MOTORSTATE 2017	2016-11-28 00:00:00.000	2017-12-31 00:00:00.000	M
*/


select ixCatalog, count(*) 'Qty'
from tblCatalogDetail
where ixCatalog in ('MS2017','COP317')
group by ixCatalog
/*
ixCatalog	Qty
COP317	    18858
MS2017	    18880
*/

SELECT COUNT(*) FROM [SMITemp].dbo.SMIHD10139_2017_AFCOOrderLine_Act10511 -- 3798
-- WHERE ixSKU NOT IN (Select ixSKU from tblCatalogDetail where ixCatalog = 'COP317') -- 1,060
WHERE ixSKU NOT IN (Select ixSKU from tblCatalogDetail where ixCatalog = 'MS2017') -- 1,060

