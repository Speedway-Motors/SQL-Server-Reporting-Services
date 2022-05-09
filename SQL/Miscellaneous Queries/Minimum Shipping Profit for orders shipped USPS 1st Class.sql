-- Minimum Shipping Profit for orders shipped USPS 1st Class
SELECT COUNT(O.ixOrder) 'OrdersShipped', 
       CONVERT(INT,ROUND(SUM(mShipping), 0)) 'ShippingCharged', 
       CONVERT(INT,ROUND(COUNT(O.ixOrder)*3.60, 0)) 'SMI_MaxCost',           
       CONVERT(INT,ROUND(SUM(mShipping)-(COUNT(O.ixOrder)*3.60), 0))  'MinimumSHProfit',            
       CONVERT(INT,ROUND(SUM(mShipping)-(COUNT(O.ixOrder)*2.86), 0))  'EstAvgSHProfit',   -- Estimated avg from Al on @9/28/16      
       --     CONVERT(INT, ROUND(SUM(mMerchandise), -3)) 'Sales'
       GETDATE() 'AsOf'
FROM tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate > '08/25/2016' -- first full day of First Class Shipping was FRI 8/26/16
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.iShipMethod = 20 

/**********  results THUR 8-25-2016 forward     **********

Orders  Shipping    SMI     Minimum     Est. Avg
Shipped	Charged	    MaxCost	SHProfit    SHProfit    As Of
======= ========    ======= ========    ========    ================
8,331	53,675	    29,992	23,683	    29,848	    2016-10-28 15:44:42.177
4,370	28,212	    15,732	12,480	    15,714      2016-09-28 16:20 -- avg min SHprofit = $378/day,  Est avg SHProfit = $476/day --> annual savings $138k-$173k /year !
1,635	10,524	    5,886	4,638	                2016-09-09 12:46 
  612    3,950	    2,203	1,747	                2016-09-01 10:58 
  397    2,572	    1,429	1,143	                2016-08-30 15:14
  180    1,196	      648     548                   2016-08-29 10:37






SELECT * FROM tblShipMethod
WHERE ixShipMethod = 20

ixShip
Method	sDescription	        ixCarrier	sTransportMethod
20	    USPS First Class Mail	USPS	    Air/Ground
***********************************************************/

