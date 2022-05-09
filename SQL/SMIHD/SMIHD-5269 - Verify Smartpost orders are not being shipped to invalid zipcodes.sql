-- SMIHD-5269 - Verify Smartpost orders are not being shipped to invalid zipcodes
-- Can you tell me if any of the following zip codes were shipped to using Smartpost from 08/17/16 onward?

select * from tblShipMethod

select dtShippedDate, COUNT(*) 'OrdersShipped'
from tblOrder O
    join [SMITemp].dbo.PJC_SMIHD5269_SmartpostDoNotShipZips DNS on O.sShipToZip = DNS.ixZip
where iShipMethod = 15
and dtShippedDate >= '08/10/2016' -- going back a few extra days to show when packages were last shipped to those invalid zips
GROUP BY dtShippedDate
order by dtShippedDate desc



select * from [SMITemp].dbo.PJC_SMIHD5269_SmartpostDoNotShipZips -- 487 zips all starting with 53 or 54
order by ixZip


select * from tblShipMethod