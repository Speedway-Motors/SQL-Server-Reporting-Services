-- SMIHD-11426 - BOM components that have no sales

SELECT --count(distinct TD.ixSKU) 
    distinct TD.ixSKU 
FROM tblBOMTemplateDetail TD -- 12,519 SKUs components in all BOMTemplates
    left join tblSKU S on S.ixSKU = TD.ixSKU
where TD.flgDeletedFromSOP = 0 
--and TD.ixSKU = '72-32522'
    and TD.ixSKU NOT in (-- SKUs that have been sold by themselves
                        SELECT distinct ixSKU 
                        from tblOrderLine OL
                            left join tblOrder O on OL.ixOrder = O.ixOrder
                        where O.sOrderStatus = 'Shipped'
                        and OL.flgLineStatus IN ('Shipped','Dropshipped')
                        --and OL.ixSKU = '72-32522'
                        and OL.dtOrderDate >= '01/01/2015' -- Sales cutoff per Al
                        ) -- 11,924 SKU components have never had sales
ORDER BY TD.ixSKU
/*
AFCO
18,375 component SKUs
===========================
11,924 have never been sold individually
12,237 no sales since 2010
13,627 no sales since 2015 * 13,627
14,513 no sales since 2017

SMI 
12,519 component SKUs
===========================
 7,392 have never been sold individually
 7,514 no sales since 2010
 8,138 no sales since 2015 * 8,138
 8,668 no sales since 2017
*/

SELECT * from tblBOMTemplateDetail
SELECT * from tblBOMTemplateMaster

select * from tblOrderLine where ixSKU = '72-32522'

select * from tblOrder
where ixOrder in ('636657','637654')
