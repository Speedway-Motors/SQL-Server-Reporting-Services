SELECT DISTINCT PSSP.ixSKU
FROM dbo.ASC_PromoSkuStartingPool PSSP --3,829 SKUs 
LEFT JOIN [SMI Reporting].dbo.tblSKU S ON S.ixSKU = PSSP.ixSKU 
WHERE S.flgActive = '1' --1,526 rows 


SELECT S.sBaseIndex --115 base indexes 
     , COUNT(DISTINCT PSSP.ixSKU) --1,526 SKUs 
FROM dbo.ASC_PromoSkuStartingPool PSSP --3,829 SKUs 
LEFT JOIN [SMI Reporting].dbo.tblSKU S ON S.ixSKU = PSSP.ixSKU 
WHERE S.flgActive = '1' --1,526 rows 
GROUP BY S.sBaseIndex
