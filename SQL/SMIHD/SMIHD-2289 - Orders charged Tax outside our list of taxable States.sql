-- SMIHD-2289 - Orders charged Tax outside our list of taxable States
DECLARE
    @ShippingStartDate datetime,
    @ShippingEndDate datetime


SELECT
    @ShippingStartDate = '01/01/15',
    @ShippingEndDate = '12/31/15'


SELECT * 
FROM tblOrder O---- 24,966 
WHERE O.dtShippedDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState NOT in ('NE','IN','WA','KY')-- ('SD','IA','MO','IL','MN','KS')
    and O.sOrderStatus = 'Shipped'
    AND O.mTax > 0 