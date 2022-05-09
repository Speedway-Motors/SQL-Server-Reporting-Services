-- SMIHD-2076 - List of BOM component SKUs to ID SKUs that can not be sold alone.
select * from tblBOMTemplateDetail
where flgDeletedFromSOP = 0
and dtDateLastSOPUpdate < '08/28/2015'
order by 



update tblBOMTemplateDetail
set flgDeletedFromSOP = 1
where ixFinishedSKU = '213SN9A1060'


select distinct ixSKU 
--into [SMITemp].dbo.PJC_BOM_SKUs -- 7,950
from tblBOMTemplateDetail
where flgDeletedFromSOP = 0
order by ixSKU


select * from [SMITemp].dbo.PJC_BOM_SKUs BL
where BL.ixSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)
-- none are deleted

-- final query for spreadsheet
select BL.ixSKU, S.sDescription,
    S.dtDiscontinuedDate, S.dtCreateDate, S.flgActive, S.mPriceLevel1,
    S.ixPGC, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart,
    QS.QtySold,
    SKULL.iQAV,
    BOMUSAGE.TotalQty '12MoBOMUsage'
    
from [SMITemp].dbo.PJC_BOM_SKUs BL
left join tblSKU S on BL.ixSKU = S.ixSKU
left join (-- Tot Qty Sold since 2007
            select OL.ixSKU, SUM(OL.iQuantity) 'QtySold'
           from tblOrderLine OL
            left join tblOrder O on OL.ixOrder = O.ixOrder
           where O.sOrderStatus = 'Shipped'
             --and O.dtShippedDate between '01/01/2014' and '12/31/2014'
             and O.mMerchandise > 0 -- > 1 if looking at non-US orders
             and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
           group by OL.ixSKU
           ) QS on BL.ixSKU = QS.ixSKU
-- 12 MO. BOM USAGE 
LEFT JOIN (SELECT ST.ixSKU
		        , SUM(ST.iQty) * -1 AS TotalQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
			 and ST.sTransactionType = 'BOM' 
			 and ST.iQty < 0
			-- AND ST.ixSKU = '91599097-1' 
		   GROUP BY ST.ixSKU) AS BOMUSAGE ON BOMUSAGE.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  = BL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS               
left join vwSKULocalLocation SKULL on BL.ixSKU = SKULL.ixSKU           
where S.flgIntangible = 0          
order by S.mPriceLevel1, QS.QtySold, S.dtCreateDate           
           
 