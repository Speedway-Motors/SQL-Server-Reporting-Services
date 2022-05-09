-- Case 19165 - Investigate percent Change discrepancy for Ebay orders on Daily Orders Taken Report

-- Spreadsheet info sent to Colby
select ixOrder 'Order', 
    dtOrderDate 'Order Date', 
    sWebOrderID 'Web Order ID',
    sOrderTaker 'Order Taker', 
    sShipToCountry 'Shipto Country' , 
    mMerchandise 'MerchSales', 
    sSourceCodeGiven 'SC Given',
    sMatchbackSourceCode 'Matchback SC'
    from tblOrder O
where UPPER(sOrderChannel) like '%AUCTION%'
    and O.sOrderStatus in ('Shipped','Dropshipped')
    and O.dtOrderDate >= '01/01/2008'
    and (sSourceCodeGiven <> sMatchbackSourceCode
         and sMatchbackSourceCode is NOT NULL) -- identical 97.5% of the time
    --and (O.sWebOrderID  NOT like 'CA%'
      --   OR sWebOrderID IS null)
order by dtOrderDate      
      
      1415 out of 55916 don't match
      

select count(O.ixOrder) OrdCount, SUM(O.mMerchandise) Sales
from tblOrder O
where sOrderChannel = 'AUCTION'
    and O.sOrderStatus = 'Shipped'
    --and O.sOrderType = 'Internal'   -- verify if these should be filtered!
    --and O.mMerchandise <= 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2013' and '07/01/2013'

-- $1,432,959 actual shipped vs. $1,445,418 on DOT report

select SUM(O.mMerchandise) Sales
from tblOrder O
where sOrderChannel = 'AUCTION'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2012' and '07/02/2012'
-- $1,286,395 actual shipped vs. $1,279,748 on DOT report    




SELECT sOrderChannel, COUNT(*)
from tblOrder
where dtOrderDate >= '01/01/2008'
group by sOrderChannel


SELECT sOrderStatus, COUNT(*)
from tblOrder
where dtOrderDate >= '01/01/2008'
group by sOrderStatus
