-- SMIHD-1528 - SKU Batch Upload (Holley)

SELECT COUNT(ixSKU) TotSKUCnt,
COUNT(distinct(ixSKU)) DistSKUCnt
from PJC_SMIHD_1528_SKUBatchUploadHolley
/*
TotSKUCnt	DistSKUCnt
9,993	    9,993
*/

-- compairing batch tbl to tblSKU
SELECT B.ixSKU BatchListSKU, S.ixSKU tblSKU -- 9,993
from PJC_SMIHD_1528_SKUBatchUploadHolley B
    left join [SMI Reporting].dbo.tblSKU S  on S.ixSKU = B.ixSKU
order by S.ixSKU,B.ixSKU


-- in tblSKU
SELECT S.ixSKU INtblSKU, S.dtCreateDate, -- 4,247
S.dtDateLastSOPUpdate, T.chTime, 
VS.ixVendor, V.sName VendorName, SALES.Sales
-- S.flgDeletedFromSOP, S.ixTimeLastSOPUpdate  -- 4,247 in tblSKU
from [SMI Reporting].dbo.tblSKU S
    join PJC_SMIHD_1528_SKUBatchUploadHolley B on S.ixSKU = B.ixSKU
    left join [SMI Reporting].dbo.tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join [SMI Reporting].dbo.tblVendor V on V.ixVendor = VS.ixVendor    
    join [SMI Reporting].dbo.tblTime T on T.ixTime = S.ixTimeLastSOPUpdate
    left join (SELECT OL.ixSKU, OL.flgLineStatus, SUM(mExtendedPrice) Sales-- O.sOrderType
                from [SMI Reporting].dbo.tblOrderLine OL
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where ixSKU in ('4257006','4252207','4257009','42530014','42530025','4258007','4256710','4256711','4253004','4256979','4251351','4251352','4251353','4251356','4253410','4252668','4252668','4252040','42512911','42512907','42512918')   
                    and OL.flgLineStatus = 'Shipped'
                group by OL.ixSKU, OL.flgLineStatus--, O.sOrderType
               -- order by OL.flgLineStatus   OL.ixSKU
               ) SALES on S.ixSKU = SALES.ixSKU      
order by SALES.Sales desc, S.dtCreateDate  --S.dtDateLastSOPUpdate desc, T.chTime desc   
    
    

-- Existing SKUs that are already in SOP but do not belong to vendor 0426
SELECT OL.ixSKU, OL.flgLineStatus, SUM(mExtendedPrice) Sales
from [SMI Reporting].dbo.tblOrderLine OL
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
where ixSKU in ('4257006','4252207','4257009','42530014','42530025','4258007','4256710','4256711','4253004','4256979','4251351','4251352','4251353','4251356','4253410','4252668','4252668','4252040','42512911','42512907','42512918')   
    and OL.flgLineStatus = 'Shipped'
group by OL.ixSKU, OL.flgLineStatus
order by OL.flgLineStatus  

select * from [SMI Reporting].dbo.tblSKU
where ixSKU = '4258007'

-- SKUs not in tblSKU yet
SELECT B.ixSKU BatchListSKU, S.ixSKU tblSKU  -- 5,746 Missing
from PJC_SMIHD_1528_SKUBatchUploadHolley B
    left join [SMI Reporting].dbo.tblSKU S  on S.ixSKU = B.ixSKU
where S.ixSKU is NULL    
order by newID() -- S.ixSKU,B.ixSKU
        

        
select * from [SMI Reporting].dbo.tblSKU
where ixSKU like '42510001%' --LGERL  


