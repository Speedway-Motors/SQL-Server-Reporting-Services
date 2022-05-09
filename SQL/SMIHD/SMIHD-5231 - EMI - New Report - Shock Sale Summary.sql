-- SMIHD-5231 - EMI - New Report - Shock Sale Summary


DECLARE   @StartDate datetime,      @EndDate datetime
SELECT    @StartDate = '01/01/16',  @EndDate = '07/31/16'  

SELECT S.ixBrand
   , B.sBrandDescription
    , OL.ixSKU
    , S.sDescription
    , OL.iQuantity
    , OL.mUnitPrice
    , OL.mExtendedPrice
    , OL.mExtendedCost
    , O.sOrderTaker    
    , O.ixOrder
    --, O.dtOrderDate, O.ixCustomer, O.ixCustomerType
    , O.sSourceCodeGiven
    , S.ixPGC
FROM vwEagleOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    LEFT JOIN vwEagleOrderLine OL ON OL.ixOrder = O.ixOrder  
                             AND OL.flgKitComponent = '0'   
    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
   LEFT JOIN tblBrand B on S.ixBrand = B.ixBrand
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
  AND O.sOrderTaker IN ('AJE','FWG','JTM','KAV','KDL','KRV','MAK1','MAL','MAL1','MAL2')
  AND (  S.ixPGC in ('kG','kI','kO','kP','kR','kS','kT')-- All SKUs assigned to those PGCs SHOULD be Afco SKUs, this should pick up SKUs with incorrect Brand values
        OR
        S.ixBrand in ('10015', '10022','10038', '10048', '10063', '10810') -- AFCO Brands
        OR 
        S.ixSKU in ('4941000', '4942000', '90007', '90037', '7219000', '7219100', '5821000', '5821001', '5821002', -- Labor SKUs
                    '21340199') -- MISC USED SHOCK PARTS
      )
       
SELECT * from tblSKU where ixSKU = '21340199' -- MISC USED SHOCK PARTS      
SELECT * from tblBrand where ixBrand in ('10015', '10022','10038', '10048', '10063', '10066','10810') 	-- Bilstein & QA1
/*
ixBrand	sBrandDescription
10015	Bilstein
10022	Pro Shocks
10038	AFCO
10048	QA1
10063	US Brake
10066	Dynatech <-- remove this one per Mike Long
10810	Competition Suspension
*/

select * from tblPGC where ixPGC IN ('ks','kS')
