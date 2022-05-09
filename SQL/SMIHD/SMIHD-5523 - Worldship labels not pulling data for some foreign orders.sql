-- SMIHD-5523 - Worldship labels not pulling data for some foreign orders

select ixOrder, ixCustomer, sShipToCountry, dtOrderDate, dtShippedDate
from tblOrder O where ixOrder in ('6043697','6053791','6197692','6193296')
/*
ixOrder	ixCustomer	sShipToCountry	dtOrderDate	  dtShippedDate
6043697	2815562 	BRAZIL	        2016-09-26    2016-09-29   
6053791	2842562	    BARBADOS	    2016-09-20    2016-09-21   
6193296	2223668	    TURKEY	        2016-09-26    2016-09-28   
6197692	2895760	    QATAR	        2016-09-27    2016-09-28   
*/


select OL.ixOrder, O.sOrderStatus, O.sOrderTaker,
CONVERT(VARCHAR, O.dtOrderDate, 101) as 'OrderDate',
CONVERT(VARCHAR, O.dtShippedDate, 101) as 'ShippedDate',
C.sCustomerType, C.ixCustomerType,
OL.ixSKU, OL.flgLineStatus,
sDescription, flgAdditionalHandling, flgShipAloneStatus, flgIntangible, flgORMD, sHandlingCode, sCountryOfOrigin, ixHarmonizedTariffCode, dWeight, iLength, iWidth, iHeight, dDimWeight
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblCustomer C on C.ixCustomer = O.ixCustomer 
where OL.ixOrder in ('6043697','6053791','6197692','6193296')--,'6030295','6097098')
order by OL.ixSKU --OL.ixOrder, iOrdinality
/*
ixOrder ixSKU	        flgLineStatus
6043697	91015904	Shipped
6043697	91015900	Shipped
6043697	91015361-020	Shipped
6043697	9101536-020	Shipped
6043697	COMINVOICE	Shipped
6043697	UPSSIGN	Shipped
6043697	HELP	Shipped
6043697	READNOTE	Shipped
6043697	READNOTE	Shipped
6053791	91032289-1.50	Shipped
6053791	91632201-48	Shipped
6053791	91032234	Shipped
6053791	91088512-99	Shipped
6053791	HELP	Shipped
6053791	READNOTE	Shipped
6193296	66582623B	Shipped
6193296	HELP	Shipped
6193296	READNOTE	Shipped
6197692	91032287	Shipped
6197692	91032302	Shipped
6197692	91032247	Shipped
6197692	READNOTE	Shipped
6197692	HELP	Shipped
6197692	COMINVOICE	Shipped
*/

select ixSKU, sDescription, flgAdditionalHandling, ixHarmonizedTariffCode, flgShipAloneStatus, flgIntangible, sCountryOfOrigin
from tblSKU 
where ixSKU in ('91032289-1.50','91632201-48','91032234','91088512-99','HELP','READNOTE')
/*
ixSKU	        sDescription	                flgAdditionalHandling	ixHarmonizedTariffCode	flgShipAloneStatus	flgIntangible	sCountryOfOrigin
91032234	    U-JOINT, 3/4" WELD-ON	        0	8708947550	0	0	US
91032289-1.50	STEER COL MT 6-3/4in	        0	8708947550	0	0	US
91088512-99	    2016 STREET CATALOG #5	        0	NULL	0	0	US
91632201-48	    3/4"x .120 STEERING SHAFT	    1	8708947550	0	0	US
HELP	        RETURN TO MAKER	                0	4911100050	0	1	US
READNOTE	    PLEASE READ NOTE AT BOTTOM	    0	4911100050	0	1	US
*/


SELECT * from tblCustomer
where ixCustomer in ('2815562','2842562','2223668','2895760')





