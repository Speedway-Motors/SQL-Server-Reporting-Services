-- SMIHD-19772 - AFCO SKU Cost
-- AFCO SKUs sold by Speedway
select S.ixSKU 'SMISKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    b.sBrandDescription 'Brand', VS.ixVendor 'PVNum', V.sName 'PrimaryVendor', VS.mCost 'PVCost', 
    VS.sVendorSKU 'AFCOSKU', AFSKU.mAverageCost 'AFCOAvgCost' 
from tblSKU S 
    left join tblBrand b on b.ixBrand=S.ixBrand
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
    left join [AFCOReporting].dbo.tblSKU AFSKU on AFSKU.ixSKU = VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
    and b.sBrandDescription in ('AFCO','Dynatech','Longacre','Pro Shocks','DeWitts')  -- 48,820
    and S.flgActive = 1 -- 22,942
    and S.ixSKU NOT LIKE 'UP%'
    and S.ixSKU NOT LIKE 'AUP%' -- 21,835
    and V.ixVendor not in ('0009','0108','0134','0313','0476') --        14,0753
ORDER BY S.ixSKU, AFSKU.mAverageCost


select * from tblVendor where ixVendor in ('0009','0108','0134','0313','0476')

/* Questions
Do we want to exclude UP and AUP SKUs?
2) 
