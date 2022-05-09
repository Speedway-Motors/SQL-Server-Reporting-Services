-- SMIHD-4222 - SMI BOM Labor Cost

SELECT * 
FROM [SMITemp].dbo.PJC_BOMCostsAbovePriceLevel1 BC -- 212
join tblSKU S on BC.ixFinishedSKU = S.ixSKU
where S.flgDeletedFromSOP = 0


SELECT DISTINCT -- OL.ixOrder, OL.ixSKU, 
    S.ixSKU,
    S.sDescription, 
   -- OL.iQuantity, OL.mUnitPrice, OL.mExtendedPrice,
    --(OL.iQuantity * (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 'ExtBOMCost',
    -- OL.mExtendedCost,
    TM.mEMITotalLaborCost EMILabor,
    TM.mEMITotalMaterialCost EMIMaterial,
    TM.mSMITotalLaborCost SMILabor,
    TM.mSMITotalMaterialCost SMIMaterial,
    (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) BOMTotCost, 
    S.mPriceLevel1
FROM tblOrderLine OL
    join [SMITemp].dbo.PJC_BOMCostsAbovePriceLevel1 BC on OL.ixSKU = BC.ixFinishedSKU
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblBOMTemplateMaster TM on OL.ixSKU = TM.ixFinishedSKU
    join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/25/2015' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   
    and OL.flgLineStatus = 'Shipped' -- 517
    and OL.flgKitComponent = 0       -- 290
    and S.mPriceLevel1 < (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)
  --  and S.mPriceLevel1 < (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)    
 --   and OL.mUnitPrice < (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) -- 287
  --  and (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) > 20            -- 177   only BOMs that cost $20+
   -- and OL.ixSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030') -- 161
ORDER BY ixSKU--, ixOrder   

select flgLineStatus, COUNT(*)
from tblOrderLine
group by flgLineStatus


SELECT distinct ixPGC
from tblSnapshotSKU
where ixSKU in ('10699017','2113677-RED-L','3041001-S-1','3042001-F-1','3042436','5902234-F-1','5902234-S-1','5902236-S-1','5902237-S-1','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','91035250','9154622-COMP','91637030')

SELECT distinct ixSKU
from tblSnapshotSKU
where ixPGC in ('Sc', 'Rc')
and ixSKU in ('10699017','2113677-RED-L','28711807','3041001-S-1','3042001-F-1','3042436','5902234-F-1','5902234-S-1','5902236-S-1','5902237-S-1','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','91035250','9154622-COMP','91637030')
and ixDate >= 17298




-- BOMs that cost $20+ and were sold in the last 12 months below their cost at least once
SELECT OL.ixSKU, S.sDescription, SUM(OL.iQuantity) 'QtySold', 
    SUM(OL.mExtendedPrice) 'Sales',
    SUM(OL.mExtendedCost) 'OrderlineCost',
    (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 'BOMUnitCost'
    --(SUM(OL.iQuantity) * (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost)) 'ExtBOMCost'
    --OL.mExtendedCost,
    --(TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) BOMTotCost, 
    --S.mPriceLevel1
FROM tblOrderLine OL
    join [SMITemp].dbo.PJC_BOMCostsAbovePriceLevel1 BC on OL.ixSKU = BC.ixFinishedSKU
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblBOMTemplateMaster TM on OL.ixSKU = TM.ixFinishedSKU
    join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/12/2015' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   
    and OL.flgLineStatus = 'Shipped' -- 517
    and OL.flgKitComponent = 0       -- 290
    and OL.ixSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
    /*
    and OL.mUnitPrice < (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) -- 287
    and (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) > 20            -- 177   only BOMs that cost $20+
    */
GROUP BY OL.ixSKU, S.sDescription, (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 
    
ORDER BY ixSKU, ixOrder    

SELECT ixSKU, sDescription, mPriceLevel1, mLatestCost, mAverageCost ,ixPGC, dtDateLastSOPUpdate
from tblSKU
where ixSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
order by ixSKU



SELECT * FROM tblCatalogDetail 
where ixSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
and ixCatalog = 'WEB.16'

SELECT TM.ixFinishedSKU, 
    TM.mEMITotalLaborCost,TM.mEMITotalMaterialCost,TM.mSMITotalLaborCost,TM.mSMITotalMaterialCost,
    (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 'BOM_COMBINED_COSTS',
    S.mPriceLevel1 'SKUPriceLvl1',
    S.mAverageCost 'SKUAvgCost',
    S.mLatestCost 'SKULatestCost'
FROM tblBOMTemplateMaster TM  
    join tblSKU S on TM.ixFinishedSKU = S.ixSKU
where TM.ixFinishedSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
order by TM.ixFinishedSKU


SELECT * FROM tblBOMTemplateDetail where ixFinishedSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
order by ixFinishedSKU


SELECT TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, 
    TM.ixFinishedSKU, 
    --TM.ixCreateDate, TM.ixCreateUser, 
    TM.ixUpdateDate, TM.ixUpdateUser, 
    --TM.iFactor, TM.dtDateLastSOPUpdate, TM.ixTimeLastSOPUpdate, TM.flgDeletedFromSOP, 
    -- TM.mEMITotalLaborCost, TM.mEMITotalMaterialCost, TM.mSMITotalLaborCost, TM.mSMITotalMaterialCost, 
    (TM.mEMITotalLaborCost+TM.mEMITotalMaterialCost+TM.mSMITotalLaborCost+TM.mSMITotalMaterialCost) 'BOMTotalCost',     
    TM.ixLastCostUpdateDate, TM.ixLastCostUpdateTime, TM.ixLastCostUpdateUser
FROM tblBOMTemplateDetail TD
    left join tblBOMTemplateMaster TM on TD.ixSKU = TM.ixFinishedSKU
where TD.ixFinishedSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')
order by TD.ixFinishedSKU

SELECT * FROM tblBOMTemplateMaster TM 
where ixFinishedSKU in ('3041001-S-1','3042001-F-1','3042436','8241112-F-1','8241415-F-1','91034295-L-OVAL','91034295-L-RND','9154622-COMP','91637030')


select * from tblBOMTemplateDetail
where ixFinishedSKU = '3042001-F-1'
order by ixSKU

SELECT * from tblSKU
where ixSKU in ('12100001','30420010','50542152','577555','91014143-1','91014146-1','91599156','91599893','91599944')
order by ixSKU





