-- SMIHD-4222 - SMI BOM Labor Costs analysis 

/*    
SELECT * FROM tblBOMTemplateMaster
where flgDeletedFromSOP = 0 -- 7,749 BOM Templates (2,596 have SMI costs   294 have EMI costs   4,859 have no costs
    AND (mSMITotalLaborCost <> 0
    OR mSMITotalMaterialCost <> 0)
   -- OR 
   AND(
    mEMITotalLaborCost <> 0
    OR mEMITotalMaterialCost  <> 0                         
    )
*/

-- Template costs vs tblSKU Latest & Avg cost and Price Level1
-- regardless of sales history
-- results populated SMIHD-4222 - SMI BOM Labor Cost Deltas 05-24-2016 REVISED.xlsb
SELECT TM.ixFinishedSKU,
    S.sDescription,
    TM.mEMITotalLaborCost EMILabor,
    TM.mEMITotalMaterialCost EMIMaterial,
    TM.mSMITotalLaborCost SMILabor,
    TM.mSMITotalMaterialCost SMIMaterial,
    (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 'TotBOMCost',
    S.mAverageCost,
    S.mLatestCost,
    S.mPriceLevel1    
FROM tblBOMTemplateMaster TM
    join tblSKU S on S.ixSKU = TM.ixFinishedSKU
    join vwSKULocalLocation SKULL on S.ixSKU = SKULL.ixSKU
    join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
WHERE S.flgDeletedFromSOP = 0
and TM.flgDeletedFromSOP = 0
and (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)  > 0
and S.dtDiscontinuedDate > '05/23/2016'
and VS.ixVendor <> '0900'



SELECT * FROM tblBOMTemplateMaster
where dtDateLastSOPUpdate < '05/24/2016'
and flgDeletedFromSOP = 0





DECLARE
    @StartShipDate datetime,
    @EndShipDate datetime
SELECT
    @StartShipDate = '01/01/2015', -- P3 = 03.05.16 - 4.01.16
    @EndShipDate = '12/31/2015'  
-- SKU Detail report
SELECT SKU.ixSKU AS 'FinishedSKU' 
    , SKU.sDescription AS 'Description'
    , VS.ixVendor 'PVendor'
    , PGC.ixPGC AS 'PGC'      
    , SKU.mPriceLevel1 AS 'PriceLevel1'     
    , (CASE WHEN BOM.ixSKU IS NULL THEN 'N' -- all of them are finished SKUs
            ELSE 'Y'
      END) AS 'BOMCompnt'
    , isnull(SALES.Sales,0) as 'Sales'
    , isnull(SALES.QtySold,0) as QtySold
    -- /* SMI Costs
    , TM.mSMITotalLaborCost 'SMILaborCost'
    , TM.mSMITotalMaterialCost 'SMIMaterialCost'
    , isnull(SALES.QtySold,0)* isnull(TM.mSMITotalLaborCost,0) AS 'ExtSMILaborCost'
    , isnull(SALES.QtySold,0)* isnull(TM.mSMITotalMaterialCost,0) AS 'ExtSMIMaterialCost',
    -- */
    /* EAGLE Costs   
    , TM.mEMITotalLaborCost 'EMILaborCost'
    , TM.mEMITotalMaterialCost 'EMIMaterialCost'   
    , isnull(SALES.QtySold,0)* isnull(TM.mEMITotalLaborCost,0) AS 'ExtEMILaborCost'
    , isnull(SALES.QtySold,0)* isnull(TM.mEMITotalMaterialCost,0) AS 'ExtEMIMaterialCost'       
    */
    SKU.mAverageCost, 
    ABS(SKU.mAverageCost-(TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 'AvgCostDELTA',    
    SKU.mLatestCost,
    ABS(SKU.mLatestCost-(TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 'LatestCostDELTA'  
FROM tblSKU SKU
         JOIN tblBOMTemplateMaster TM ON SKU.ixSKU = TM.ixFinishedSKU
         JOIN tblVendorSKU VS ON SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblPGC PGC ON PGC.ixPGC = SKU.ixPGC
    LEFT JOIN (SELECT OL.ixSKU, SUM(OL.iQuantity) QtySold, SUM(OL.mExtendedPrice) Sales
               FROM tblOrderLine OL
                    join tblOrder O on OL.ixOrder = O.ixOrder
               WHERE O.dtShippedDate between @StartShipDate and @EndShipDate --'01/03/2015' and '01/30/2015'
                  and O.sOrderStatus = 'Shipped'
                  and OL.flgLineStatus IN ('Shipped','Dropshipped')
                  -- and OL.flgKitComponent = 0 -- THIS REQUIREMENT WAS NOT IN THE INITIAL RUN
                --and O.sOrderType <> 'Internal'   -- USUALLY filtered
		       GROUP BY OL.ixSKU
		      ) SALES ON SALES.ixSKU = SKU.ixSKU
    LEFT JOIN (-- BOM Components
                SELECT DISTINCT (ixSKU)
               FROM tblBOMTemplateDetail
              ) BOM ON BOM.ixSKU = SKU.ixSKU
WHERE TM.flgDeletedFromSOP = 0 -- 7749
    -- /* SMI cost values
       AND (TM.mSMITotalLaborCost <> 0
            OR 
            TM.mSMITotalMaterialCost <> 0
        )
     --  AND SKU.ixSKU = '91034502'
     -- */
       /*-- EAGLE cost values
        AND (TM.mEMITotalLaborCost <> 0
            OR 
            TM.mEMITotalMaterialCost <> 0
        )
        */       
    -- AND isnull(SALES.Sales,0) > 0        
    
   /* -- the following is to show BOMs that have had sales since 1/1/2015 but dont' have Labor or Material costs
   AND TM.mSMITotalLaborCost = 0
   AND TM.mSMITotalMaterialCost = 0
   AND TM.mEMITotalLaborCost = 0
   AND TM.mEMITotalMaterialCost  = 0
   AND isnull(SALES.QtySold,0) > 0   
   AND isnull(SALES.Sales,0) > 0
    */
    
    


/*** SKUS THAT WE APPEAR TO BE SELLING FOR LESS THAN THEIR COST ***/
select TM.ixFinishedSKU, 
    TM.mSMITotalMaterialCost, TM.mSMITotalLaborCost,
    (TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 'SMITotalCombinedCost',
    S.mPriceLevel1 'PriceLevel1',
    (S.mPriceLevel1-(TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 'PriceVsCostDelta'
    -- S.flgBackorderAccepted
 from tblBOMTemplateMaster TM
    join tblSKU S on S.ixSKU = TM.ixFinishedSKU
where (TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) <  S.mPriceLevel1   
and flgActive = 1
and S.flgDeletedFromSOP = 0
and S.mPriceLevel1 > 0
-- where ixFinishedSKU = '5902236-F-1'
order by (S.mPriceLevel1-(TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 
