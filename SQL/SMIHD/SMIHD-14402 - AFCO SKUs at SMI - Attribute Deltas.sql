-- SMIHD-14402 - AFCO SKUs at SMI - Attribute Deltas
-- AFCO SKUs at SMI - Weight and Dimension Deltas
-- ver 2019.28.3

SELECT S.ixSKU 'SMI_SKU', 
    S.sDescription 'SMI_SKUDescription', 
    VS.ixVendor 'PV', 
    V.sName 'VendorName', VS.sVendorSKU 'AFCO_SKU',
    S.dWeight 'SMI_Weight', AFS.dWeight 'AFCO_Weight', ABS(ISNULL(S.dWeight,0)- ISNULL(AFS.dWeight,0)) 'WeightDelta',
    S.iLength 'SMI_L', AFS.iLength 'AFCO_L', ABS(ISNULL(S.iLength,0)- ISNULL(AFS.iLength,0)) 'LengthDelta',
    S.iWidth 'SMI_W', AFS.iWidth 'AFCO_W', ABS(ISNULL(S.iWidth,0)- ISNULL(AFS.iWidth,0)) 'WidthDelta',
    S.iHeight 'SMI_H', AFS.iHeight 'AFCO_H', ABS(ISNULL(S.iHeight,0)- ISNULL(AFS.iHeight,0)) 'HeightDelta',
    --ISNULL(S.iLength,0)+ISNULL(S.iWidth)+ISNULL(S.iHeight) 'SMI_SUMofDim', 
    --ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth)+ISNULL(AFS.iHeight) 'AFCO_SUMofDim',
    ABS((ISNULL(S.iLength,0)+ISNULL(S.iWidth,0)+ISNULL(S.iHeight,0)) - (ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth,0)+ISNULL(AFS.iHeight,0))) 'DeltaOfSumOfDim',  -- ABS(SMI_SUMofDim - AFCO_SUMofDim)
    (CASE WHEN S.flgActive = 1 THEN 'Y'
         WHEN S.flgActive = 0 THEN 'N'
         ELSE 'UK'
         END
     ) 'SMI_Active',
    (CASE WHEN AFS.flgActive = 1 THEN 'Y'
         WHEN AFS.flgActive = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'AFCO_Active',
    ISNULL(SALES.QtySold12Mo,0) 'SMI_QtySold12Mo',
    ISNULL(AFCOSALES.QtySold12Mo,0) 'AFCO_QtySold12Mo',
    S.mPriceLevel1 'SMI_PriceLevel1',
    AFS.mPriceLevel1 'AFCO_PriceLevel1',
    SKUM.iQOS 'SMI_QOS',
    SL.sPickingBin 'SMI_PickingBin',
    AFCOSKUM.iQOS 'AFCO_QOS',
    AFSL.sPickingBin 'AFCO_PickingBin',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
         WHEN S.flgIsKit = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'SMI_Kit',
    (CASE WHEN AFS.flgIsKit = 1 THEN 'Y'
         WHEN AFS.flgIsKit = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'AFCO_Kit',
    (CASE WHEN SMIBOM.ixSKU is NOT NULL THEN 'Y'
         ELSE 'N'
         END
    ) 'SMI_BOM',
    (CASE WHEN AFCOBOM.ixSKU is NOT NULL THEN 'Y'
         ELSE 'N'
         END
     ) 'AFCO_BOM',
     S.dtDiscontinuedDate 'SMI_DiscontinuedDate',
     AFS.dtDiscontinuedDate 'AFCO_DiscontinuedDate'
FROM tblSKU S
    LEFT join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN [AFCOReporting].dbo.tblSKU AFS on AFS.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
               SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                   SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
               FROM tblOrderLine OL 
                   left join tblDate D on D.dtDate = OL.dtOrderDate 
               WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                   and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
               GROUP BY OL.ixSKU
               ) SALES on SALES.ixSKU = S.ixSKU  
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
               SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                   SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
               FROM [AFCOReporting].dbo.tblOrderLine OL 
                   left join [AFCOReporting].dbo.tblDate D on D.dtDate = OL.dtOrderDate 
               WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                   and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
               GROUP BY OL.ixSKU
               ) AFCOSALES on AFCOSALES.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN vwSKUMultiLocation SKUM on SKUM.ixSKU = S.ixSKU
    LEFT JOIN [AFCOReporting].dbo.vwSKUMultiLocation AFCOSKUM on AFCOSKUM.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (-- IS THE SKU A BOM?
              SELECT S.ixSKU
              FROM tblSKU S
                left join tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
              WHERE S.flgDeletedFromSOP = 0
                and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
              ) SMIBOM on SMIBOM.ixSKU = S.ixSKU
    LEFT JOIN (-- IS THE SKU A BOM?
              SELECT S.ixSKU
              FROM [AFCOReporting].dbo.tblSKU S
                left join [AFCOReporting].dbo.tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
              WHERE S.flgDeletedFromSOP = 0
                and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
              ) AFCOBOM on AFCOBOM.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    LEFT JOIN [AFCOReporting].dbo.tblSKULocation AFSL on AFSL.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS and AFSL.ixLocation = 99
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and VS.ixVendor in ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311') -- list provided by RET
ORDER BY ABS((ISNULL(S.iLength,0)+ISNULL(S.iWidth,0)+ISNULL(S.iHeight,0)) - (ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth,0)+ISNULL(AFS.iHeight,0))) DESC, -- ABS(SMI_SUMofDim - AFCO_SUMofDim) 
         ABS(ISNULL(S.dWeight,0)- ISNULL(AFS.dWeight,0)) -- ABS of WeightDelta

-- 160,000 rows if not restricted to location 99 (on both sides)

    
/*     
select ixVendor, FORMAT(count(ixSKU),'###,###') SKUCount
from tblVendorSKU
where ixVendor in ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311')
    and iOrdinality = 1
GROUP BY ixVendor
ORDER BY ixVendor

ix      SKU
Vendor	Count
======  ======
0106	 3,564
0108	12,488
0111	 2,012
0133	    29
0134	 1,089
0136	     1
0311	   282
0313	   886
0475	   632
0476	   370
0578	10,900
0582	   339
9106	 5,765
*/





