-- Employee Purchases
SELECT O.ixCustomer, C.ixCustomerType, C.sCustomerType, C.sCustomerFirstName, C.sCustomerLastName,
  O.ixOrder, O.sOrderStatus, O.sOrderChannel,
 -- OL.mExtendedPrice, 
 OL.iOrdinality,
 OL.iQuantity,
 OL.ixSKU,
 OL.mUnitPrice,   -- VERIFY THERE IS NOT A CARTESION FROM JOINING TO TBLORDERLINE!
  (OL.iQuantity * S.mPriceLevel1) 'PLVL1',
  OL.mSystemUnitPrice
FROM tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    join tblEmployee E on O.ixCustomer = E.ixCustomer
    join tblSKU S on S.ixSKU = OL.ixSKU
    join tblCustomer C on E.ixCustomer = C.ixCustomer
WHERE O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    -- and C.ixCustomer = 1170307 AL
    and O.ixOrderDate > = 18401
    --and OL.mSystemUnitPrice <> OL.mUnitPrice          --   980
ORDER BY O.sOrderChannel, OL.ixOrder, OL.iOrdinality


SELECT O.ixCustomer, C.sCustomerLastName, C.sCustomerFirstName, 
-- O.sOrderChannel,  -- D.iYear,
    FORMAT(SUM(O.mMerchandise),'$##,###') 'TotalSales', 
    FORMAT(SUM(O.mMerchandiseCost),'$##,###') 'TotalMerchCost',
    FORMAT(SUM(O.mMerchandise)-SUM(O.mMerchandiseCost),'$###,###') 'GP$',
    COUNT(O.ixOrder) 'Orders'
FROM --tblOrderLine OL    join 
tblOrder O-- on O.ixOrder = OL.ixOrder
    join tblEmployee E on O.ixCustomer = E.ixCustomer
   -- join tblSKU S on S.ixSKU = OL.ixSKU
    join tblCustomer C on E.ixCustomer = C.ixCustomer
    join tblDate D on D.ixDate = O.ixOrderDate
WHERE O.sOrderStatus = 'Shipped'
  --  and OL.flgLineStatus in ('Shipped','Dropshipped')
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.ixOrderDate between 18146 and 18510-- 18146=09/05/2017     17533=01/01/2016
    --and O.sOrderChannel = 'AUCTION'
   -- AND O.ixCustomer = 113229
GROUP BY  O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
-- , O.sOrderChannel  , D.iYear
-- HAVING SUM(O.mMerchandiseCost) > (SUM(O.mMerchandise))
    -- or COUNT(O.ixOrder) > 2 -- 
ORDER BY C.sCustomerLastName,  C.sCustomerFirstName
   -- ,D.iYear
/*
ixDate Date
18147 09/06/2017
18146 09/05/2017
17899 01/01/2017
17533 01/01/2016
17168 01/01/2015
*/

SELECT * FROM tblOrderLine

SELECT distinct sOrderStatus FROM tblOrder

SELECT count(OL.ixSKU) 
FROM tblOrderLine OL
    join tblCustomer C on C.ixCustomer = OL.ixCustomer
WHERE OL.mUnitPrice > 0 
and C.ixCustomerType = '44'
and OL.ixOrderDate > = 17899
and OL.flgLineStatus in ('Shipped','Dropshipped') -- 9,083
and OL.mSystemUnitPrice <> OL.mUnitPrice          --   980



SELECT --O.ixCustomer, C.sCustomerLastName, C.sCustomerFirstName, O.sOrderChannel,  
-- D.iYear,
FORMAT(SUM(O.mMerchandise),'$##,###') 'TotalSales', 
FORMAT(SUM(O.mMerchandiseCost),'$##,###') 'TotalMerchCost',
COUNT(O.ixOrder) 'Orders'
FROM tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblEmployee E on O.ixCustomer = E.ixCustomer
    join tblSKU S on S.ixSKU = OL.ixSKU
   -- join tblCustomer C on E.ixCustomer = C.ixCustomer
    join tblDate D on D.ixDate = O.ixOrderDate
WHERE O.sOrderStatus = 'Shipped'
    and O.sOrderChannel = 'AUCTION'
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and O.ixOrderDate > 17168	-- 09/06/2017
    and E.ixCustomer is NULL
--GROUP BY  O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName , O.sOrderChannel  
-- , D.iYear
HAVING SUM(O.mMerchandiseCost) > (SUM(O.mMerchandise))
    -- or COUNT(O.ixOrder) > 2 -- 
ORDER BY C.sCustomerLastName,  C.sCustomerFirstName
 -- O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
    -- ,D.iYear
