-- Shipping Revenue by Carrier per Period
SELECT D.iPeriod, SM.ixCarrier, FORMAT(SUM(O.mShipping),'###,###') 'ShippingRev' --  $494,766 What we charged the customer for Shipping
FROM tblOrder O
	left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
	left join tblDate D on O.ixShippedDate = D.ixDate
WHERE D.iPeriodYear = 2022
	and D.iPeriod = 3
	-- dtShippedDate BETWEEN '03/01/2022' AND '03/31/2022' -- P3
	--and iShipMethod in (2,3,4,5,10,11,12,18,19,32) -- UPS
	and sOrderStatus = 'Shipped'
GROUP BY D.iPeriod, SM.ixCarrier
ORDER BY SM.ixCarrier, D.iPeriod--SUM(O.mShipping) DESC
/*
P3 
UPS ShippingRev			  $  495k
UPS Invcd costs per Vicki $1,034k

				Shipping
ixCarrier		Rev
UPS				494,766
USPS			134,508
Misc			 72,253 
SpeeDee			 41,024
OnTrac			 38,428
FedEx			 35,199
DHL Express		 27,063
DHL Global Mail	 15,536
SMI				 	 0
*/

/*
Here's what Vicki has for the different carriers in P3:
Spee-dee: $141K   -100k
USPS: $152K	      - 18k
DHL: $56.6K		  - 15k
FEDEX: $108K	  - 73k
ONTRAC: $46.5k    -  8k
UPS: $1,034k      -540k
				========
				  -754k for P3 !?!
*/

select ixShipMethod 'SM', sDescription 'ShipMethodDescription', ixCarrier 'Carrier'
from tblShipMethod
where ixCarrier NOT IN ('UPS')
order by ixCarrier, ixShipMethod


Select *
from tblDate where iPeriod = 1
and iPeriodYear = 2022
