-- SMIHD-9777 - research calculations for revenue (amount) field being sent to LB

SELECT O.ixOrder, O.ixCustomer, O.mMerchandise, O.sOrderType,  count(OL.iOrdinality) 
FROM tblOrderPromoCodeXref OPX
	join tblOrder O on OPX.ixOrder = O.ixOrder
	join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.dtOrderDate = '12/28/17'
	and O.sOrderStatus = 'Shipped'
	and O.mMerchandise between 250 and 300
group by O.ixOrder, O.ixCustomer, O.mMerchandise, O.sOrderType
having count(OL.iOrdinality)   = 1
/*
ixOrder	Cust	mMerchandise
7255561	2303389	260.99	Retail	1

*/

select * from tblSKUPromo
where ixOrder = '7255561'
/*
ixOrder	mPrePromoUnitPrice	mFinalUnitPrice
7255561	289.99				260.99
*/

select ixOrder, ixSKU, mExtendedPrice 
from tblOrderLine where ixOrder =  '7255561'
/*
ixOrder	ixSKU	mExtendedPrice
7255561	UP84222	260.99
*/

SELECT * FROM vwLBSampleTransactions
WHERE itemid = 'UP84222'
/*
custid	itemid	txdate		quantity	amount	order_channel
2303389	UP84222	12/28/2017	1			260.99	WEB
*/
