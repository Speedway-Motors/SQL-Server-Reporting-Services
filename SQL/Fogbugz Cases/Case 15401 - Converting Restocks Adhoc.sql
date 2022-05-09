SELECT SL.ixSKU as SKU
     , P2M.LYQuantity  as TwelveMonthSales
     , SL.iPickingBinMax as PickBinMax
     , SL.iPickingBinMin as PickBinMin
     , SL.iCartonQuantity as CaseQty
     , SL.sPickingBin as Bin
     , (P2M.LYQuantity/NULLIF((SL.iPickingBinMax-SL.iPickingBinMin),0)) as CurrentRestocks
     , ((P2M.LYQuantity/11)*2/15) as RecommendedMin
     , (((P2M.LYQuantity/11)*2/15)-SL.iPickingBinMin) as RecommendedAdj
     --, (P2M.LYQuantity/nullif(((SL.iPickingBinMax-(P2M.LYQuantity/11)*2/15)),0)) as 'Expected Restocks Per Year'
       --flag potential max problem
     , (CASE WHEN ((P2M.LYQuantity/NULLIF(((SL.iPickingBinMax-(P2M.LYQuantity/11)*2/15)),0)) >
                   (P2M.LYQuantity/NULLIF((SL.iPickingBinMax-SL.iPickingBinMin),0))) THEN 'Y' 
             ELSE '' 
        END) as PotentialBinMaxProblem      
       --, (P2M.LYQuantity/nullif((SL.iPickingBinMax-((P2M.LYQuantity/11)*2/15)),0)) as 'Expected Restocks Per Year'
       --, (P2M.LYQuantity/nullif((((P2M.LYQuantity/11)*2/15)),0)) as 'Expected Restocks Per Year'
       --flag if pick bin max not a multiple of case quantity
     , (CASE WHEN (SL.iPickingBinMax % NULLIF(SL.iCartonQuantity,0)) <> 0 THEN 'Y' 
             ELSE '' 
        END) as BinMaxNotaMultipleofCaseQty
FROM  tblSKULocation SL
LEFT JOIN tblSKU S on S.ixSKU = SL.ixSKU
LEFT JOIN vwSKUTotalPrev12Months P2M on P2M.ixSKU = SL.ixSKU
WHERE SL.ixLocation = '99'
  AND P2M.LYQuantity > '0'
  AND S.flgIntangible = '0'
  AND SL.sPickingBin NOT LIKE 'V%'
  AND SL.sPickingBin NOT IN ('Z.NEW', '9999', 'A KIT', 'SHOCK')
  AND S.ixSKU NOT LIKE 'UP%'
  AND P2M.LYQuantity > '12'
  AND (P2M.LYQuantity/NULLIF((SL.iPickingBinMax-SL.iPickingBinMin),0)) > '24'
ORDER BY RecommendedAdj DESC
       , TwelveMonthSales DESC