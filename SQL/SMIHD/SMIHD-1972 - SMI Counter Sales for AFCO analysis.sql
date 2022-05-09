-- SMI-1972 SMI Counter Sales for AFCO analysis
/*
DECLARE
    @EndDate datetime

SELECT
    @EndDate = '07/31/15'  
 */

SELECT DISTINCT C.ixCustomer
/*C.ixCustomer 'CustNum'
	 , C.sCustomerFirstName AS 'FirstName'
	 , C.sCustomerLastName AS 'LastName'
	 , C.sCustomerType + ' - ' + CT.sDescription AS 'CurrentCustType'
	 , C.iPriceLevel AS 'CurentPriceLevel'
	 , OL.ixSKU 'SKU'
	 , SKU.sDescription AS 'SKUDescription'
	 , OL.flgKitComponent 'KitComponent'
	 , OL.ixOrder 'Order'
	 , O.dtOrderDate 'OrderDate'
	 , D.sMonth 'Month'
	 , D.iMonth 'MonthNum'
	-- , AVS.sVendorSKU AS 'AFCOSKU'
	-- , ASKU.sDescription AS 'AFCOSKUDescription'
	 , SUM(CASE WHEN OL.dtOrderDate BETWEEN '08/01/2014' and '07/31/2015' THEN (OL.iQuantity) ELSE 0 END) AS '0-12 Qty'
	 , SUM(CASE WHEN OL.dtOrderDate BETWEEN '08/01/2014' and '07/31/2015' THEN (OL.mExtendedPrice) ELSE 0 END) AS '0-12 Rev'
	 , SUM(CASE WHEN OL.dtOrderDate BETWEEN '08/01/2014' and '07/31/2015' THEN (OL.mExtendedCost) ELSE 0 END) AS '0-12 Cost'
	 */
FROM tblOrderLine OL
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
LEFT JOIN tblSKU SKU ON SKU.ixSKU = OL.ixSKU
LEFT JOIN tblDate D on D.ixDate = O.ixOrderDate
JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN  tblCustomerType CT ON CT.ixCustomerType = C.ixCustomerType
--LEFT JOIN [AFCOReporting].dbo.tblVendorSKU AVS on AVS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
--LEFT JOIN [AFCOReporting].dbo.tblSKU ASKU on ASKU.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS= AVS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE 
    O.iShipMethod = 1
    
    AND O.sOrderType <> 'Internal'
    --AND C.sCustomerType = 'Retail' -- per JEF ALL customer types
	AND OL.dtOrderDate BETWEEN '08/01/2014' and '07/31/2015' 
	-- AND OL.flgKitComponent = 0
	AND OL.flgLineStatus IN ('Shipped', 'Open', 'Dropshipped')
	AND SKU.flgIntangible = 0
GROUP BY C.ixCustomer 
	   , C.sCustomerFirstName
	   , C.sCustomerLastName
	   , C.sCustomerType + ' - ' + CT.sDescription 
	   , C.iPriceLevel
	   , OL.ixSKU
	   , OL.ixOrder
	   , SKU.sDescription
	   , OL.flgKitComponent
	   , O.dtOrderDate
	   , D.sMonth
	   , D.iMonth
	   --, AVS.sVendorSKU 
	   --, ASKU.sDescription
ORDER BY OL.ixSKU, OL.ixOrder
     --  , ixCustomer
     
/*     
SELECT * from tblVendor
where UPPER(sName) like '%AFCO%'   
or UPPER(sName) like '%DYNA%'    


0106	AFCO RACING
0108	AFCO-SPECIAL ORDER
0126	AFCO BUY BACK
0311	DYNATECH
0313	DYNATECH-FACTORY SHIP
9106	AFCO-GS
9311	DYNATECH-GS
*/
