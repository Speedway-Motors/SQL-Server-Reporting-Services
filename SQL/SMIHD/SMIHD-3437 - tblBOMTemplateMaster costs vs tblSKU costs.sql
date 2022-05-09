-- SMIHD-3437 - tblBOMTemplateMaster costs vs tblSKU costs
SELECT T.ixFinishedSKU as 'SKU',
    S.sDescription 'SKU Description',
    T.mEMITotalLaborCost 'EMILabor',
    T.mEMITotalMaterialCost 'EMIMaterial',
    (T.mEMITotalLaborCost + T.mEMITotalMaterialCost) 'EMITotCost',
    T.mSMITotalLaborCost 'SMILabor',
    T.mSMITotalMaterialCost 'SMIMaterial',
    (T.mSMITotalLaborCost + T.mSMITotalMaterialCost) 'SMITotCost',
    (T.mSMITotalLaborCost + T.mSMITotalMaterialCost + T.mEMITotalLaborCost + T.mEMITotalMaterialCost) 'TotTemplateCost',
    S.mPriceLevel1 'SKUPriceLvl1',    
    S.mLatestCost 'SKULatestCost', S.mAverageCost'SKUAvgCost'
--,S.dtDateLastSOPUpdate
--((T.mSMITotalLaborCost + T.mSMITotalMaterialCost + T.mEMITotalLaborCost + T.mEMITotalMaterialCost) /*TemplateCost*/ /((isnull(S.mLatestCost, .001)+((isnull(S.mAverageCost,.001))/2)))) 'Delta'
from tblBOMTemplateMaster T
    left join tblSKU S on T.ixFinishedSKU = S.ixSKU
where T.mEMITotalLaborCost <> 0 
    OR T.mEMITotalMaterialCost <> 0 
    OR T.mSMITotalLaborCost <> 0 
    OR T.mSMITotalMaterialCost <> 0
    
-- ORDER BY S.dtDateLastSOPUpdate




