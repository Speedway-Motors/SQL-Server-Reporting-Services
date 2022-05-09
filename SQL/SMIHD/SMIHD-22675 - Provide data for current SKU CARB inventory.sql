-- SMIHD-22675 - Provide data for current SKU CARB inventory

-- REWORKING without location and tblBinSKU
SELECT S.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', -- 5,000
    dtCreateDate 'CreateDate', dtDiscontinuedDate 'DiscontinuedDate', flgActive, 
    dWeight, ixBrand, iLength, iWidth, iHeight, 
    sSEMACategory, sSEMASubCategory, sSEMAPart, 
    flgMadeToOrder, sCountryOfOrigin, 
    flgProp65, flgCARB, sCARBSubclass, sCARBEONumber, 
    SALES.QtySold12Mo,
    SUM(SL.iQOS) 'TotalQOS'
--INTO #TempResults
FROM tblSKU S
    LEFT JOIN tblSKULocation SL on SL.ixSKU = S.ixSKU
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    left join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU  
WHERE S.flgIsKit = 0
    and S.flgCARB <> 0
    and S.ixDiscontinuedDate > 19625
    and SL.iQOS > 0
    and S.ixSKU not like ('UP%')
    and S.ixSKU not like ('AUP%')
    and S.ixSKU not like ('NS%')
GROUP BY S.ixSKU, ISNULL(S.sWebDescription, S.sDescription), -- 13,851
    dtCreateDate, dtDiscontinuedDate, flgActive, 
    dWeight, ixBrand, iLength, iWidth, iHeight, 
    sSEMACategory, sSEMASubCategory, sSEMAPart, 
    flgMadeToOrder, sCountryOfOrigin, 
    flgProp65, flgCARB, sCARBSubclass, sCARBEONumber,
    SALES.QtySold12Mo
ORDER BY S.ixSKU    
    -- SALES.QtySold12Mo DESC


-- sku 91015315 
-- 12mo qty 3272
 SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    left join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and OL.ixSKU = '91015315'
                GROUP BY OL.ixSKU