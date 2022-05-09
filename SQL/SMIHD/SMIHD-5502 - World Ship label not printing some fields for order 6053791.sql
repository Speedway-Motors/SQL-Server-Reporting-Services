-- SMIHD-5502 - World Ship label not printing some fields for order 6053791

select ixOrder, ixCustomer, sShipToCountry, dtOrderDate, dtShippedDate
from tblOrder O where ixOrder = '6053791'
/*
ixOrder	ixCustomer	sShipToCountry	dtOrderDate	            dtShippedDate
6053791	2842562	    BARBADOS	    2016-09-20 00:00:00.000	2016-09-21 00:00:00.000
*/


select ixSKU, flgLineStatus
from tblOrderLine 
where ixOrder = '6053791'
/*
ixSKU	        flgLineStatus
91032234	    Shipped
91032289-1.50	Shipped
91088512-99	    Shipped
91632201-48	    Shipped
HELP	        Shipped
READNOTE	    Shipped
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








