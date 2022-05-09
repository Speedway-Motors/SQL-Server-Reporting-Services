-- SMIHD-19801 - Speedway - Marketing - Crate Engine SKUs Report
/*

This is a good start, you can refine it from there.
The truck might be optional
*/
select s.ixSOPSKU, s.mPromoShippingCharge, s.mPromoShippingCharge, s.sShippingCode, s.* 
from tng.tblskuvariant s 
where s.ixSOPSKU in ('227BP38313CTC1D','35519370416')

like '227B%' 

s.mPromoShippingCharge is not null 
and mPromoShippingCharge <> 0 
and sShippingCode = 'tr'




