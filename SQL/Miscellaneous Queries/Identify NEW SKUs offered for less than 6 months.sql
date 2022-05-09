-- Identify NEW SKUs offered for less than 6 months

-- LOOK UP VPH TO DETERMINE LIST OF CATALOGS... reverse engineer to determine active date of oldest catalog
select SKU.ixSKU, 
    SKU.sDescription, 
    CONVERT(VARCHAR, SKU.dtCreateDate, 102)  AS 'Created',
    MIN(O.dtOrderDate)  AS 'FirstSoldRetail'
FROM tblSKU SKU 
    LEFT JOIN tblOrderLine OL on SKU.ixSKU = OL.ixSKU 
                                and flgKitComponent = 0
                                and flgLineStatus = 'Shipped'
    LEFT JOIN tblOrder O on O.ixOrder = OL.ixOrder
                        and O.sOrderStatus = 'Shipped'
                        and O.sOrderType = 'Retail'
where SKU.flgDeletedFromSOP = 0
    and SKU.flgActive = 0 -- 103,219
GROUP BY SKU.ixSKU, SKU.sDescription, CONVERT(VARCHAR, SKU.dtCreateDate, 102) 

/*
103,219 Active SKUs
 51,967 have sales as non-kit componenets
 
 On table sku we do have a column called dtDateFirstMadeWebActive, it goes back to 4/8/2015. So that might be what we are looking for.
 
*/

