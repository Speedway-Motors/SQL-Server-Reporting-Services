-- SMIHD-8089 - Shipping Weight and Dimension for Vendor 1018

SELECT X.ixSKU, S.iLength, S.iWidth, S.iHeight, S.dDimWeight
FROM PJC_SMIHD8089_SKUsNeedingDeminsionalData X -- 2,438
    join [SMI Reporting].dbo.tblSKU S on X.ixSKU = S.ixSKU

