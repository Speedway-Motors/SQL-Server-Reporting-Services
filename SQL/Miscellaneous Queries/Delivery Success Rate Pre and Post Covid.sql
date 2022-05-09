-- Delivery Success Rate Pre and Post Covid

-- BRANT has a Tableau data set "Perfect Order?" that has an excellent breakdown 
-- of the info below and the filters are much easier to apply!


select sShipToZip, mShipping, ixOrder
into #Temp12MoSuccess -- DROP TABLE Temp12MoSuccess
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '1'   -- 9,336 not met   80,273 met   89.6% success
    and dtShippedDate between '07/01/19' and '06/30/20'   
    and iShipMethod = '2'
order by sShipToZip

select sShipToZip, mShipping, ixOrder 
into #Temp12MoFail -- DROP TABLE #Temp12MoFail
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '0'   -- 9,336 not met   80,273 met   89.6% success
    and dtShippedDate between '07/01/19' and '06/30/20'   
    and iShipMethod = '2'
order by sShipToZip

select count(*) from #Temp12MoSuccess -- 80,273
select count(*) from #Temp12MoFail    -- 9,336

select count(distinct sShipToZip) from #Temp12MoSuccess -- 16,827
select count(distinct sShipToZip) from #Temp12MoFail    -- 5,806

SELECT ISNULL(S.sShipToZip,F.sShipToZip), -- total rows should be between 16,827 & 22,633 v
    COUNT(distinct S.ixOrder) 'OrdsSucceeded', 
    COUNT(distinct F.ixOrder) 'OrdsFailed',
    COUNT(distinct S.ixOrder) + COUNT(distinct F.ixOrder) 'TotOrds'
FROM #Temp12MoSuccess S
    FULL OUTER JOIN #Temp12MoFail F on S.sShipToZip = F.sShipToZip
GROUP BY ISNULL(S.sShipToZip,F.sShipToZip)
ORDER BY COUNT(S.ixOrder) + COUNT(F.ixOrder) desc

select sShipToZip, mShipping 
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '0'   -- 9,336 not met   80,273 met     89.6% success
    and dtShippedDate between '07/01/19' and '06/30/20'   
    and iShipMethod = '2'
order by sShipToZip

select sShipToZip, mShipping 
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '1'   -- 3,827 not met   55,862 met     93.6% success
    and dtShippedDate between '07/01/18' and '06/30/19'   
    and iShipMethod = '2'
order by sShipToZip

select sShipToZip, mShipping 
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '0'   -- 4,126 not met   57,938 met     93.4% success
    and dtShippedDate between '07/01/17' and '06/30/18'   
    and iShipMethod = '2'
order by sShipToZip


-- 12 months pre-covid
select sShipToZip, mShipping 
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '1'   -- 4,868 not met   66,412 met     93.1% success
    and dtShippedDate between '03/01/19' and '02/28/20'   
    and iShipMethod = '2'
order by sShipToZip

-- Covid to present
select sShipToZip, mShipping 
from tblOrder   
where ixGuaranteeDelivery is not null   
    and flgGuaranteedDeliveryPromised = '1'   
    and flgDeliveryPromiseMet = '0'   -- 5,744 not met   37,401 met     86.7% success
    and dtShippedDate between '03/01/20' and '07/01/20'   
    and iShipMethod = '2'
order by sShipToZip

/* 

Guaranteed Delivery success rates

03/01/19 - 02/28/20     93.1% success    pre-covid
03/01/20 - 07/01/20     86.7% success

*/
