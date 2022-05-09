-- Case 21784 - Price and Cost validation for SOP vs SMIReporting

select count(SOPV.ixSKU) from PJC__SOP_SKU_PriceAndCostValidation SOPV -- 65,535... 65,369 unique
    join [SMI Reporting].dbo.tblSKU  SKU on SKU.ixSKU = SOPV.ixSKU                   -- 65,323
        
select distinct SOPV.ixSKU from PJC_21784_SOP_SKU_PriceAndCostValidation SOPV
where ixSKU not in (select ixSKU from [SMI Reporting].dbo.tblSKU )



-- DROP TABLE PJC_21784_SOP_SKU_PriceAndCostValidation
-- TRUNCATE TABLE PJC_21784_SOP_SKU_PriceAndCostValidation
SELECT ixSKU, mPriceLevel1, mLatestCost as PVCost
into PJC_21784_SOP_SKU_PriceAndCostValidation
from [SMI Reporting].dbo.tblSKU

-- in SOP but not DB
select distinct SOPV.ixSKU from PJC_21784_SOP_SKU_PriceAndCostValidation SOPV
where ixSKU not in (select ixSKU from [SMI Reporting].dbo.tblSKU )

-- in DB but not SOP
select SKU.ixSKU from [SMI Reporting].dbo.tblSKU SKU
where SKU.ixSKU not in (select ixSKU from PJC_21784_SOP_SKU_PriceAndCostValidation    )
and SKU.flgDeletedFromSOP = 0

where  SOPV.mPriceLevel1 <> SKU.mPriceLevel1
-- Retail Prices DO NOT MATCH
SELECT SOPV.ixSKU as SOP_ixSKU, SKU.ixSKU as DB_ixSKU, 
SOPV.mPriceLevel1 as SOP_mPriceLevel1, SKU.mPriceLevel1 as DB_mPriceLevel1,
SOPV.PVCost as SOP_PVCost
 from PJC_21784_SOP_SKU_PriceAndCostValidation SOPV -- 65,535... 65,369 unique
   join [SMI Reporting].dbo.tblSKU  SKU on SKU.ixSKU = SOPV.ixSKU
where  SOPV.mPriceLevel1 <> SKU.mPriceLevel1
   
select * from [SMI Reporting].dbo.tblSKU
where flgDeletedFromSOP = 0   