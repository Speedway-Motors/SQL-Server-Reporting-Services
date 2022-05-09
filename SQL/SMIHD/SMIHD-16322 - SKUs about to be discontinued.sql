/* SMIHD-16322 - SKUs about to be discontinued
    ver 20.3.1

DECLARE @StartDate datetime,        @EndDate datetime,      @Merchant varchar(10)
SELECT  @StartDate = '01/14/20',    @EndDate = '12/31/20',  @Merchant = 'NJS'
*/
SELECT S.ixMerchant 'Merchant', 
    SPR.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SPR.iQtyAvailable 'QAV',  -- confirmed QAV and QOS are the SUMs of ALL LOCATIONS
    SPR.iQOS 'QOS',
    SPR.sPrimeVendor 'PVnum',
    SPR.sPrimeVendorName 'PVName',
    S.ixPGC 'PGC',
    SPR.m12MonthSales 'Sales12Mo', 
    dtLastSale 'LastSold',
    dtLastBOMConsumption 'LastBOMConsumption',
    S.dtDiscontinuedDate
FROM tblSKU S
    left join tblSKUProfitabilityRollup SPR on S.ixSKU = SPR.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
    and S.dtDiscontinuedDate between @StartDate and @EndDate -- getdate() and '01/31/2020'
    and (S.ixMerchant in (@Merchant)
         OR
         S.ixMerchant is NULL)
ORDER BY S.ixMerchant


-- select top 10 * from tblSKUProfitabilityRollup

select ixMerchant, FORMAT(count(*),'###,###') SKUcnt
from tblSKU
where flgDeletedFromSOP = 0
    and flgActive = 1
group by ixMerchant

select distinct ixMerchant
from tblSKU
where flgDeletedFromSOP = 0
    and ixMerchant is NOT NULL


SELECT * from tblEmployee
where ixEmployee in ('ACO','CAK1','CGN','DAS','JAK','JDS','JOS','JRB','KDL','KJH','NJS','RCE','RET','RJF','SAL','WAA1')

select * from tblSKU
where ixMerchant = 'CAK1'
and flgActive = 1





GREG	NICOL
JEFFREY	KARLS
NICHOLAS	SOMMERFELD
RYAN	EBKE
SMALL	DUSTIN
KDL






