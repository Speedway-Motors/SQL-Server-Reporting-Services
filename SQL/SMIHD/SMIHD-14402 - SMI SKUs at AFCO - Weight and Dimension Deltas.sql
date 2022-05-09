-- SMIHD-14402 - SMI SKUs at AFCO - Weight and Dimension Deltas
-- ver 2019.28.1

/******************************************************************/
/*************      INVERSE REPORT      ***************************/
/*************    (SMI SKUs at AFCO)    ***************************/
/******************************************************************/

SELECT S.ixSKU 'AFCO_SKU', 
    S.sDescription 'AFCO_SKUDescription', 
    VS.ixVendor 'PV', 
    V.sName 'VendorName', VS.sVendorSKU 'SMI_SKU',
    S.dWeight 'AFCO_Weight', AFS.dWeight 'SMI_Weight', ABS(ISNULL(S.dWeight,0)- ISNULL(AFS.dWeight,0)) 'WeightDelta',
    S.iLength 'AFCO_L', AFS.iLength 'SMI_L', ABS(ISNULL(S.iLength,0)- ISNULL(AFS.iLength,0)) 'LengthDelta',
    S.iWidth 'AFCO_W', AFS.iWidth 'SMI_W', ABS(ISNULL(S.iWidth,0)- ISNULL(AFS.iWidth,0)) 'WidthDelta',
    S.iHeight 'AFCO_H', AFS.iHeight 'SMI_H', ABS(ISNULL(S.iHeight,0)- ISNULL(AFS.iHeight,0)) 'HeightDelta',
    --ISNULL(S.iLength,0)+ISNULL(S.iWidth)+ISNULL(S.iHeight) 'AFCO_SUMofDim', 
    --ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth)+ISNULL(AFS.iHeight) 'SMI_SUMofDim',
    ABS((ISNULL(S.iLength,0)+ISNULL(S.iWidth,0)+ISNULL(S.iHeight,0)) - (ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth,0)+ISNULL(AFS.iHeight,0))) 'DeltaOfSumOfDim',  -- ABS(AFCO_SUMofDim - SMI_SUMofDim)
    (CASE WHEN S.flgActive = 1 THEN 'Y'
         WHEN S.flgActive = 0 THEN 'N'
         ELSE 'UK'
         END
     ) 'AFCO_Active',
    (CASE WHEN AFS.flgActive = 1 THEN 'Y'
         WHEN AFS.flgActive = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'SMI_Active',
    ISNULL(SALES.QtySold12Mo,0) 'AFCO_QtySold12Mo',
    ISNULL(SMISALES.QtySold12Mo,0) 'SMI_QtySold12Mo',
    S.mPriceLevel1 'AFCO_PriceLevel1',
    AFS.mPriceLevel1 'SMI_PriceLevel1',
    SKUM.iQOS 'AFCO_QOS',
    SL.sPickingBin 'AFCO_PickingBin',
    AFCOSKUM.iQOS 'SMI_QOS',
    AFSL.sPickingBin 'SMI_PickingBin',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
         WHEN S.flgIsKit = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'AFCO_Kit',
    (CASE WHEN AFS.flgIsKit = 1 THEN 'Y'
         WHEN AFS.flgIsKit = 0 THEN 'N'
         ELSE 'UK'
         END
    ) 'SMI_Kit',
    (CASE WHEN AFCOBOM.ixSKU is NOT NULL THEN 'Y'
         ELSE 'N'
         END
    ) 'AFCO_BOM',
    (CASE WHEN AFCOBOM.ixSKU is NOT NULL THEN 'Y'
         ELSE 'N'
         END
     ) 'SMI_BOM',
     S.dtDiscontinuedDate 'AFCO_DiscontinuedDate',
     AFS.dtDiscontinuedDate 'SMI_DiscontinuedDate'
FROM [AFCOReporting].dbo.tblSKU S
    LEFT join [AFCOReporting].dbo.tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    LEFT JOIN [AFCOReporting].dbo.tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN [SMI Reporting].dbo.tblSKU AFS on AFS.ixSKU = VS.sVendorSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
               SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                   SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
               FROM [AFCOReporting].dbo.tblOrderLine OL 
                   left join [AFCOReporting].dbo.tblDate D on D.dtDate = OL.dtOrderDate 
               WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                   and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
               GROUP BY OL.ixSKU
               ) SALES on SALES.ixSKU = S.ixSKU  
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
               SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                   SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
               FROM [SMI Reporting].dbo.tblOrderLine OL 
                   left join [SMI Reporting].dbo.tblDate D on D.dtDate = OL.dtOrderDate 
               WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                   and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
               GROUP BY OL.ixSKU
               ) SMISALES on SMISALES.ixSKU = VS.sVendorSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN [AFCOReporting].dbo.vwSKUMultiLocation SKUM on SKUM.ixSKU = S.ixSKU
    LEFT JOIN [SMI Reporting].dbo.vwSKUMultiLocation AFCOSKUM on AFCOSKUM.ixSKU = VS.sVendorSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (-- IS THE SKU A BOM?
              SELECT S.ixSKU
              FROM [AFCOReporting].dbo.tblSKU S
                left join [AFCOReporting].dbo.tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
              WHERE S.flgDeletedFromSOP = 0
                and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
              ) AFCOBOM on AFCOBOM.ixSKU = S.ixSKU
    LEFT JOIN (-- IS THE SKU A BOM?
              SELECT S.ixSKU
              FROM [SMI Reporting].dbo.tblSKU S
                left join [SMI Reporting].dbo.tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
              WHERE S.flgDeletedFromSOP = 0
                and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
              ) SMIBOM on SMIBOM.ixSKU = VS.sVendorSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN [AFCOReporting].dbo.tblSKULocation SL on S.ixSKU = SL.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS and SL.ixLocation = 99 
    LEFT JOIN [SMI Reporting].dbo.tblSKULocation AFSL on AFSL.ixSKU = VS.sVendorSKU  COLLATE SQL_Latin1_General_CP1_CI_AS and AFSL.ixLocation = 99
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and VS.ixVendor in ('0018','0218','1508','1509','5302','6046','6124','6870','7892') -- list provided by RET
ORDER BY ABS((ISNULL(S.iLength,0)+ISNULL(S.iWidth,0)+ISNULL(S.iHeight,0)) - (ISNULL(AFS.iLength,0)+ISNULL(AFS.iWidth,0)+ISNULL(AFS.iHeight,0))) DESC, -- ABS(AFCO_SUMofDim - SMI_SUMofDim) 
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





