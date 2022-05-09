-- SMIHD-4466 - Order Data for retail PHONE orders w shipping charge

-- tblOrderFreeShippingEligible CONTAINS NO DATA

SELECT COUNT(O.ixOrder)
FROM tblOrder O
WHERE O.dtOrderDate >= '01/01/2016'                 
    and O.sOrderStatus = 'Shipped'                 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- 224,793
    and O.sOrderChannel = 'PHONE'    --  84,354
    and O.iShipMethod <> 1           --  82,837
    and O.mShipping = 0              --  39,417
    and O.sOrderType = 'Retail'      --  35,077
    
SELECT * FROM tblOrderFreeShippingEligible

SELECT distinct sOrderType from tblOrder
/*
Customer Service
Internal
MRR
PRS
Retail
*/
SELECT * from tblShipMethod

-- Date Entered	Order Number	Total number of Skus on Order	Merchandise Total	Shipping Cost	Shipping Method

SELECT dtOrderDate 'OrderDate', 
    ixOrder 'Order', 
    iTotalTangibleLines 'TangibleLineItems', 
    mMerchandise 'TotalMerchandise', 
    mShipping 'Shipping', 
    iShipMethod 'ShipMethod',
    dtShippedDate 'ShippedDate', 
    iTotalShippedPackages 'ShippedPkgs', 
    ixCustomer 'Customer', 
    sShipToState 'ShipToState', 
    sOrderTaker 'OrderTaker', 
    sSourceCodeGiven 'SC Given', 
    sMatchbackSourceCode 'Matchback SC'
FROM tblOrder O
WHERE O.dtOrderDate >= '01/01/2016'                 
    and O.sOrderStatus = 'Shipped'                 
    and O.mMerchandise > 0 
    and O.sOrderType <> 'Internal'   
    and O.sOrderChannel = 'PHONE'    
    and O.iShipMethod <> 1           
    and O.mShipping > 0          
    and O.sOrderType = 'Retail'      
    and O.iTotalShippedPackages > 0  
    and O.iTotalTangibleLines > 0
    and O.sShipToCountry = 'US'
order by OrderDate    
    
SELECT m
FROM tblOrder    