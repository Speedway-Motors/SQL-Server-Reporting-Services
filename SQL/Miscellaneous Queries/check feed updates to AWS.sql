-- check feed updates to AWS

SELECT FORMAT(count(*),'###,###'), --' AsOf ', 
    FORMAT(GETDATE(),'hh:mm')
FROM SmiReportingRawData.Transfer.tblOrder
WHERE mPaymentProcessingFee is NOT NULL
/*
TARGET      AS OF
=======     =====
314,526	    04:36

CURRENT
=========   =====
314,497	    09:36


*/

SELECT FORMAT(count(*),'###,###'), --' AsOf ', 
    FORMAT(GETDATE(),'hh:mm')
FROM SmiReportingRawData.Transfer.tblOrder
WHERE mMarketplaceSellingFee is NOT NULL

/*
TARGET      AS OF
=======     =====
82,207	    04:37
53,811	    04:34

CURRENT
=========   =====
53,795	    09:47
3,789	    09:39





         DUR            
REC     (min)    roughly 50k every 10 mins
======= ======
  2k    10    <-- min duration regardless of QTY
 67k    15
 96K    17
111k    20
150k    26
157k    22
173k    20
181k    23 
204k    25-30



*/



