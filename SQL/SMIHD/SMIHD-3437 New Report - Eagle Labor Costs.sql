-- SMIHD-3437 New Report - Eagle Labor Costs

/*
research conclusions:
due to BOMs being recursive, there is no way that is report can be built so that it is accurate (without grinding the server to a hault).
*/


-- EAGLE LABOR SKUS  provided by Larkins
SELECT * from tblSKU
where ixSKU in ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605')



-- Orderline data
select O.sOrderStatus, OL.* --331
from vwEagleOrder O
    left join vwEagleOrderLine OL on O.ixOrder = OL.ixOrder
where OL.ixSKU in ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605')
    and O.sOrderStatus = 'Shipped' -- 230
    and O.dtShippedDate between '01/01/2015' and '1/03/2016' -- 207
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered     -- 207
order by OL.ixSKU, OL.mCost

-- OL summary grouped by SKU
select OL.ixSKU, S.sDescription, SUM(iQuantity) QtySold, SUM(mExtendedCost) TotExtCost
from vwEagleOrder O
    left join vwEagleOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixSKU in ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605')
    and O.sOrderStatus = 'Shipped' -- 230
    and O.dtShippedDate between '01/01/2015' and '12/31/2015' -- 207
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered     -- 207
group by OL.ixSKU, S.sDescription
/*
ixSKU	sDescription	    QtySold	TotExtCost
94601	EMI SHOP LABOR	    23,793	14,650.14
94605	LABOR TO MOUNT BODY	81	     7,720.60
94604	TORSION BAR DYNO	54	       134.00
*/

/*
-- REFED ALL BOM Templates and flagged newly deleted ones.  All remaining BOM templates are current.
            -- AFTER
            sTableName	            Records	DaysOld
            tblBOMTemplateDetail	27921	   <=1

            tblBOMTemplateMaster	7594	   <=1

            select * from tblBOMTemplateDetail
            where dtDateLastSOPUpdate < '01/28/2016'
            and flgDeletedFromSOP = 0
*/


-- BOM RECURSIVE SUBCOMPONENT CLUSTER!!!!!!!!!
    (SELECT distinct ixFinishedSKU -- 3 BOMs have a sub-component that is a BOM that has a sub-component that is a BOM that has a sub-component that is a labor SKU
    FROM tblBOMTemplateDetail
    where ixSKU in (select distinct ixFinishedSKU -- 50 BOMs have a sub-component that is a BOM that has a sub-component that is a labor SKU
                    from tblBOMTemplateDetail
                    where ixSKU in(-- 301 finished SKUs have a labor SKU as a direct sub-component
                                    select distinct ixFinishedSKU 
                                    from tblBOMTemplateDetail
                                    where ixSKU in ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605') -- 318
                                    and flgDeletedFromSOP = 0                                                                                                                              -- 301
                                    )
                    )
    )
