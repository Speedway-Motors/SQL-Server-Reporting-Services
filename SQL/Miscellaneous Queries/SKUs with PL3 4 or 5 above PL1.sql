

-- SKUs with PL3 4 or 5 above PL1
SELECT CD.ixCatalog, CD.ixSKU, CD.mPriceLevel1, CD.mPriceLevel2, CD.mPriceLevel3, CD.mPriceLevel4, CD.mPriceLevel5, S.dtDateLastSOPUpdate, S.flgActive
   -- , S.mPriceLevel1, S.mPriceLevel2, S.mPriceLevel3, S.mPriceLevel4, S.mPriceLevel5
FROM tblCatalogDetail CD
    left join tblSKU S on CD.ixSKU = S.ixSKU
where CD.ixCatalog = 'PRS.19'
and S.flgDeletedFromSOP = 0
and (CD.mPriceLevel3 > CD.mPriceLevel1
    or CD.mPriceLevel4 > CD.mPriceLevel1 
    or CD.mPriceLevel5 > CD.mPriceLevel1 
    )




ixCatalog	ixSKU	mPriceLevel1	mPriceLevel2	mPriceLevel3	mPriceLevel4	mPriceLevel5
PRS.19	42511510HKR	34.99	34.99	37.98	37.97	34.95


SELECT CD.ixCatalog, CD.ixSKU, CD.mPriceLevel1, CD.mPriceLevel2, CD.mPriceLevel3, CD.mPriceLevel4, CD.mPriceLevel5, S.dtDateLastSOPUpdate, S.flgActive
   -- , S.mPriceLevel1, S.mPriceLevel2, S.mPriceLevel3, S.mPriceLevel4, S.mPriceLevel5
FROM tblCatalogDetail CD
    left join tblSKU S on CD.ixSKU = S.ixSKU
WHERE CD.ixCatalog = 'PRS.19'
and CD.ixSKU like 'UP%'
