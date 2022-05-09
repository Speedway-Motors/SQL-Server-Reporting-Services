-- SMIHD-1114 - batch of 675 new SKUs uploaded to SOP for Wheel Pros

-- Dupe check
select COUNT(*) 'TotSKUs', 
    COUNT(distinct ixSKU) 'DistSKUs',
    (COUNT(*)-COUNT(distinct ixSKU)) 'Delta'
from [SMITemp].dbo.PJC_SMIHD_1114_SKU_batch_created
/*
TotSKUs	DistSKUs	Delta
675	    675	        0
*/



-- ALL in tblSKU?
select COUNT(B.ixSKU) 'TotSKUs', 
    COUNT(distinct B.ixSKU) 'DistSKUs',
    (COUNT(B.ixSKU)-COUNT(distinct B.ixSKU)) 'Delta'
from [SMITemp].dbo.PJC_SMIHD_1114_SKU_batch_created B
join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = B.ixSKU




-- SKUs that are not in tlbSKU
select * from [SMITemp].dbo.PJC_SMIHD_1114_SKU_batch_created B
where B.ixSKU NOT in (Select ixSKU from [SMI Reporting].dbo.tblSKU where flgDeletedFromSOP = 0)
-- NONE




-- ANY SOP errors for tblSKU
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM [SMI Reporting].dbo.tblErrorLogMaster
WHERE ixErrorCode = '1163'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
ORDER BY dtDate desc
-- NONE