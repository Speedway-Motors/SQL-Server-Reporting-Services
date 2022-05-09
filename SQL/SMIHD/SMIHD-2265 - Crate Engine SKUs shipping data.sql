-- SMIHD-2265 - Crate Engine SKUs shipping data

SELECT COUNT(CE.ixSKU) Qty, COUNT(distinct CE.ixSKU) DistQty
from dbo.PJC_SMIHD_2265_CrateEngineSKUs CE
/*
Qty	DistQty
145	145
*/


-- only 127 of the SKUs are in tblSKU
SELECT CE.ixSKU, SKU.sDescription, SKU.sSEMACategory, sSEMASubCategory, sSEMAPart
from dbo.PJC_SMIHD_2265_CrateEngineSKUs CE
left join [SMI Reporting].dbo.tblSKU SKU on CE.ixSKU = SKU.ixSKU
where SKU.ixSKU is NULL

-- doesn't appear that the missing SKUs were truncated, however some of them start with 0
select * from [SMI Reporting].dbo.tblSKU
where ixSKU like '%035519244450%'

-- there are 115 more SKUs with the sSEMAPart of Crate Engines that were not on Kevin's list
select ixSKU, sDescription, ixPGC, SKU.sSEMACategory, sSEMASubCategory, sSEMAPart
from [SMI Reporting].dbo.tblSKU SKU
where sSEMAPart = 'Crate Engines'
and flgDeletedFromSOP = 0




Select ixOrder 'Order', ixCustomer 'Customer', 
    sOrderType 'OrderType',     ixCustomerType 'CustType', sOrderChannel'OrdChannel',
    iShipMethod 'ShipMethod', 
    mMerchandise 'Merch', mShipping 'Shipping', 
    mTax, mCredits, 
    mMerchandiseCost, 
    CONVERT(VARCHAR(10), dtOrderDate, 101) OrderDate,
    CONVERT(VARCHAR(10), dtShippedDate, 101) ShippedDate, 
    sWebOrderID, 
    iTotalTangibleLines, iTotalShippedPackages ,
    sSourceCodeGiven 'SourceCodeGiven', --sMethodOfPayment, 
    sOrderTaker 'OrderTaker'    
from [SMI Reporting].dbo.tblOrder O  -- 116 orders
where dtShippedDate between '07/15/2015' and '09/14/2015'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
    and ixOrder in (select distinct ixOrder 
                     from [SMI Reporting].dbo.tblOrderLine
                     where flgLineStatus = 'Shipped'
                        and iShipMethod <> 1 -- Counter
                        and ixSKU in (-- crate engine SKUs
                                    select ixSKU--, sDescription, ixPGC, SKU.sSEMACategory, sSEMASubCategory, sSEMAPart
                                    from [SMI Reporting].dbo.tblSKU SKU
                                    where sSEMAPart = 'Crate Engines'
                                        and flgDeletedFromSOP = 0
                                    )
                  )




select * from [SMI Reporting].dbo.tblShipMethod

select distinct flgLineStatus from [SMI Reporting].dbo.tblOrderLine

select iTotalOrderLines, count(*)
from  [SMI Reporting].dbo.tblOrder
group by iTotalOrderLines