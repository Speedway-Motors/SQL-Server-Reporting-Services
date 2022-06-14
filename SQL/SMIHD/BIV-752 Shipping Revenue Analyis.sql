/*BIV-752 Shipping Revenue Analyis

compare what we charge customers and what UPS is charging us

STILL NEED:

 expected SHIPPING cost at time of order
 label SHIPPING cost at time of shipment 
 
 */

SELECT O.ixOrder 'OrderNumber', -- 164,205 ORDERS
		O.dtShippedDate 'ShipDate',
		SM.sDescription 'ShipMethod',
		O.mMerchandise, -- what we charged the customer for merch
		O.mMerchandiseCost, -- our merch cost.   As far as I know, SOP doesn't do any LANDED COST calculations
		O.mShipping 'ShippingRevenue', -- What we charged the customer for Shipping
		ESC.TotEstScaleShippingCost -- check with Connie on this field to detemine when and how it's populated. It's NULL or 0 about 5% of the time YTD for these ship methods  
FROM tblOrder O
	left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
	left join (-- Est Shipping Cost
				select ixOrder, 
					SUM(mSMIEstScaleShippingCost) 'TotEstScaleShippingCost' 
				from tblPackage 
				where flgCanceled = 0
					and flgReplaced = 0
				group by ixOrder
			  ) ESC on ESC.ixOrder = O.ixOrder
WHERE dtShippedDate BETWEEN '02/25/2022' AND '05/23/2022'
	and sOrderStatus = 'Shipped'
	and iShipMethod in (2,3,4,5,10,11,12,18,19,32) -- UPS
	and mMerchandise > 0
ORDER BY ESC.TotEstScaleShippingCost

/*
select * 
from tblPackage 
where ixOrder in ('11756001','11099627','11301127','11407604')


SELECT  mSMIEstScaleShippingCost 
from tblPackage
where mSMIEstScaleShippingCost is NOT NULL
and ixShipDate >= 19725 --'01/01/2022'


SELECT  mPublishedFreight -- NO VALUES
from tblPackage
where mPublishedFreight is NOT NULL
and ixShipDate >= 19725 --'01/01/2022'


SELECT  mShippingCost -- NO VALUES
from tblPackage
where mShippingCost is NOT NULL
and ixShipDate >= 19725 --'01/01/2022'


select ixShipMethod 'SM', sDescription 'ShipMethodDescription', ixCarrier 'Carrier'
from tblShipMethod
where ixCarrier = 'UPS'
order by ixCarrier, ixShipMethod

	ixShip
	Method	sDescription			ixCarrier
	======	======================	=========
	2		UPS Ground				UPS			
	3		UPS 2 Day (Blue)		UPS		
	4		UPS 1 Day (Red)			UPS	
	5		UPS 3 Day				UPS	
	10		UPS Worldwide Expedited	UPS	
	11		UPS Worldwide Saver		UPS	
	12		UPS Standard			UPS	
	18		UPS SurePost			UPS	
	19		Canada Post				UPS	
	32		UPS 2 Day Economy		UPS
*/


SELECT  mPublishedFreight -- NO VALUES
from tblPackage
where mPublishedFreight is NULL
and ixShipDate >= 19725 --'01/01/2022'
and flgCanceled = 0
and flgReplaced = 0



select P.ixOrder, O.iShipMethod,
					SUM(mSMIEstScaleShippingCost) 'TotEstScaleShippingCost' 
				from tblPackage  P
					left join tblOrder O on P.ixOrder = O.ixOrder
				where P.flgCanceled = 0
					and P.flgReplaced = 0
					and O.dtShippedDate BETWEEN '02/25/2022' AND '05/23/2022'
					and O.sOrderStatus = 'Shipped'
					and O.iShipMethod <> 1 -- in (2,3,4,5,10,11,12,18,19,32) -- UPS
					and O.mMerchandise > 0
				group by P.ixOrder, O.iShipMethod
order by SUM(mSMIEstScaleShippingCost), O.iShipMethod

-- 238k orders 667 

-- factory shipped